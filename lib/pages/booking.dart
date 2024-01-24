import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing1212/models/apiResponse.dart';
import 'package:testing1212/pages/ExpandableWidgetContainer.dart';
import 'package:testing1212/pages/BottomNavBar.dart';
import 'package:testing1212/pages/department.dart';
import 'package:testing1212/pages/searchAppointment.dart';
import 'package:testing1212/pages/somethingWrong.dart';
import 'package:testing1212/service/services.dart';
import 'package:testing1212/service/user_service.dart';
import 'package:testing1212/widget/snackbar.dart';
import '../data/my_colors.dart';
import '../models/booking.dart';
import '../models/patient.dart';
import '../widget/my_text.dart';
import '../widget/navigation_drawer.dart';
import 'package:http/http.dart' as http;

import '404.dart';
class BookingPage extends StatefulWidget {
  String? email;
  BookingPage({super.key, this.email});
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List<dynamic> _bookings = [];
  bool _isLodding = true;
  @override
  void initState(){
    super.initState();
    _checkLanguageStatus();
    _getBookings();
  }
  bool _isEnglish =false;
  void _checkLanguageStatus() async{
    final prefs = await SharedPreferences.getInstance();
    final isEnglish = prefs.getBool('isEnglish') ?? true;
    setState(() {
      _isEnglish = isEnglish;
    });
  }

