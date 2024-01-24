import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:testing1212/models/apiResponse.dart';
import 'package:testing1212/models/healthTip.dart';
import 'package:testing1212/pages/404.dart';
import 'package:testing1212/pages/BottomNavBar.dart';
import 'package:testing1212/pages/ExpandableWidgetContainer.dart';
import 'package:testing1212/pages/TipsDetail.dart';
import 'package:testing1212/pages/somethingWrong.dart';
import 'package:testing1212/service/services.dart';
import 'package:testing1212/service/user_service.dart';
import '../data/my_colors.dart';
import '../widget/my_text.dart';
import '../widget/navigation_drawer.dart';
import 'home.dart';
class HealthTips extends StatefulWidget {
  HealthTips({super.key});

  @override
  State<HealthTips> createState() => _HealthTipsState();
}

class _HealthTipsState extends State<HealthTips> {
  List<dynamic> _tipList = [];
  bool _isLodding = true;
  bool _isEnglish =false;
  @override
  void initState(){
    super.initState();
    _checkLanguageStatus();
    _getTips();
  }
  void _checkLanguageStatus() async{
    final prefs = await SharedPreferences.getInstance();
    final isEnglish = prefs.getBool('isEnglish') ?? true;
    setState(() {
      _isEnglish = isEnglish;
    });
  }
  Future<void> _getTips() async {
    ApiResponse tipResponse = await getTips();
    if(tipResponse.error == null){
      List<dynamic> tipList = tipResponse.data as List<dynamic>;
      setState(() {
        _tipList = tipList.cast<HealthTip>();
        _isLodding = false;
      });
    }else if(tipResponse.error == '404'){
      setState(() {
        _isLodding = false;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Error404(routeWidget: HealthTips(),)));
    }else{
      _isLodding = false;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SomethingWrong(routeWidget: HealthTips(),)));
    }
  }
  @override
  Widget build(BuildContext context) => _isLodding ? WillPopScope(onWillPop: () => Services.onBackPressed(context),
  child: (Scaffold(body: Center(child: Lottie.asset('assets/images/animation_lkghd69s.json')),))) :
  (_tipList.isEmpty ?
  WillPopScope(
    onWillPop: () => Services.onBackPressed(context),
    child: Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_isEnglish ? 'Sorry, there are no Health Tips available for now. Please try again later.' : 'ይቅርታ！ ለአሁን ምንም አይነት የጤና ምክር የለም:: እባክዎ ቆይተው ይሞክሩ', textAlign: TextAlign.center, style: MyText.subhead(context)!.copyWith(
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
        title:  Text(_isEnglish ? 'Health Tips' : 'የጤና ምክሮች',
            style: MyText.subhead(context)!.copyWith(
                color: MyColors.grey_3, fontSize: 20, fontWeight: FontWeight.w500)
        ),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: MyColors.navBarColor,
        foregroundColor: MyColors.grey_3,
      ),
      floatingActionButton: CustomFloatingActionButton(),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: _tipList == null ? 0 : _tipList.length,
          itemBuilder: (context, i) {
            return Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(height: 15),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        color: Colors.white,
                        elevation: 3,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Container(
                          color: MyColors.grey_3,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                constraints: const BoxConstraints(
                                    minHeight: 300, minWidth: double.infinity),
                                child: CachedNetworkImage(
                                  key: UniqueKey(),
                                  imageUrl:
                                  'http://www.teklehaimanothospital.com/admin/${_tipList[i].image}',
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => Image.asset(
                                    'assets/images/place_holder.png',
                                    height: 155,
                                    width: 200,
                                    fit: BoxFit.cover,
                                  ),
                                  fit: BoxFit.cover,
                                  width: 200,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_isEnglish ? _tipList[i].titleEn.toString() : _tipList[i].titleAm.toString(),
                                        style: MyText.medium(context)
                                            .copyWith(color: Colors.grey[800])),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>
                                          TipsDetails(list: _tipList, index: i, isEnglish: _isEnglish,),
                                      ));
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
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: SubBottomNavBarContainer(),
    ),
  ));
}
