import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing1212/models/apiResponse.dart';
import 'package:testing1212/models/patient.dart';
import 'package:testing1212/pages/404.dart';
import 'package:testing1212/pages/ExpandableWidgetContainer.dart';
import 'package:testing1212/pages/BottomNavBar.dart';
import 'package:testing1212/pages/booking.dart';
import 'package:testing1212/pages/somethingWrong.dart';
import 'package:testing1212/service/services.dart';
import 'package:testing1212/service/user_service.dart';
import '../widget/navigation_drawer.dart';
import '/data/my_colors.dart';
import '/widget/my_text.dart';
import 'package:http/http.dart' as http;
import 'package:testing1212/widget/snackbar.dart';
import 'dart:convert';

import 'home.dart';
class Payment extends StatefulWidget {
  String doctorId;
  String email;
  String day;
  String date;
  String schedule;
   Payment({super.key, required this.doctorId, required this.email, required this.day, required this.date, required this.schedule});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  void initState(){
    super.initState();
    _checkLanguageStatus();
  }
  bool _isEnglish =false;
  bool _paymentStarted = false;
  void _checkLanguageStatus() async{
    final prefs = await SharedPreferences.getInstance();
    final isEnglish = prefs.getBool('isEnglish') ?? false;
    setState(() {
      _isEnglish = isEnglish;
    });
  }
  final _accountcontroller = TextEditingController();
 String? _banknamecontroller;
  Future Appointment(BuildContext context) async {
      if (_accountcontroller.text == "" || this._banknamecontroller== "") {
        snackBar.show(
            context,_isEnglish ? "Account Number and Bank Name must be filled" :"የአካውንት ቁጥር እና የባንክ ስም መሞላት አለባቸው", Colors.red);
        print('null values');
      } else {
        setState(() {
          _paymentStarted =true;
        });
        const String patientUrl = "https://teklehaimanothospital.com/api/patientGetData.php";
        final patientResponses = await http.post(Uri.parse(patientUrl), body: {
          "email":widget.email,
        });
        var patientData = jsonDecode(patientResponses.body);
        String patientId = patientData[0]['id'];
        print('patientId :$patientId');
        ApiResponse patientResponse = await getPatients(widget.email);
        if(patientResponse.error == null){
          List<dynamic> patientData = patientResponse.data as List<dynamic>;
          List<dynamic> _patientData =  patientData.cast<Patient>();
          String? patient_id = _patientData[0].id;
          print('patient id: $patient_id');
          var body = {
            "account": _accountcontroller.text,
            "bank_name": this._banknamecontroller,
            "patient_id": patient_id,
            "doctor_id": widget.doctorId,
            "selected_day": widget.day,
            "selected_time": widget.schedule,
            "selected_date": widget.date,
          };
          ApiResponse paymentResponse = await payment(body);
          if(paymentResponse.error == null){
            setState(() {
              _paymentStarted = false;
            });
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> BookingPage(email: widget.email)));
            snackBar.show(
                context,_isEnglish ?
            "${paymentResponse.success}" : "ቀጠሮ ማስያዝ ተሳክቷል።",
                Colors.green);
          }else if(paymentResponse.error == '404'){
            setState(() {
              _paymentStarted = false;
            });
            snackBar.show(
                context, _isEnglish ? "Page not found. please try again" : "ገጹ አልተገኘም። እባክዎ እንደገና ይሞክሩ：：", Colors.red);
          }else{
          setState(() {
            _paymentStarted = false;
          });
          snackBar.show(
              context, _isEnglish ? "Something went wrong. please try again" : "ስህተት ተገኝቷል። እባክዎ እንደገና ይሞክሩ：：", Colors.red);
        }
        }else if(patientResponse.error == '404'){
          setState(() {
            _paymentStarted = false;
          });
          snackBar.show(
              context, _isEnglish ? "Page not found. please try again" : "ገጹ አልተገኘም። እባክዎ እንደገና ይሞክሩ：：", Colors.red);
        }else{
          setState(() {
            _paymentStarted = false;
          });
          snackBar.show(
              context, _isEnglish ? "Something went wrong. please try again" : "ስህተት ተገኝቷል። እባክዎ እንደገና ይሞክሩ：：", Colors.red);
        }

      }

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Services.onBackPressed(context),
      child: Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: MyColors.navBarColor,
          foregroundColor: MyColors.grey_3,
          title:  Text(_isEnglish ? "Make Appointment" : "ቀጠሮ ይያዙ",
            style: MyText.subhead(context)!.copyWith(
                color: MyColors.grey_3, fontSize: 20, fontWeight: FontWeight.w500),
          ),

        ),
        floatingActionButton: const CustomFloatingActionButton(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          scrollDirection: Axis.vertical,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 70,
                  ),
                  Padding(
                    padding:  EdgeInsets.only(bottom: 10.0),
                    child: TextField(
                      obscureText: false,
                      controller: _accountcontroller,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.atm_outlined , color: MyColors.textColor1,),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: MyColors.textColor1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: MyColors.textColor1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.all(15),
                        hintText: 'Account Number',
                        hintStyle: MyText.body1(context)!.copyWith(
                            color: MyColors.textColor1,
                            fontWeight: FontWeight.w500
                        ),
                      ),

                      style: MyText.body1(context)!.copyWith(
                        color: MyColors.textColor1,
                        fontWeight: FontWeight.w500,
                      ),

                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(bottom: 10.0),
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      height: 47,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: MyColors.textColor1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          items: [
                            DropdownMenuItem(value: 'amole',child: Text(_isEnglish ? 'Amole' : 'አሞሌ'),),
                          ],

                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                          hint: Text(_isEnglish ? 'Bank Name' : 'የባንክ ስም',
                            style: MyText.body1(context)!.copyWith(
                                color: MyColors.textColor1,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                          isExpanded: true,
                          value:_banknamecontroller,
                          onChanged: (String? bankcontroller) {
                            setState(() {
                              this._banknamecontroller = bankcontroller!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(height: 35),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 57,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                             backgroundColor: MyColors.navBarColor, elevation: 0),
                          child: Text(_isEnglish ? "Finish" : "ይጨርሱ",
                              style: MyText.subhead(context)!
                                  .copyWith(color: Colors.white)),
                          onPressed: () {
                            Appointment(context);
                          },
                        ),
                      ),
                      SizedBox(height: 10,),
                      if(_paymentStarted)
                        Container(
                           height: 40,
                          child: Center(
                            child: CircularProgressIndicator(),
                          )
                          ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const SubBottomNavBarContainer(),
      ),
    );
  }
}
