import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:testing1212/data/img.dart';
import 'package:testing1212/pages/home.dart';
import 'package:testing1212/service/services.dart';

import '../widget/my_text.dart';

    class Error404 extends StatelessWidget {
  Widget? routeWidget;
  Error404({super.key, this.routeWidget}) ;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=> Services.onBackPressed(context),
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
                  Lottie.asset(Img.get('404.json')),
                  SizedBox(height: 10,),
                  Text('Please check your connection and try again.',
                    style: MyText.body1(context)!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(onPressed: (){Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => routeWidget!),
                        );}, child: Row(children: [Icon(Icons.refresh , size: 18,), SizedBox(width: 5,), Text('Reload...')],)),
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
