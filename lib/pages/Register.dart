import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing1212/constatnts/constant.dart';
import 'package:testing1212/pages/404.dart';
import 'package:testing1212/pages/ExpandableWidgetContainer.dart';
import 'package:testing1212/pages/BottomNavBar.dart';
import 'package:testing1212/pages/somethingWrong.dart';
import 'package:testing1212/service/services.dart';
import 'package:testing1212/service/user_service.dart';
import '../models/apiResponse.dart';
import '../widget/navigation_drawer.dart';
import '/data/my_colors.dart';
import '/widget/my_text.dart';
import 'package:http/http.dart' as http;
import 'package:testing1212/widget/snackbar.dart';
import 'dart:convert';
import 'booking.dart';
import 'home.dart';

class RegisterPage extends StatefulWidget {
 RegisterPage({super.key,});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  late int currentYear = DateTime.now().year;
  late int birthYear = forintializaton!.year;
  late int age = (currentYear - birthYear).toInt();
  @override
  void initState(){
    super.initState();
    _checkLanguageStatus();
    _checkLoginStatus();
  }
  bool _isEnglish =false;
  void _checkLanguageStatus() async{
    final prefs = await SharedPreferences.getInstance();
    final isEnglish = prefs.getBool('isEnglish') ?? false;
    setState(() {
      _isEnglish = isEnglish;
    });
  }
  String? _sexcontroller;
  final _fnamecontroller = TextEditingController();
  final _lnamecontroller = TextEditingController();
  final _midlenamecontroller = TextEditingController();
  final _motheernamecontroller = TextEditingController();
  final _nationalIdcontroller = TextEditingController();
  final _agecontroller = TextEditingController();
  DateTime? forintializaton;

  final _mobilecontroller = TextEditingController();
  final _altmobilecontroller = TextEditingController();
  final _regioncontroller = TextEditingController();
  final _citycontroller = TextEditingController();
  final _subcitycontroller = TextEditingController();
  final _woredacontroller = TextEditingController();
  final _housenumcontroller = TextEditingController();
  final _officetelcontroller = TextEditingController();
  final _organzationcontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _repasswordcontroller = TextEditingController();
  bool _isBooking=false;
  bool _isRegisterStarted = false;
  void _checkLoginStatus() async{
    final prefs = await SharedPreferences.getInstance();
    final isBooking = prefs.getBool('booking') ?? false;
    setState(() {
      _isBooking = isBooking;
    });
  }

