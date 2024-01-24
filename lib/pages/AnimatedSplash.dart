import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing1212/data/my_colors.dart';
import 'package:testing1212/pages/home.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lottie/lottie.dart';
class AnimatedSpalshScreen extends StatefulWidget {
  const AnimatedSpalshScreen({Key? key}) : super(key: key);
  @override
  State<AnimatedSpalshScreen> createState() => _AnimatedSpalshScreenState();
}
class _AnimatedSpalshScreenState extends State<AnimatedSpalshScreen> {
  @override
  void initState() {
    super.initState();
    _setLanguage();
  }
  void _setLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isEnglish', true);
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
                  Image.asset('assets/images/logo-medical.png', fit: BoxFit.cover,),
              // Lottie.asset('assets/images/p0PBdweFon.json'),
               Lottie.asset('assets/images/animation_lkgvclh7.json', fit: BoxFit.cover),
              Container(
                width: double.maxFinite,
                height: 55,
                margin: EdgeInsets.only(left: 5, right: 5),
                  child: Image.asset('assets/images/splashLogo.png',fit: BoxFit.cover, )),
            ],
          ),
        ),
        splashIconSize: 530,
        backgroundColor: Colors.white,
        duration: 2500,
        pageTransitionType: PageTransitionType.topToBottom,
        animationDuration: Duration(seconds: 0),
        nextScreen: HomePage());
  }
}
