//import packages
import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing1212/models/apiResponse.dart';
import 'package:testing1212/pages/404.dart';
import 'package:testing1212/pages/BottomNavBar.dart';
import 'package:testing1212/pages/somethingWrong.dart';
import 'package:testing1212/pages/webViewWidget.dart';
import 'package:testing1212/service/services.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import '../data/img.dart';
import '../data/my_colors.dart';
import '../models/about.dart';
import '../service/user_service.dart';
import '../widget/my_text.dart';
import '../widget/navigation_drawer.dart';
import 'package:http/http.dart' as http;
import 'ExpandableWidgetContainer.dart';
class AboutCompanyImageRoute extends StatefulWidget {
 AboutCompanyImageRoute({super.key});
  @override
  AboutCompanyImageRouteState createState() => AboutCompanyImageRouteState();
}

class AboutCompanyImageRouteState extends State<AboutCompanyImageRoute> {
  WebViewPlusController? _controller;
  @override
  void initState(){
    super.initState();
    getAboutData();
    _checkLanguageStatus();
  }

  void _checkLanguageStatus() async{
    final prefs = await SharedPreferences.getInstance();
    final isEnglish = prefs.getBool('isEnglish') ?? false;
    setState(() {
      _isEnglish = isEnglish;
    });
  }
  bool _isEnglish =false;
  double _height = 1;
  late int currentYear = DateTime.now().year;
  late int intialYear = 2000;
  late int yearDifference = (currentYear - intialYear).toInt();
  List<dynamic> _about = [];
  Future<void> getAboutData() async {
    ApiResponse aboutResponse = await fetchAboutData();
    if(aboutResponse.error == null){
      List<dynamic> about = aboutResponse.data as List<dynamic>;
      print('about:${about}');
      setState(() {
        _about = about ?? [];
      });
    }else if(aboutResponse.error == '404'){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Error404(routeWidget: AboutCompanyImageRoute(),)));
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>SomethingWrong(routeWidget: AboutCompanyImageRoute(),)));
    }
  }
  late List<dynamic> dynamicList = _about as List<dynamic>;
  late List<About> aboutList = dynamicList.map((item) => item as About).toList();
  late String? description = aboutList[0].descriptionEn;
  late String encodedDescription = jsonEncode(description);
  late String noQuotesDescription = encodedDescription.replaceAll('"', '');
  late String breakReplaced = noQuotesDescription.replaceAll(RegExp(r'<br>|<\/br>'), '');
  late String? descriptionAm = aboutList[0].descriptionAm;
  late String encodedText = descriptionAm!.codeUnits.map((unit) => '\\u${unit.toRadixString(16).padLeft(4, '0')}').join('');
  @override
  Widget build(BuildContext context) => _about.isEmpty ? WillPopScope(onWillPop: () => Services.onBackPressed(context),
  child: Scaffold(body: Center(child: Lottie.asset('assets/images/animation_lkghd69s.json')))):
  WillPopScope(
    onWillPop: ()=> Services.onBackPressed(context),
    child: Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title:  Text(_isEnglish ? 'About' : 'ስለ ተክለሀይማኖት ሆስፒታል',
            style: MyText.subhead(context)!.copyWith(
                color: MyColors.grey_3, fontSize: 20, fontWeight: FontWeight.w500)
        ),
        centerTitle: true,
        backgroundColor: MyColors.navBarColor,
        foregroundColor: MyColors.grey_3,
      ),
      floatingActionButton: const CustomFloatingActionButton(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 250,
              child: Stack(
                children: <Widget>[
                  Image.asset(Img.get('tk_home.jpg'),
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover),
                  Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.5)),
                  Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ElevatedButton(

                            style: ElevatedButton.styleFrom(
                                backgroundColor: MyColors.navBarColor,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 20),
                                elevation: 0),
                            child:  Text(_isEnglish?
                            "CONTACT US" : "ከእኛ ጋር ይገናኙ",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed('/share');
                            },
                          ),
                          Container(
                            width: 220,
                            child: Text(_isEnglish ? "${yearDifference} Years in Service" : "${yearDifference} አመታትን በአገልግሎት ላይ",
                                textAlign: TextAlign.center,
                                style: MyText.title(context)!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500)),
                          )
                        ],
                      )),
                ],
              ),
            ),
            Container(height: 25),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text(_isEnglish ? 'Teklehaimanot General Hospital':'ተክለሀይማኖት አጠቃላይ ሆስፒታል',
                  style: MyText.title(context)!.copyWith(
                      color: MyColors.secondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 30, letterSpacing: 1
                  )
              ),
            ),
            _isEnglish ? WebViewWidget(webViewContents: breakReplaced) : WebViewPlusAm(amharicContent: encodedText),
            Container(
              width: double.maxFinite,
              height:200,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child:  CachedNetworkImage(
                key: UniqueKey(),
                imageUrl:
                'http://www.teklehaimanothospital.com/admin/${aboutList[0].logo}',
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/place_holder.png',
                  height: 155,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const SubBottomNavBarContainer(),
    ),
  );
}
