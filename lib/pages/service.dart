import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:testing1212/models/apiResponse.dart';
import 'package:testing1212/models/service.dart';
import 'package:testing1212/pages/404.dart';
import 'package:testing1212/pages/ExpandableWidgetContainer.dart';
import 'package:testing1212/pages/ServiceDetails.dart';
import 'package:testing1212/pages/somethingWrong.dart';
import 'package:testing1212/service/services.dart';
import 'package:testing1212/service/user_service.dart';
import 'package:testing1212/widget/navigation_drawer.dart';

import '../data/my_colors.dart';
import '../widget/my_text.dart';
import 'BottomNavBar.dart';
import 'home.dart';
class SupportiveServices extends StatefulWidget {
  SupportiveServices({super.key});

  @override
  State<SupportiveServices> createState() => _SupportiveServicesState();
}

class _SupportiveServicesState extends State<SupportiveServices> {
  List<dynamic> _serviceList = [];
  bool _isLodding = true;
  bool _isEnglish = false;
  @override
  void initState(){
    super.initState();
    _checkLanguageStatus();
    _getService();
  }

  void _checkLanguageStatus() async{
    final prefs = await SharedPreferences.getInstance();
    final isEnglish = prefs.getBool('isEnglish') ?? false;
    setState(() {
      _isEnglish = isEnglish;
    });
  }
  Future<void> _getService() async{
    ApiResponse serviceResponse =  await getService();
    if(serviceResponse.error == null){
      List<dynamic> serviceList = serviceResponse.data as List<dynamic>;
      setState(() {
        _serviceList = serviceList.cast<Service>();
        _isLodding =false;
      });
    }else if(serviceResponse.error == '404'){
      setState(() {
        _isLodding =false;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Error404(routeWidget: SupportiveServices(),)));
    }else{
      setState(() {
        _isLodding = false;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SomethingWrong(routeWidget: SupportiveServices(),)));
    }
  }
  @override
  Widget build(BuildContext context) => _isLodding ?WillPopScope(onWillPop: () => Services.onBackPressed(context),
  child: (Scaffold(body: Center(child: Lottie.asset('assets/images/animation_lkghd69s.json')),))) :
  (_serviceList.isEmpty ?
  WillPopScope(
    onWillPop: () => Services.onBackPressed(context),
    child: Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_isEnglish ? 'Sorry, there are no Service available for now. Please try again later.' : 'ይቅርታ！ ለአሁን ምንም አይነት አገልግሎት የለም:: እባክዎ ቆይተው ይሞክሩ', textAlign: TextAlign.center, style: MyText.subhead(context)!.copyWith(
                color: MyColors.grey_100_,  fontWeight: FontWeight.w400),),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomePage()));
              },
              child: Container(
                width: 250,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: MyColors.navBarColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back,color: MyColors.grey_3, size: 25,),
                    SizedBox(width: 10,),
                    Text('Back', style: MyText.subhead(context)!.copyWith(
                        color: MyColors.grey_3, fontSize: 18, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ],
        ),),
    ),
  ) : 
  WillPopScope(
    onWillPop: () => Services.onBackPressed(context),
    child: Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title:  Text(_isEnglish ? 'Services' : 'አገልግሎቶች',
            style: MyText.subhead(context)!.copyWith(
                color: MyColors.grey_3, fontSize: 20, fontWeight: FontWeight.w500)
        ),
        centerTitle: true,
        backgroundColor: MyColors.navBarColor,
        foregroundColor: MyColors.grey_3,
      ),
      floatingActionButton: CustomFloatingActionButton(),
      body: ListView.builder(
        itemCount: _serviceList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              SizedBox(height: 10,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      color: Colors.white,
                      elevation:3,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(bottom: 15, left: 5,right: 7,top: 15),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 8.0,
                              color: MyColors.navBarColor,
                            ),
                          ),
                          color: MyColors.grey_3,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                            Row(
                              children: [
                                RotatedBox(quarterTurns: 45,
                                    child: Icon( Icons.pan_tool_alt, color: MyColors.navBarColor,)),
                                SizedBox(width: 30,),
                                Text(_isEnglish ? _serviceList[index].titleEn.toString() : _serviceList[index].titleAm.toString(),
                                    style: MyText.subhead(context)!
                                        .copyWith(color: MyColors.navBarColor, fontSize: 20,)
                                ),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Text(_isEnglish ? '${_serviceList[index].subTitleEn.toString()}...' :'${_serviceList[index].subTitleAm.toString()}...',
                                textAlign: TextAlign.start,
                                style: MyText.subhead(context)!
                                    .copyWith(color: Color.fromRGBO(119, 119, 119, 1))
                            ),
                            SizedBox(height: 20,),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => ServiceDetails(list: _serviceList, index: index, isEnglish: _isEnglish,)));
                                    },
                                    child: Container(
                                      width: 90,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(_isEnglish ? 'More' : 'ተጨማሪ',
                                              style: MyText.subhead(context)!
                                                  .copyWith(color: MyColors.secondary)
                                          ),
                                          SizedBox(width: 5,),
                                          Icon(Icons.arrow_forward_outlined, color: MyColors.secondary, size: 22,),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
            ],
          );
        },
      ),
      bottomNavigationBar: SubBottomNavBarContainer(),
    ),
  ));
}
