import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:testing1212/pages/home.dart';
import 'package:testing1212/service/services.dart';

import '../data/img.dart';
class SomethingWrong extends StatelessWidget {
  Widget? routeWidget;
   SomethingWrong({super.key , this.routeWidget});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () =>Services.onBackPressed(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(Img.get('something.json')),
                SizedBox(height: 10,),
                Container(
                  width: MediaQuery.of(context).size.width/2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
                      }, child: Row(children: [Icon(Icons.arrow_back, ), Text('back')],)),
                      TextButton(onPressed: (){Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => routeWidget!),
                      );}, child: Row(children: [Icon(Icons.refresh), Text('Try Again')],)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
