import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:testing1212/data/my_colors.dart';
import 'package:testing1212/pages/somethingWrong.dart';
import 'package:testing1212/service/services.dart';
import 'package:testing1212/pages/ExpandableWidgetContainer.dart';
import 'package:testing1212/pages/BottomNavBar.dart';
import 'package:testing1212/pages/department.dart';
import 'package:testing1212/pages/home.dart';
import 'package:testing1212/pages/searchDoctors.dart';
import 'package:testing1212/service/user_service.dart';
import '../models/apiResponse.dart';
import '../models/doctor.dart';
import '../widget/my_text.dart';
import '../widget/navigation_drawer.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '404.dart';
import 'DoctorDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DoctorsPage extends StatefulWidget {
  String? id;
  DoctorsPage({super.key, this.id});
  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}
class _DoctorsPageState extends State<DoctorsPage> {
List<dynamic> _doctorList = [];
  bool _status = false;
  bool _isLodding = true;
  @override
  void initState(){
    super.initState();
    _getStatus().then((value){
      _fetchData();
    });
    _checkLanguageStatus();
  }
bool _isEnglish =false;
void _checkLanguageStatus() async{
  final prefs = await SharedPreferences.getInstance();
  final isEnglish = prefs.getBool('isEnglish') ?? true;
  setState(() {
    _isEnglish = isEnglish;
  });
}
  Future<void> _getStatus() async{
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    bool status = prefs.getBool('status') ?? false;
    setState(() {
      _status= status;
    });
  }
Future<void> getAllDoctors() async {
  ApiResponse doctorsResponse = await getDoctor();
  if(doctorsResponse.error == null){
List<dynamic> doctorList = doctorsResponse.data as List<dynamic>;
setState(() {
  _doctorList = doctorList.cast<Doctor>();
  _isLodding =false;
});
  }else if(doctorsResponse.error == '404'){
    setState(() {
      _isLodding =false;
    });
Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>Error404(routeWidget: DoctorsPage(),)));
  }else{
    setState(() {
      _isLodding =false;
    });
Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>SomethingWrong(routeWidget: DoctorsPage(),)));
  }
}

Future<void> getDoctorsByThereName() async {
  ApiResponse doctorsByNameResponse = await getDoctorsByName(widget.id);
  if(doctorsByNameResponse.error == null){
    List<dynamic> doctorList = doctorsByNameResponse.data as List<dynamic>;
    setState(() {
      _doctorList = doctorList.cast<Doctor>();
      _isLodding =false;
    });
  }else if(doctorsByNameResponse.error == '404'){
    setState(() {
      _isLodding =false;
    });
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>Error404(routeWidget: DoctorsPage(),)));
  }else{
    setState(() {
      _isLodding =false;
    });
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>SomethingWrong(routeWidget: DoctorsPage(),)));
  }
}

void _fetchData(){
  if(_status== false){
    getAllDoctors();
  }else{
    getDoctorsByThereName();
  }
}
  @override
  Widget build(BuildContext context) => _isLodding ? WillPopScope(onWillPop: ()=> Services.onBackPressed(context),
  child: Scaffold(body: (Center(child: Lottie.asset('assets/images/animation_lkghd69s.json'))))):(_doctorList.isEmpty ?
  WillPopScope(
    onWillPop: () => Services.onBackPressed(context),
    child: Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_isEnglish ? 'Sorry, there are no doctors available for now. Please try again later.' : 'ይቅርታ፣ ለአሁን ምንም ዶክተሮች የሉም። እባክዎ ቆየት ብለው ይሞክሩ.', textAlign: TextAlign.center, style: MyText.subhead(context)!.copyWith(
                color: MyColors.grey_100_,  fontWeight: FontWeight.w400),),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                if(_status == false){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomePage()));
                }else{
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>  DepartmentPage()));
                }
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
                    Text(_isEnglish ? 'Back' : 'ተመለስ', style: MyText.subhead(context)!.copyWith(
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
        title: Text(_isEnglish ? 'Doctors' : 'ዶክተሮች',
            style: MyText.subhead(context)!.copyWith(
                color: MyColors.grey_3, fontSize: 20, fontWeight: FontWeight.w500)
        ),
        actions: [
          IconButton(
            icon: Icon( Icons.search, color: MyColors.grey_3,),
            onPressed: () {
              showSearch(context: context, delegate: SearchDoctors(list: _doctorList, isEnglish: _isEnglish));
            },
          ),
        ],
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: MyColors.navBarColor,
        foregroundColor: MyColors.grey_3,
      ),
      floatingActionButton: CustomFloatingActionButton(),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 230,
          childAspectRatio: 1,
          crossAxisSpacing: 0,
          mainAxisSpacing: 10,
        ),
        itemCount: _doctorList == null ? 0 : _doctorList.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: GestureDetector(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('timetable', false);
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>
                    DoctorsDetails(list: _doctorList, index: i),
                ));
              },
              child: Card(
                color: MyColors.grey_3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),elevation: 15,
                child: Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        child: CachedNetworkImage(
                          key: UniqueKey(),
                          imageUrl:
                          'http://www.teklehaimanothospital.com/admin/${_doctorList[i].photo}',
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
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
                    ),
                    Text(_isEnglish ? _doctorList[i].nameEn.toString() : _doctorList[i].nameAm.toString(),
                      style: MyText.medium(context).copyWith(
                          color: MyColors.grey_60,
                          fontWeight: FontWeight.w400,
                          fontSize: 15
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(_isEnglish ? _doctorList[i].poEn.toString() :_doctorList[i].poAm.toString(),
                      style: MyText.body1(context)?.copyWith(
                          color: MyColors.grey_60,
                          fontWeight: FontWeight.w400,
                          fontSize: 13
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          );

        },
      ),
      bottomNavigationBar: SubBottomNavBarContainer(),
    ),
  ));
}
