import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing1212/pages/ExpandableWidgetContainer.dart';
import 'package:testing1212/pages/BottomNavBar.dart';
import 'package:testing1212/pages/booking.dart';
import 'package:testing1212/pages/somethingWrong.dart';
import 'package:testing1212/service/services.dart';
import 'package:testing1212/service/user_service.dart';

import 'package:testing1212/widget/snackbar.dart';
import '../models/apiResponse.dart';
import '/data/img.dart';
import '/data/my_colors.dart';
import '/widget/my_text.dart';
import 'package:http/http.dart' as http;

import '404.dart';

class LoginCardOverlapRoute extends StatefulWidget {
  String? day;
  String? date;
  String? doctorId;
  String? schedule;
   LoginCardOverlapRoute({super.key,  this.day, this.date,  this.doctorId,this.schedule});

  @override
  LoginCardOverlapRouteState createState() => LoginCardOverlapRouteState();
}

class LoginCardOverlapRouteState extends State<LoginCardOverlapRoute> {
  @override
  void initState(){
    super.initState();
    _checkLanguageStatus();
  }
  bool _isEnglish =false;
  bool _loginStarted = false;
  void _checkLanguageStatus() async{
    final prefs = await SharedPreferences.getInstance();
    final isEnglish = prefs.getBool('isEnglish') ?? false;
    setState(() {
      _isEnglish = isEnglish;
    });
  }
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();

  Future Login(BuildContext cont) async {
    if (_emailcontroller.text == "" || _passwordcontroller.text == "") {
      snackBar.show(
          context, _isEnglish ? "username and password must be filled" : "የተጠቃሚው ስም እና የይለፍ ቃል መሞላት አለበት", Colors.red);
    } else {
      setState(() {
        _loginStarted = true;
      });
      ApiResponse loginResponse = await login(_emailcontroller.text, _passwordcontroller.text);
      if(loginResponse.error == null){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', _emailcontroller.text);
        await prefs.setString('password', _passwordcontroller.text);
        List<dynamic> loginData = loginResponse.data as List<dynamic>;
        setState(() {
          _loginStarted = false;
        });
        await prefs.setBool('isLoggedIn', true);
        String? email = loginData[0]['email'];
        Navigator.of(cont).pushReplacement(MaterialPageRoute(builder: (_) => BookingPage(email: email)));
        snackBar.show(
            context, _isEnglish ? "${loginResponse.success}" : "ወደ አካውንትዎ መግባት ችለዋል！", Colors.green);
      }else if(loginResponse.error == '404'){
        setState(() {
          _loginStarted = false;
        });
        snackBar.show(
            context, _isEnglish ? "Page not found. please try again" : "ገጹ አልተገኘም። እባክዎ እንደገና ይሞክሩ：：", Colors.red);
      }else{
        setState(() {
          _loginStarted =false;
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
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Container(color: MyColors.primary)),
        floatingActionButton: const CustomFloatingActionButton(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Container(color: MyColors.navBarColor, height: 220),
                Column(
                  children: <Widget>[
                    Container(height: 40),
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.asset(
                        Img.get('logo_small_circle.png'),
                      ),
                    ),
                    Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        margin: const EdgeInsets.all(25),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(height: 25),
                              Text(_isEnglish ? "SIGN IN" : "ግባ",
                                  style: MyText.title(context)!.copyWith(
                                      color: Colors.green[500],
                                      fontWeight: FontWeight.bold)),
                              TextField(
                                controller: _emailcontroller,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  labelText: _isEnglish ? "Email" : "ኢሜይል",
                                  labelStyle: TextStyle(color: Colors.blueGrey[400]),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueGrey[400]!, width: 1),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueGrey[400]!, width: 2),
                                  ),
                                ),
                              ),
                              Container(height: 25),
                              TextField(
                                obscureText: true,
                                controller: _passwordcontroller,
                                keyboardType: TextInputType.visiblePassword,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  labelText: _isEnglish ? "Password" : "የይለፍ ቃል",
                                  labelStyle: TextStyle(color: Colors.blueGrey[400]),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueGrey[400]!, width: 1),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueGrey[400]!, width: 2),
                                  ),
                                ),
                              ),
                              Container(height: 15),
                              Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: 47,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: MyColors.navBarColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20)),
                                      ),
                                      child:  Text(_isEnglish ?
                                        "SUBMIT" : "ላክ",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        FocusScopeNode currentFocus =
                                        FocusScope.of(context);

                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                        Login(context);
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  if(_loginStarted)
                                    Container(
                                      height: 40,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                ],
                              ),
                              Container(
                                width: double.infinity,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.transparent),
                                  child:  Text(_isEnglish ?
                                    "New user? Sign Up" : "አድስ ተጠቃሚ ነዎት？ ይመዝገቡ",
                                    style: TextStyle(color: MyColors.navBarColor),
                                  ),
                                  onPressed: () async {
                                    // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>RegisterPage(fromWhere: widget.fromWhere)));
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setBool('booking', true);
                                    Navigator.of(context).pushNamed('/register');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
          bottomNavigationBar: const SubBottomNavBarContainer(),
      ),
    );
  }
}