  void _navigateTodepartmentPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('status', true);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>  DepartmentPage()));
  }
  Future<void> _getBookings() async {
    ApiResponse patientResponse  = await getPatients(widget.email);
    if(patientResponse.error == null){
      List<dynamic> patient = patientResponse.data as List<dynamic>;
      print(widget.email);
      List<dynamic> patientData = patient.cast<Patient>();
      String? patient_id = patientData[0].id ?? '';
      ApiResponse bookingResponse = await getBooking(patient_id);
      if(bookingResponse.error == null){
        List<dynamic> bookings = bookingResponse.data as List<dynamic>;
        setState(() {
          _bookings = bookings.cast<Booking>();
          _isLodding = false;
        });
      }else if(bookingResponse.error == '404'){
        setState(() {
          _isLodding = false;
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>Error404(routeWidget: BookingPage(email: widget.email!,),)));
      }else{
        setState(() {
          _isLodding = false;
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>SomethingWrong(routeWidget: BookingPage(email: widget.email!,),)));
      }
    }else if(patientResponse.error == '404'){
      setState(() {
        _isLodding = false;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>Error404(routeWidget: BookingPage(email: widget.email!,),)));
    }else{
      setState(() {
        _isLodding = false;
      });
      print('hello wrongs');
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>SomethingWrong(routeWidget: BookingPage(email: widget.email!,),)));
    }
  }
  final _transaction_id = TextEditingController();

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
  @override
  Widget build(BuildContext context) => _isLodding ? WillPopScope(onWillPop: ()=> Services.onBackPressed(context),
  child: (Scaffold( body: Center(child: Lottie.asset('assets/images/animation_lkghd69s.json')),))) :
   WillPopScope(
     onWillPop: () => Services.onBackPressed(context),
     child: Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
          title: Text(_isEnglish ? 'Booking...' : 'የተያዙ ቀጠሮዎች',
              style: MyText.subhead(context)!.copyWith(
                  color: MyColors.grey_3, fontSize: 20, fontWeight: FontWeight.w500)),
          centerTitle: true,
          backgroundColor: MyColors.navBarColor,
          foregroundColor: MyColors.grey_3,
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.search_outlined, size: 35,),
                    onPressed: () {
                      showSearch(context: context, delegate: SearchAppointments(list: _bookings, isEnglish: _isEnglish));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, size: 40,),
                    onPressed: () {
                      _navigateTodepartmentPage(); // navigate to doctors page
                    },
                  ),
                ],
              ),
            ),
          ]),
      floatingActionButton: CustomFloatingActionButton(),
      body:_bookings.isEmpty ? Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_isEnglish ? 'Looks like you have not made any bookings yet. Add a new one by clicking here.' : 'እስካሁን ምንም ቀጠሮ ያስያዙ አይመስሉም። እዚህ ጠቅ በማድረግ አዲስ ያክሉ።', textAlign: TextAlign.center, style: MyText.subhead(context)!.copyWith(
                color: MyColors.grey_100_,  fontWeight: FontWeight.w400),),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                _navigateTodepartmentPage();
              },
              child: Container(
                width: 250,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: MyColors.navBarColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add,color: MyColors.grey_3, size: 25,),
                    SizedBox(width: 10,),
                    Text(_isEnglish ? 'Add New Booking' : 'አድስ ቀጠሮ ያክሉ', style: MyText.subhead(context)!.copyWith(
                        color: MyColors.grey_3, fontSize: 18, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ],
        ),) :
      Container(
        color: MyColors.grey_3,
        child: ListView.builder(

            itemCount: _bookings == null ? 0 : _bookings.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                child: Column(
                  children: [
                    Card(
                      color: MyColors.secondary,
                      child: ExpansionTile(
                        leading:  Icon(Icons.calendar_month, color: MyColors.grey_3,),
                        title:_isEnglish ? Text(_bookings[index].selectedDay.toString(),
                          style: const TextStyle(
                            color: MyColors.grey_3,
                          ),
                        ) : (() {
                          switch (_bookings[index].selectedDay) {
                            case 'Monday':
                              return const Text('ሰኞ',  style: TextStyle(
                                color: MyColors.grey_3,
                              ),);
                            case 'Tuesday':
                              return const Text('ማክሰኞ',  style: TextStyle(
                                color: MyColors.grey_3,
                              ),);
                            case 'Wednesday':
                              return const Text('ረቡዕ',  style: TextStyle(
                                color: MyColors.grey_3,
                              ),);
                            case 'Thursday':
                              return const Text('ሐሙስ',  style: TextStyle(
                                color: MyColors.grey_3,
                              ),);
                            case 'Friday':
                              return const Text('ዓርብ',  style: TextStyle(
                                color: MyColors.grey_3,
                              ),);
                            case 'Saturday':
                              return const Text('ቅዳሜ',  style: TextStyle(
                                color: MyColors.grey_3,
                              ),);
                            case 'Sunday':
                              return const Text('እሑድ',  style: TextStyle(
                                color: MyColors.grey_3,
                              ),);
                            default:
                              return const Text('...',  style: TextStyle(
                                color: MyColors.grey_3,
                              ),);
                          }
                        })(),
                        trailing:GestureDetector(
                          child: Icon( color: MyColors.grey_3, Icons.expand_more,),
                        ),

                        subtitle: Text(_isEnglish ? _bookings[index].nameEn.toString() : _bookings[index].nameAm.toString(),
                          style: const TextStyle(
                            color: MyColors.grey_3,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: ListTile(
                              leading: const Icon(Icons.lock_clock, color: MyColors.grey_3,),
                              title:  Text(_isEnglish ? 'Time' : 'የቀጠሮ ሰዓት',
                                style: const TextStyle(
                                  color: MyColors.grey_3,
                                ),
                              ),
                              trailing: Text(_bookings[index].selectedTime.toString(),
                                style: const TextStyle(
                                  color: MyColors.grey_3,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: ListTile(
                              leading: const Icon(Icons.person, color: MyColors.grey_3,),
                              title:  Text(_isEnglish ? 'Doctor' : 'የሀኪም ስም',
                                style: TextStyle(
                                  color: MyColors.grey_3,
                                ),
                              ),
                              trailing: Text(_isEnglish ? _bookings[index].nameEn.toString() : _bookings[index].nameAm.toString(),
                                style: const TextStyle(
                                  color: MyColors.grey_3,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: ListTile(
                              leading: const Icon(Icons.date_range, color: MyColors.grey_3,),
                              title:  Text(_isEnglish ? 'Date' : 'የቀጠሮ ቀን' ,
                                style: TextStyle(
                                  color: MyColors.grey_3,
                                ),
                              ),
                              trailing: Text(_bookings[index].selectedDate.toString(),
                                style: const TextStyle(
                                  color: MyColors.grey_3,
                                ),
                              ),
                            ),
                          ),
                          (_bookings[index].trsId == null || _bookings[index].trsId.isEmpty) ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.person, color: MyColors.grey_3,),
                                  title:  Text(_isEnglish ? 'Price' : 'ዋጋ',
                                    style: TextStyle(
                                      color: MyColors.grey_3,
                                    ),
                                  ),
                                  trailing: Text('${_bookings[index].amount.toString()}ETB',
                                    style: const TextStyle(
                                      color: MyColors.grey_3,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  height: 57,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MyColors.accent,
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      _isEnglish ? "Pay" : "ይክፈሉ",
                                      style: MyText.subhead(context)!
                                          .copyWith(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      (_bookings[index].amount == '0' || _bookings[index].amount == '' || _bookings[index].amount == null) ? snackBar.show(
                                          context,_isEnglish ?
                                      "The price for ${_bookings[index].nameEn} is not specified" : "የ ${_bookings[index].nameAm} ዋጋ አልተገለጸም። እባክዎ ቆይተው ይሞክሩ፡፡",
                                          Colors.red) :
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            child: Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 5),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20.0),

                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Align(
                                                    alignment: Alignment.topRight,
                                                    child: IconButton(
                                                      icon: Icon(Icons.close),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
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
                                                            style: MyText.body1(context)!.copyWith(
                                                              color: MyColors.textColor1,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                            maxLines: 2,
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
                                            Text(
                                              'ውድ ደንበኛችን: ከላይ በተቀመጠው የቴሌ ብር አካውንታችን ${_bookings[index].amount.toString()} ብር  ከከፈሉ በኋላ የከፈሉበትን ደረሰኝ  (transaction id) ከታች ባለው ፎርም ላይ አስገብተው ይላኩልን፡፡',
                                              style: MyText.body1(context)!.copyWith(
                                                color: MyColors.textColor1,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),

                                            Container(height: 35),

                                                  ],
                                          ),
                                          ),
                                                  Padding(
                                                    padding: EdgeInsets.only(bottom: 10.0),
                                                    child: TextField(
                                                      controller: _transaction_id,
                                                      obscureText: false,
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
                                                            _isEnglish ? "Pay" : "ይክፈሉ",
                                                            style: MyText.subhead(context)!
                                                                .copyWith(color: Colors.white),
                                                          ),
                                                          onPressed: () {
                                                         Payment(context, _bookings[index].amount.toString(), _bookings[index].nameEn.toString(), _bookings[index].nameAm.toString(), _bookings[index].id.toString());
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),

                                                    ],
                                                  ),
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
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ) : Text(''),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
      bottomNavigationBar: SubBottomNavBarContainer(),
      // display floating action button at the bottom of the page
  ),
   );

}


