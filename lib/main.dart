import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testing1212/pages/AnimatedSplash.dart';
import 'package:testing1212/pages/home.dart';
import 'package:testing1212/route_generator.dart';
import 'data/my_colors.dart';
import 'widget/my_text.dart';
import 'widget/navigation_drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: MyColors.navBarColor, // set status bar color here
      statusBarBrightness: Brightness.light
    ));

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      home: const AnimatedSpalshScreen(),
    );
  }
}

