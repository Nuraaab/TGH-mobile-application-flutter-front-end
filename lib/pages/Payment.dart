
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
  String price;
  String nameEn;
  String nameAm;
   Payment({super.key, required this.doctorId, required this.email, required this.day, required this.date, required this.schedule, required this.price, required this.nameEn, required this.nameAm});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  void initState(){
    super.initState();
     Skip(context);
    _checkLanguageStatus();
  }
  bool _isEnglish =false;
  bool booking_status = false;
  bool _paymentStarted = false;
  void _checkLanguageStatus() async{
    final prefs = await SharedPreferences.getInstance();
    final isEnglish = prefs.getBool('isEnglish') ?? true;
    setState(() {
      _isEnglish = isEnglish;
    });
  }
  final _transaction_id = TextEditingController();
  String book_id = '';
  // Future Appointment(BuildContext context) async {
  //   print('email ${widget.email}');
  //     if (_transaction_id.text == "") {
  //       snackBar.show(
  //           context,_isEnglish ? "Transaction Id must be filled" :"የደረሰኝ ቁጥር መሞላት አለባቸው", Colors.red);
  //     }else if(widget.price == '0' || widget.price == '' || widget.price == null){
  //       snackBar.show(
  //           context,_isEnglish ? "The price for  ${widget.nameEn} is not specified. you can skip and pay later" :"የ${widget.nameAm} ዋጋ አልተገለጸም፡፡ ሌላ ጊዜ መክፈል ይችላሉ፡፡", Colors.red);
  //     }else {
  //       setState(() {
  //         _paymentStarted =true;
  //       });
  //
  //       ApiResponse patientResponse = await getPatients(widget.email);
  //       if(patientResponse.error == null){
  //         List<dynamic> patientData = patientResponse.data as List<dynamic>;
  //         List<Patient> _patientData = patientData.cast<Patient>();
  //
  //         String? patient_id;
  //
  //         if (_patientData.isNotEmpty) {
  //           patient_id = _patientData[0].id;
  //         } else {
  //           print('empty patient id');
  //         }
  //         var body = {
  //           "patient_id": patient_id,
  //           "doctor_id": widget.doctorId,
  //           "selected_day": widget.day,
  //           "selected_time": widget.schedule,
  //           "selected_date": widget.date,
  //           "trs_id": _transaction_id.text,
  //           "amount": widget.price,
  //         };
  //         ApiResponse paymentResponse = await payment(body);
  //         if(paymentResponse.error == null){
  //           setState(() {
  //             _paymentStarted = false;
  //           });
  //           Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> BookingPage(email: widget.email)));
  //           snackBar.show(
  //               context,_isEnglish ?
  //           "${paymentResponse.success}" : "ቀጠሮ ማስያዝ ተሳክቷል።",
  //               Colors.green);
  //         }
  //         else if(paymentResponse.error == '404'){
  //           setState(() {
  //             _paymentStarted = false;
  //           });
  //           snackBar.show(
  //               context, _isEnglish ? "Page not found. please try again" : "ገጹ አልተገኘም። እባክዎ እንደገና ይሞክሩ：：", Colors.red);
  //         }else{
  //         setState(() {
  //           _paymentStarted = false;
  //         });
  //         snackBar.show(
  //             context, _isEnglish ? "Something went wrong. please try again" : "ስህተት ተገኝቷል። እባክዎ እንደገና ይሞክሩ patient：：", Colors.red);
  //       }
  //       }else if(patientResponse.error == '404'){
  //         setState(() {
  //           _paymentStarted = false;
  //         });
  //         snackBar.show(
  //             context, _isEnglish ? "Page not found. please try again" : "ገጹ አልተገኘም። እባክዎ እንደገና ይሞክሩ：：", Colors.red);
  //       }else{
  //         setState(() {
  //           _paymentStarted = false;
  //         });
  //         snackBar.show(
  //             context, _isEnglish ? "Something went wrong. please try again" : "ስህተት ተገኝቷል። እባክዎ እንደገና ይሞክሩ：：po", Colors.red);
  //       }
  //     }
  // }

  Future Payment(BuildContext context, String price, String nameEn, String nameAm, String booking_id) async {
    print('price : $price');
    if (_transaction_id.text == "") {
      snackBar.show(
          context,_isEnglish ? "Transaction Id must be filled" :"የደረሰኝ ቁጥር መሞላት አለባቸው", Colors.red);
    }else if(price == '0' || price == '' || price == null){
      snackBar.show(
          context,_isEnglish ? "The price for  ${nameEn} is not specified. you can skip and pay later" :"የ${nameAm} ዋጋ አልተገለጸም፡፡ መዝለል እና ቆይተው መክፈል ይችላሉ፡፡", Colors.red);
    }else {
      var body = {
        "booking_id": booking_id,
        "amount": price,
        "trs_id": _transaction_id.text,
      };
      ApiResponse updatePaymentResponse = await editPayment(body);
      if(updatePaymentResponse.error == null){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> BookingPage(email: widget.email)));
        snackBar.show(
            context,_isEnglish ?
        "${updatePaymentResponse.success}" : "ክፍያዎ ተሳክቷል።",
            Colors.green);
        print('booking id ${booking_id}');
      }
      else if(updatePaymentResponse.error == '404'){
        snackBar.show(
            context, _isEnglish ? "Page not found. please try again" : "ገጹ አልተገኘም። እባክዎ እንደገና ይሞክሩ：：", Colors.red);
      }else{
        snackBar.show(
            context, _isEnglish ? "Something went wrong. please try again" : "ስህተት ተገኝቷል። እባክዎ እንደገና ይሞክሩ patient：：", Colors.red);
      }

    }
  }
  Future Skip(BuildContext context) async {
      ApiResponse patientResponse = await getPatients(widget.email);
      if(patientResponse.error == null){
        List<dynamic> patientData = patientResponse.data as List<dynamic>;
        List<Patient> _patientData = patientData.cast<Patient>();

        String? patient_id;

        if (_patientData.isNotEmpty) {
          patient_id = _patientData[0].id;
        } else {
          print('empty patient id');
        }
        var body = {
          "patient_id": patient_id,
          "doctor_id": widget.doctorId,
          "selected_day": widget.day,
          "selected_time": widget.schedule,
          "selected_date": widget.date,
          "trs_id": '',
          "amount": widget.price,
        };
        ApiResponse paymentResponse = await payment(body);
        if(paymentResponse.error == null){
          setState(() {
            booking_status = true;
            book_id = paymentResponse.book_id!;
          });
        }
        else if(paymentResponse.error == '404'){
          setState(() {
            booking_status = false;
          });

        }else{
          setState(() {
            booking_status = false;
          });

        }
      }else if(patientResponse.error == '404'){
        setState(() {
          booking_status = false;
        });

      }else{
        setState(() {
          booking_status = false;
        });

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
        body: booking_status ? SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          scrollDirection: Axis.vertical,
          child: Align(
            alignment: Alignment.topCenter,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1,
                ),
              ),
              elevation: 2,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Wrap(
                                children: [
                                  Text(
                                    _isEnglish ? 'Telebirr Account' : 'የቴሌ ብር አካውንት',
                                    style: MyText.title(context)!.copyWith(
                                      color: MyColors.textColor1,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                              Text(
                                '1732283948069249025',
                                style: MyText.body1(context)!.copyWith(
                                  color: MyColors.textColor1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(_isEnglish ? 'Dear customer After paying ${widget.price} through our Telebirr account above, enter the transaction id in the form below and send it to us.':
                            'ውድ ደንበኛችን: ከላይ በተቀመጠው የቴሌ ብር አካውንታችን ${widget.price} ብር  ከከፈሉ በኋላ የከፈሉበትን ደረሰኝ  (transaction id) ከታች ባለው ፎርም ላይ አስገብተው ይላኩልን፡፡',
                            style: MyText.body1(context)!.copyWith(
                              color: MyColors.textColor1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                _isEnglish ? 'Doctor Name' : 'የዶክተር ስም',
                                style: MyText.body1(context)!.copyWith(
                                  color: MyColors.textColor1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                _isEnglish ? '${widget.nameEn}' : '${widget.nameAm}',
                                style: MyText.body1(context)!.copyWith(
                                  color: MyColors.textColor1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                _isEnglish ? 'Appointment Date ' : 'የቀጠሮ ቀን',
                                style: MyText.body1(context)!.copyWith(
                                  color: MyColors.textColor1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '${widget.date}',
                                style: MyText.body1(context)!.copyWith(
                                  color: MyColors.textColor1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                _isEnglish ? 'Price' : 'ዋጋ',
                                style: MyText.body1(context)!.copyWith(
                                  color: MyColors.textColor1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(widget.price.isNotEmpty ?
                                '${widget.price}ETB' : '',
                                style: MyText.body1(context)!.copyWith(
                                  color: MyColors.textColor1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Container(height: 15),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: TextField(
                        obscureText: false,
                        controller: _transaction_id,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
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
                          hintText: _isEnglish ? 'Enter Transaction Id' : 'የደረሰኝ ቁጥሩን ያስገቡ',
                          hintStyle: MyText.body1(context)!.copyWith(
                            color: MyColors.textColor1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: MyText.body1(context)!.copyWith(
                          color: MyColors.textColor1,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    Container(height: 15),
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 57,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyColors.navBarColor,
                              elevation: 0,
                            ),
                            child: Text(
                              _isEnglish ? "Finish" : "ይጨርሱ",
                              style: MyText.subhead(context)!
                                  .copyWith(color: Colors.white),
                            ),
                            onPressed: () {
                              Payment(context,widget.price, widget.nameEn, widget.nameAm, book_id);
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        // if (_paymentStarted)
                        //   Container(
                        //     height: 40,
                        //     child: Center(
                        //       child: CircularProgressIndicator(),
                        //     ),
                        //   ),
                      ],
                    ),
                    // TextButton(onPressed: (){
                    //   Skip(context);
                    // }, child: Text(_isEnglish ? 'Do you want to skip the payment?' : 'ክፍያውን መዝለል ይፈልጋሉ?')),
                    Padding(padding: EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'በሚከፍሉበት ጊዜ ችግር ካጋጠመዎት',
                                style: MyText.body1(context)!.copyWith(
                                  color: MyColors.textColor1,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Text(
                                _isEnglish ? 'Short Code' : 'አጭር ቁጥር',
                                style: MyText.body1(context)!.copyWith(
                                  color: MyColors.textColor1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '8175',
                                style: MyText.body1(context)!.copyWith(
                                  color: MyColors.textColor1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Text(
                                _isEnglish ? 'Phone Number' : 'ስልክ ቁጥር',
                                style: MyText.body1(context)!.copyWith(
                                  color: MyColors.textColor1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '+251940333333',
                                style: MyText.body1(context)!.copyWith(
                                  color: MyColors.textColor1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Text(
                                _isEnglish ? 'Email' : 'ኢሜል',
                                style: MyText.body1(context)!.copyWith(
                                  color: MyColors.textColor1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'info@tgh.com',
                                style: MyText.body1(context)!.copyWith(
                                  color: MyColors.textColor1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ) : Center(child: Text(_isEnglish ? "Your appointment got problem. please try again" : "ቀጠሮ ማስያዝ አልተሳካም፡፡ እባክዎ እንደገና ይሞክሩ፡፡",
          style: MyText.body1(context)!.copyWith(
              color: MyColors.grey_3, fontSize: 16, fontWeight: FontWeight.w400),
        ),),
        bottomNavigationBar: const SubBottomNavBarContainer(),
      ),
    );
  }
}
