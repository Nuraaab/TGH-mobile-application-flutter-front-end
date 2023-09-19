import 'package:flutter/material.dart';
import 'package:testing1212/pages/Payment.dart';
import 'package:testing1212/pages/Register.dart';
import 'package:testing1212/pages/about.dart';
import 'package:testing1212/pages/booking.dart';
import 'package:testing1212/pages/department.dart';
import 'package:testing1212/pages/doctors.dart';
import 'package:testing1212/pages/events.dart';
import 'package:testing1212/pages/home.dart';
import 'package:testing1212/pages/login_card_overlap.dart';

import 'package:testing1212/pages/share.dart';
import 'package:testing1212/pages/timetable.dart';
import 'data/img.dart';
import 'data/my_colors.dart';
import 'main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());

      case '/about':
        return MaterialPageRoute(builder: (_) =>  AboutCompanyImageRoute());

      case '/appointment':
        return MaterialPageRoute(builder: (_) => LoginCardOverlapRoute());
      case '/booking':
        if (args is String) {
          return MaterialPageRoute(
              builder: (_) => BookingPage( email: args,));
        } else {
          return _errorRoute();
        }

      case '/department':
        return MaterialPageRoute(builder: (_) => DepartmentPage());

      case '/doctors':
        return MaterialPageRoute(builder: (_) => DoctorsPage());

      case '/events':
        return MaterialPageRoute(builder: (_) => EventssPage());

      case '/timetable':
        return MaterialPageRoute(builder: (_) =>  TimeTablePage());
      case '/share':
        return MaterialPageRoute(builder: (_) => ContactPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterPage());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(100.0),
                child: Image.asset(
                  Img.get('error.png'),
                ),
              ),
              const Text(
                'something went wrong while routing',
                style: TextStyle(color: MyColors.primaryLight),
              ),
            ],
          ),
        ),
      );
    });
  }
}