  bool isEmailValid(String email) {
    final pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email.trim());
  }
  Future Register(BuildContext context) async {
    if(_fnamecontroller.text == "" || _lnamecontroller.text == "" || _midlenamecontroller.text == ""){
    snackBar.show(
    context, _isEnglish ? "Full name  must be filled" : "ሙሉ ስም መሞላት አለበት።", Colors.red);
    }else if(_regioncontroller.text == "" || _citycontroller.text == "" || _subcitycontroller.text == "" || _woredacontroller.text == ""){
    snackBar.show(
    context,_isEnglish ? "Address  must be filled" : "አድራሻ መሞላት አለበት", Colors.red);
    } else if (_emailcontroller.text == "" || _passwordcontroller.text == "") {
        snackBar.show(
            context, _isEnglish ? "Email and password must be filled" : "ኢሜል እና የይለፍ ቃል መሞላት አለባቸው", Colors.red);
      }else if(!isEmailValid(_emailcontroller.text)) {
      snackBar.show(
          context, _isEnglish ? "The email address you entered is invalid" : "ያስገቡት የኢሜይል አድራሻ ልክ ያልሆነ ነው።", Colors.red);
        }else {
      if (_passwordcontroller.text == _repasswordcontroller.text) {
        setState(() {
          _isRegisterStarted = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', _emailcontroller.text);
        await prefs.setString('password', _passwordcontroller.text);
        var body = {
          "email": _emailcontroller.text,
          "password": _passwordcontroller.text,
          "fname": _fnamecontroller.text,
          "lname": _lnamecontroller.text,
          "mname": _midlenamecontroller.text,
          "mother_name": _motheernamecontroller.text,
          "mobile": _mobilecontroller.text,
          "current": currentYear.toString(),
          "birth_year": forintializaton?.year.toString(),
          "national_id": _nationalIdcontroller.text,
          "sex": _sexcontroller,
          "birth_day": forintializaton.toString(),
          "alt_mobile": _altmobilecontroller.text,
          "rigion": _regioncontroller.text,
          "sub_city": _subcitycontroller.text,
          "house_no": _housenumcontroller.text,
          "office_tel": _officetelcontroller.text,
          "organization": _organzationcontroller.text,
          "city": _citycontroller.text,
          "woreda": _woredacontroller.text,
        };
        ApiResponse registerResponse = await registerPatient(body);
        if (registerResponse.error == null) {
          setState(() {
            _isRegisterStarted = false;
          });
          await prefs.setBool('isLoggedIn', true);
          if (_isBooking == false) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => HomePage()));
            snackBar.show(
                context, _isEnglish ?
            "${registerResponse.success}" : "ታላቅ ዜና! በተሳካ ሁኔታ ተመዝግበዋል",
                Colors.green);
          } else {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (_) => BookingPage(email: _emailcontroller.text)));
            snackBar.show(
                context, _isEnglish ?
            "${registerResponse.success}" : "ታላቅ ዜና! በተሳካ ሁኔታ ተመዝግበዋል።",
                Colors.green);
          }
        }else if(registerResponse.error == something) {
          setState(() {
            _isRegisterStarted = false;
          });
          snackBar.show(
              context, _isEnglish ? "Something went wrong. please try again" : "ስህተት ተገኝቷል። እባክዎ እንደገና ይሞክሩ：：", Colors.red);
        }else {
          setState(() {
            _isRegisterStarted = false;
          });
          snackBar.show(
              context, _isEnglish
              ? "${registerResponse.error}"
              : "ያስገቡት ስልክ ቁጥር ወይም ኢሜይል አድራሻ አስቀድሞ አለ።", Colors.red);
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Services.onBackPressed(context),
      child: Scaffold(
        drawer: NavigationDrawerWidget(),
        backgroundColor: MyColors.grey_5,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          foregroundColor: MyColors.grey_3,
          backgroundColor: MyColors.navBarColor,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
          title: Text(_isEnglish ? "Register" : "ይመዝገቡ",
              style: MyText.subhead(context)!.copyWith(
                  color: MyColors.grey_3, fontSize: 20, fontWeight: FontWeight.w500)
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
                  Container(height: 5),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 43,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4))),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextField(
                            maxLines: 1,
                            controller: _fnamecontroller,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(-12),
                                border: InputBorder.none,
                                hintText: _isEnglish ? "First Name" :"ስም",
                                hintStyle: MyText.body1(context)!
                                    .copyWith(color: MyColors.grey_40)),
                          ),
                        ),
                      ),
                      Container(width: 10),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 43,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4))),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextField(
                            maxLines: 1,
                            controller: _midlenamecontroller,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(-12),
                                border: InputBorder.none,
                                hintText: _isEnglish ? "Middle Name" : "የአባት ስም",
                                hintStyle: MyText.body1(context)!
                                    .copyWith(color: MyColors.grey_40)),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(height: 15),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 43,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4))),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextField(
                            maxLines: 1,
                            controller: _lnamecontroller,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(-12),
                                border: InputBorder.none,
                                hintText:_isEnglish ? "Last Name" : "የአያት ስም",
                                hintStyle: MyText.body1(context)!
                                    .copyWith(color: MyColors.grey_40)),
                          ),
                        ),
                      ),
                      Container(width: 15),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 43,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4))),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextField(
                            maxLines: 1,
                            controller: _nationalIdcontroller,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(-12),
                                border: InputBorder.none,
                                hintText: _isEnglish ? "National ID" : "ብሔራዊ መታወቂያ",
                                hintStyle: MyText.body1(context)!
                                    .copyWith(color: MyColors.grey_40)),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(height: 15),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 43,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4))),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextField(
                            maxLines: 1,
                            controller: _motheernamecontroller,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(-12),
                                border: InputBorder.none,
                                hintText: _isEnglish ? "Mother Name" : "የእናት ስም" ,
                                hintStyle: MyText.body1(context)!
                                    .copyWith(color: MyColors.grey_40)),
                          ),
                        ),
                      ),
                      Container(width: 15),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 43,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4))),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              items:  [
                                DropdownMenuItem(
                                    child: Text(_isEnglish ?'male' : "ወንድ"), value: 'male'),
                                DropdownMenuItem(
                                    child: Text(_isEnglish ? 'female' : 'ሴት'), value: 'female')
                              ],
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                              hint:  Text(_isEnglish ? "Sex" : "ፆታ"),
                              isExpanded: true,
                              value: _sexcontroller,
                              onChanged: (_sexcontroller) {
                                setState(() {
                                  this._sexcontroller = _sexcontroller;
                                });
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: 15,
                  ),
                  Container(
                    height: 43,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextField(
                      maxLines: 1,
                      controller: TextEditingController(),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(-12),
                          border: InputBorder.none,
                          hintText:_isEnglish ?
                          "Birthday ${forintializaton.toString()}" : "የልደት ቀን (${forintializaton.toString()})",
                          hintStyle: MyText.body1(context)!
                              .copyWith(color: MyColors.grey_40)),
                      onTap: () async {
                        DateTime? newdate = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2022),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));

                        if (newdate == null) return;
                        setState(() {
                          forintializaton = newdate;
                          print('birth year = ${forintializaton!.year}');
                        });
                      },
                    ),
                  ),

                  Container(height: 15),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 43,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4))),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextField(
                            maxLines: 1,
                            controller: _mobilecontroller,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(-12),
                                border: InputBorder.none,
                                hintText: _isEnglish ? "Mobile Number" : "ስልክ ቁጥር",
                                hintStyle: MyText.body1(context)!
                                    .copyWith(color: MyColors.grey_40)),
                          ),
                        ),
                      ),
                      Container(width: 15),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 43,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4))),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextField(
                            maxLines: 1,
                            controller: _altmobilecontroller,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(-12),
                                border: InputBorder.none,
                                hintText: _isEnglish ? "Alternative Mobile" : "ተለዋጭ ስልክ ቁጥር ",
                                hintStyle: MyText.body1(context)!
                                    .copyWith(color: MyColors.grey_40)),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(height: 15),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 43,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4))),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextField(
                            maxLines: 1,
                            controller: _regioncontroller,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(-12),
                                border: InputBorder.none,
                                hintText: _isEnglish ? "Region" : "ክልል",
                                hintStyle: MyText.body1(context)!
                                    .copyWith(color: MyColors.grey_40)),
                          ),
                        ),
                      ),
                      Container(width: 15),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 43,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4))),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextField(
                            maxLines: 1,
                            controller: _citycontroller,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(-12),
                                border: InputBorder.none,
                                hintText: _isEnglish ? "City" : "ከተማ",
                                hintStyle: MyText.body1(context)!
                                    .copyWith(color: MyColors.grey_40)),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(height: 15),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 43,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4))),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextField(
                            maxLines: 1,
                            controller: _subcitycontroller,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(-12),
                                border: InputBorder.none,
                                hintText: _isEnglish ? "Sub-City" : "ክፍለ ከተማ",
                                hintStyle: MyText.body1(context)!
                                    .copyWith(color: MyColors.grey_40)),
                          ),
                        ),
                      ),
                      Container(width: 15),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 43,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4))),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextField(
                            maxLines: 1,
                            controller: _woredacontroller,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(-12),
                                border: InputBorder.none,
                                hintText: _isEnglish ? "Woreda" :"ወረዳ",
                                hintStyle: MyText.body1(context)!
                                    .copyWith(color: MyColors.grey_40)),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(height: 15),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 43,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4))),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextField(
                            maxLines: 1,
                            controller: _housenumcontroller,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(-12),
                                border: InputBorder.none,
                                hintText: _isEnglish ? "House Number" : "የቤት ቁጥር",
                                hintStyle: MyText.body1(context)!
                                    .copyWith(color: MyColors.grey_40)),
                          ),
                        ),
                      ),
                      Container(width: 15),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 43,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4))),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextField(
                            maxLines: 1,
                            controller: _officetelcontroller,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(-12),
                                border: InputBorder.none,
                                hintText: _isEnglish ? "Office Tel" :"የቢሮ ስልክ ቁጥር",
                                hintStyle: MyText.body1(context)!
                                    .copyWith(color: MyColors.grey_40)),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(height: 15),
                  Container(
                    height: 43,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextField(
                      maxLines: 1,
                      controller: _organzationcontroller,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(-12),
                          border: InputBorder.none,
                          hintText: _isEnglish ? "Organization(optional)" : "ድርጅት(አማራጭ)",
                          hintStyle: MyText.body1(context)!
                              .copyWith(color: MyColors.grey_40)),
                    ),
                  ),
                  Container(height: 15),
                  Container(
                    height: 43,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextField(
                      maxLines: 1,
                      controller: _emailcontroller,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(-12),
                          border: InputBorder.none,
                          hintText: _isEnglish ? "Email" : "ኢሜይል",
                          hintStyle: MyText.body1(context)!
                              .copyWith(color: MyColors.grey_40)),
                    ),
                  ),
                  Container(height: 15),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 43,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4))),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextField(
                            obscureText: true,
                            maxLines: 1,
                            controller: _passwordcontroller,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(-12),
                                border: InputBorder.none,
                                hintText:_isEnglish ? "Password" : "የይለፍ ቃል",
                                hintStyle: MyText.body1(context)!
                                    .copyWith(color: MyColors.grey_40)),
                          ),
                        ),
                      ),
                      Container(width: 15),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 43,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4))),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextField(
                            obscureText: true,
                            maxLines: 1,
                            controller: _repasswordcontroller,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(-12),
                                border: InputBorder.none,
                                hintText: _isEnglish ? "Confirm password " :"የይለፍ ቃል አረጋግጥ",
                                hintStyle: MyText.body1(context)!
                                    .copyWith(color: MyColors.grey_40)),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(height: 15),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 47,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: MyColors.navBarColor, elevation: 0),
                          child: Text(_isEnglish ? "SUBMIT" :"አስገባ",
                              style: MyText.subhead(context)!
                                  .copyWith(color: Colors.white)),
                          onPressed: () {
                            Register(context);
                          },
                        ),
                      ),
                      const SizedBox(height: 10,),
                      if(_isRegisterStarted)
                        Container(
                          height: 40,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
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
