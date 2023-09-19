import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/my_text.dart';
class snackBar {
  final String msg;
  final Color? clr;
  const snackBar({
    required this.msg,
    this.clr,
  });

  static show(BuildContext context, String msg, Color clr) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isEnglish =prefs.getBool('isEnglish');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0.0,
      backgroundColor: clr,
      behavior: SnackBarBehavior.fixed,
      content: Text(msg,
          style: MyText.subhead(context)!
              .copyWith(fontWeight: FontWeight.w400, color: Colors.white),
      ),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: "Ok",
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
        textColor: Colors.white,

      ),
    ));
  }
}
