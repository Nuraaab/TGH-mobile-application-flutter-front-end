import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:testing1212/data/my_colors.dart';
import 'package:testing1212/models/apiResponse.dart';
import 'package:testing1212/pages/404.dart';
import 'package:testing1212/pages/DepartmentDetails.dart';
import 'package:testing1212/pages/ExpandableWidgetContainer.dart';
import 'package:testing1212/pages/BottomNavBar.dart';
import 'package:testing1212/pages/searchDepartments.dart';
import 'package:testing1212/pages/somethingWrong.dart';
import 'package:testing1212/service/services.dart';
import 'package:testing1212/service/user_service.dart';
import '../models/department.dart';
import '../widget/my_text.dart';
import '../widget/navigation_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'doctors.dart';
import 'home.dart';


class DepartmentPage extends StatefulWidget {
  DepartmentPage({super.key});// assign the variable to constructor and make it required
  @override
  State<DepartmentPage> createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  List<dynamic> _departmentList = [];
List<dynamic> modelList = [];
  bool _status = false;
  @override
  void initState(){
    super.initState();
    _getStatus();
    _checkLanguageStatus();
    _getDepartments();
  }
  bool _isEnglish =false;
  bool _isLodding = true;
  // late List<Department> modelList = _departmentList.map((item) => item as Department).toList();
  Future<void> _getDepartments() async {
    ApiResponse departmentResponse = await getDepartment();
    if(departmentResponse.error == null){
      List<dynamic> departmentList = departmentResponse.data as List<dynamic>;
      setState(() {
        // _departmentList = departmentList;
        modelList = departmentList.cast<Department>();
        _isLodding = false;
      });
    }else if(departmentResponse.error == '404'){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>Error404(routeWidget: DepartmentPage(),)));
   setState(() {
     _isLodding = false;
   });
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SomethingWrong(routeWidget: DepartmentPage()),));
    setState(() {
      _isLodding = false;
    });
    }
  }
  void _checkLanguageStatus() async{
    final prefs = await SharedPreferences.getInstance();
    final isEnglish = prefs.getBool('isEnglish') ?? false;
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
  void _navigateToPages(int i){
    if(_status == false){
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>
          DepartmentDetails(list: modelList, index: i),
      ));
    }else{
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>
          DoctorsPage(id: modelList[i].id,),
      ));
    }
  }

 @override
  Widget build(BuildContext context)=>_isLodding ? WillPopScope(onWillPop: () => Services.onBackPressed(context),
  child: Scaffold(body: ( Center(child: Lottie.asset('assets/images/animation_lkgign21.json'))))) : (modelList.isEmpty ? Scaffold(
    body: Container(
     margin: EdgeInsets.only(left: 15, right: 15),
     child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         Text(_isEnglish ? 'Sorry, there are no department available for now. Please try again later.' : 'ይቅርታ፣ ለአሁን ምንም የስራ ክፍል የለም። እባክዎ ቆየት ብለው ይሞክሩ.', textAlign: TextAlign.center, style: MyText.subhead(context)!.copyWith(
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
                 Text(_isEnglish ? 'Back' : 'ተመለስ', style: MyText.subhead(context)!.copyWith(
                     color: MyColors.grey_3, fontSize: 18, fontWeight: FontWeight.w500)),
               ],
             ),
           ),
         ),
       ],
     ),),
  ) :
  WillPopScope(
    onWillPop: () => Services.onBackPressed(context),
    child: WillPopScope(
      onWillPop: () => Services.onBackPressed(context),
      child: Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title:  Text(_isEnglish ? 'Departments' : 'የስራ ክፍሎች',
            style: MyText.subhead(context)!.copyWith(
                color: MyColors.grey_3, fontSize: 20, fontWeight: FontWeight.w500)
        ),
        actions: [
          IconButton(
            icon: Icon( Icons.search_outlined, color: MyColors.grey_3,),
            onPressed: () {
              showSearch(context: context, delegate: SearchDepartments(list: modelList, status: _status, context: context, isEnglish: _isEnglish));
            },
          ),
        ],
        centerTitle: true,
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
        itemCount: modelList == null ? 0 : modelList.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: GestureDetector(
              onTap: (){
                _navigateToPages(i);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                elevation: 15,
                child: Column(
                  children: [
                    Expanded(
                      child: CachedNetworkImage(
                        key: UniqueKey(),
                        imageUrl:
                        'http://www.teklehaimanothospital.com/admin/${modelList[i].icon}',
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/place_holder.png',
                          height: 230,
                          width:300,
                          fit: BoxFit.cover,
                        ),
                        width:300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(height: 10),
                    Text(_isEnglish ? modelList[i].titleEn.toString() : modelList[i].titleAm.toString(),
                      style: MyText.medium(context).copyWith(
                          color: MyColors.grey_60,
                          fontWeight: FontWeight.w400,
                          fontSize: 15
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Container(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SubBottomNavBarContainer(),
    ),
    ),
  ));
}
