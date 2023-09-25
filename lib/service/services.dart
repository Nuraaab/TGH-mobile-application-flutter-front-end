
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../pages/department.dart';
import '../pages/doctors.dart';
import '../pages/home.dart';
import '../pages/share.dart';
import '../widget/my_text.dart';

class Services {

  static void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DoctorsPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DepartmentPage()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ContactPage()),
        );
        break;
    }
  }
 static Future<bool> onBackPressed(BuildContext context) async {
    bool exitApp = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Do you want to exit?',
          style: MyText.body1(context)!.copyWith(
              color: Colors.black,
              letterSpacing: 1,
              fontSize: 18,
              fontWeight: FontWeight.w400
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('No'
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Yes'
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    return exitApp ?? false;
  }
}
