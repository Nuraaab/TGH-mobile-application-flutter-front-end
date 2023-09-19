import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:testing1212/models/apiResponse.dart';
import 'package:testing1212/pages/404.dart';
import 'package:testing1212/pages/ExpandableWidgetContainer.dart';
import 'package:testing1212/pages/somethingWrong.dart';
import 'package:testing1212/pages/teamsDetails.dart';
import 'package:testing1212/service/services.dart';
import 'package:testing1212/service/user_service.dart';

import '../data/my_colors.dart';
import '../models/team.dart';
import '../widget/my_text.dart';
import '../widget/navigation_drawer.dart';
import 'BottomNavBar.dart';
import 'home.dart';
// class Teams extends StatefulWidget {
//   const Teams({Key? key}) : super(key: key);
//
//   @override
//   State<Teams> createState() => _TeamsState();
// }
//
// class _TeamsState extends State<Teams> {
//   @override
//   void initState(){
//     super.initState();
//     _checkLanguageStatus();
//   }
//   bool _isEnglish =false;
//   void _checkLanguageStatus() async{
//     final prefs = await SharedPreferences.getInstance();
//     final isEnglish = prefs.getBool('isEnglish') ?? false;
//     setState(() {
//       _isEnglish = isEnglish;
//     });
//   }
//   Future<List> getTeams() async {
//     final prefs = await SharedPreferences.getInstance();
//     var temp = prefs.getString('jsonteams'); //get the doctors data from session
//     temp=null;
//     if (temp == null) {
//       // fetch doctors data from database and store to the session
//       final response = await http
//           .get(Uri.parse("https://teklehaimanothospital.com/api/teamGetData.php"));
//       await prefs.setString('jsonteams', response.body);
//       print(response.body);
//       return json.decode(response.body);// return the fetched data
//     } else {
//       return json.decode(temp); // return from session
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body: FutureBuilder<List>(
//         future: getTeams(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {}
//           if (snapshot.hasData) {
//             return Items(list: snapshot.data!, isEnglish: _isEnglish,);// return the widget with doctors list passed to its constructor
//           } else {
//             return  Center(child: Lottie.asset('assets/images/animation_lkgign21.json'));// return CircularProgressIndicator at the center of the page if the data is empty or not loaded
//           }
//         },
//       ),
//     );
//   }
// }
 class Teams extends StatefulWidget {
   const Teams({super.key});

   @override
   State<Teams> createState() => _TeamsState();
 }

 class _TeamsState extends State<Teams> {
  List<dynamic> _teamsList = [];
  bool _isLodding = true;
  bool _isEnglish =false;
  @override
  void initState(){
    super.initState();
    _checkLanguageStatus();
    _getTeams();
  }
  void _checkLanguageStatus() async{
    final prefs = await SharedPreferences.getInstance();
    final isEnglish = prefs.getBool('isEnglish') ?? false;
    setState(() {
      _isEnglish = isEnglish;
    });
  }
  Future<void> _getTeams() async {
    ApiResponse teamsResponse = await getTeams();
    if(teamsResponse.error == null){
      List<dynamic> teamList = teamsResponse.data as List<dynamic>;
      setState(() {
        _teamsList = teamList.cast<Team>();
        _isLodding = false;
      });
    }else if(teamsResponse.error == '404'){
      setState(() {
        _isLodding = false;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>Error404(routeWidget: Teams(),)));
    }else{
      setState(() {
        _isLodding = false;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>SomethingWrong(routeWidget: Teams(),)));
    }
  }
   @override
   Widget build(BuildContext context) => _isLodding ? WillPopScope(onWillPop: () => Services.onBackPressed(context),
   child: (Scaffold(body: Center(child: Lottie.asset('assets/images/animation_lkgign21.json')),))) :
   (_teamsList.isEmpty ? 
   WillPopScope(
     onWillPop: () => Services.onBackPressed(context),
     child: Scaffold(
       body: Container(
         margin: EdgeInsets.only(left: 15, right: 15),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Text(_isEnglish ? 'Sorry, there are no Teams available for now. Please try again later.' : 'ይቅርታ！ ለአሁን ምንም አይነት አባል የለም:: እባክዎ ቆይተው ይሞክሩ', textAlign: TextAlign.center, style: MyText.subhead(context)!.copyWith(
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
     onWillPop: ()=> Services.onBackPressed(context),
     child: Scaffold(
       drawer: NavigationDrawerWidget(),
       appBar: AppBar(
         title:  Text(_isEnglish ? 'Management Teams' : 'የማኔጅመንት አባላት',
             style: MyText.subhead(context)!.copyWith(
                 color: MyColors.grey_3, fontSize: 20, fontWeight: FontWeight.w500)
         ),
         centerTitle: true,
         elevation: 0.5,
         backgroundColor: MyColors.navBarColor,
         foregroundColor: MyColors.grey_3,
       ),
       floatingActionButton: CustomFloatingActionButton(),
       body: ListView.builder(
         itemCount: _teamsList.length,
         itemBuilder: (BuildContext context, int index) {
           return Container(
             padding: EdgeInsets.only(top: 10, left: 15, right: 15,bottom: 10),
             height: 250,
             child: Stack(
               children: <Widget>[
                 Container(
                   constraints: const BoxConstraints(
                       minHeight: 300, minWidth: double.infinity),
                   child: CachedNetworkImage(
                     key: UniqueKey(),
                     imageUrl:
                     'http://www.teklehaimanothospital.com/admin/${_teamsList[index].photo}',
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

                 GestureDetector(
                   onTap: ()
                   {
                     Navigator.of(context).push(MaterialPageRoute(builder: (_) => TeamsDetails(list: _teamsList, index: index, isEnglish: _isEnglish,)));
                   },
                   child: Container(
                       height: double.infinity,
                       width: double.infinity,
                       color: Colors.black.withOpacity(0.3)),
                 ),
                 Align(
                     alignment: Alignment.bottomLeft,
                     child: Column(
                       mainAxisSize: MainAxisSize.min,
                       mainAxisAlignment: MainAxisAlignment.end,
                       crossAxisAlignment: CrossAxisAlignment.end,
                       children: <Widget>[
                         Container(
                           padding: EdgeInsets.symmetric(vertical: 10),
                           width: 220,
                           color: Colors.black,
                           child: Column(
                             children: [
                               Text(_isEnglish ? "${_teamsList[index].nameEn}" : "${_teamsList[index].nameAm}",
                                   textAlign: TextAlign.center,
                                   style: MyText.title(context)!.copyWith(
                                       color: Colors.white,
                                       fontWeight: FontWeight.w500)),
                               SizedBox(height: 5,),
                               Container(
                                 padding: EdgeInsets.symmetric(vertical: 10),
                                 width: 200,
                                 color: MyColors.navBarColor,
                                 child: Text("${_teamsList[index].position}",
                                     textAlign: TextAlign.center,
                                     style: MyText.title(context)!.copyWith(
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500)),
                               ),
                             ],
                           ),
                         )
                       ],
                     )),

               ],
             ),
           );
         },
       ),
       bottomNavigationBar: SubBottomNavBarContainer(),
     ),
   ));
 }
