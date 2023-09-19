import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing1212/data/my_colors.dart';
import 'package:testing1212/pages/ExpandableWidgetContainer.dart';
import 'package:testing1212/pages/BottomNavBar.dart';
import 'package:testing1212/service/services.dart';
import 'package:testing1212/widget/navigation_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../data/img.dart';
import '../widget/my_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Marker> _marker = [];
  final List<Marker> _list = const [
   Marker(markerId: MarkerId('1'),
   position: LatLng(9.03136, 38.74667),
   infoWindow: InfoWindow(title: 'Teklehaymanot General Hospital'),
   ),
  ];
  GoogleMapController? mapController;
  final LatLng center = const LatLng(9.03136, 38.74667);
  void _onMapCreated(GoogleMapController controller){
    mapController = controller;
  }
  @override
  void initState(){
    super.initState();
    _checkLanguageStatus();
    _marker.addAll(_list);
  }
  bool _isEnglish =false;
  void _checkLanguageStatus() async{
    final prefs = await SharedPreferences.getInstance();
    final isEnglish = prefs.getBool('isEnglish') ?? false;
    setState(() {
      _isEnglish = isEnglish;
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Services.onBackPressed(context),
      child: Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title:  Text(_isEnglish ? 'Contact' : 'ግንኙነት'),
          centerTitle: true,
          backgroundColor: MyColors.navBarColor,
          foregroundColor: Colors.white,
        ),
        floatingActionButton: const CustomFloatingActionButton(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                            Container(
                              width: 220,
                              child: Text(_isEnglish ? "CONTACT US" : "አግኙን",
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
              Container(height: 45),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.location_on_outlined, color: MyColors.navBarColor, size: 40,)),
                  SizedBox(width: 10,),
                  Container(
                    child: Text(_isEnglish ?
                        "SomaleTera,Addis Ababa, Ethiopia" : "ሶማሌ ተራ, አዲስ አበባ, ኢትዮጵያ",
                        textAlign: TextAlign.center,
                        style: MyText.title(context)!.copyWith(
                            color: Color.fromRGBO(29, 33, 39, 1),
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                        )),
                  ),
                ],
              ),
              SizedBox(height: 5,),
              Container(
                margin: EdgeInsets.only(left: 60),
                child: Text(_isEnglish ?
                    "Teklehaimanot General Hospital SomaleTera, Infront of Global Insurance Addis Ababa, Ethiopia" :"ተክለሃይማኖት አጠቃላይ ሆስፒታል ሶማሌተራ፣ ግሎባል ኢንሹራንስ ፊት ለፊት አዲስ አበባ፣ ኢትዮጵያ",
                    style: MyText.subhead(context)!
                        .copyWith(color: Color.fromRGBO(119, 119, 119, 1))),
              ),
              SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.call, color: MyColors.navBarColor, size: 40,)),
                  SizedBox(width: 10,),
                  Text(_isEnglish ?
                      "Phone" : "ስልክ",
                      textAlign: TextAlign.center,
                      style: MyText.title(context)!.copyWith(
                        color: Color.fromRGBO(29, 33, 39, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      )),
                ],
              ),
              SizedBox(height: 5,),
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(left: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "+251 940 333 333",
                        style: MyText.subhead(context)!
                            .copyWith(color: Color.fromRGBO(119, 119, 119, 1))),
                    Text(
                        "+251 943 656 565",
                        style: MyText.subhead(context)!
                            .copyWith(color: Color.fromRGBO(119, 119, 119, 1))),
                    Text(
                        "+251 111 561 287",
                        style: MyText.subhead(context)!
                            .copyWith(color: Color.fromRGBO(119, 119, 119, 1))),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.mail_outline, color: MyColors.navBarColor, size: 40,)),
                  SizedBox(width: 10,),
                  Text(_isEnglish ?
                      "Email" : "ኢሜይል",
                      textAlign: TextAlign.center,
                      style: MyText.title(context)!.copyWith(
                        color: Color.fromRGBO(29, 33, 39, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      )),
                ],
              ),
              SizedBox(height: 5,),
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(left: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "info@tgh.com",


                        style: MyText.subhead(context)!
                            .copyWith(color: MyColors.navBarColor)),

                  ],
                ),
              ),
              // display the address title
              SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.map_rounded, color: MyColors.navBarColor, size: 40,)),
                  SizedBox(width: 10,),
                  Text(_isEnglish ?
                      "Address" : "አድራሻ",
                      textAlign: TextAlign.center,
                      style: MyText.title(context)!.copyWith(
                        color: Color.fromRGBO(29, 33, 39, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      )),
                ],
              ),
              Container(height: 5),
              SizedBox(
                width: double.infinity,
                height: 300,
                child: GoogleMap(
                  markers: Set.of(_marker),
                  compassEnabled: true,
                  scrollGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  mapToolbarEnabled: true,
                  tiltGesturesEnabled: true,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: center,
                    zoom: 17.0,
                  ),
                ),
              ),
              Container(height: 15),
              Container(
                width: double.maxFinite,
                color: MyColors.secondary,
                padding: EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_isEnglish ? "Opening Hours" :"ክፍት የሚሆንበት ሰዓቶች",
                        textAlign: TextAlign.center,
                        style: MyText.title(context)!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          height: 1.6875,
                          fontSize: 22.4,
                        )),
                    const SizedBox(height: 10,),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16.0),
                      child:  Text(_isEnglish ?
                        "Sun - sun: 24 Hour Open" : "ከእሁድ - እሁድ: 24 ሰዓት",
                        style: TextStyle(
                          fontSize: 16.0,
                          height: 1.4,
                          color: Color(0xFFEEEEEE),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Text(_isEnglish ? "Emergency Case" : "የአስቸኳይ ጊዜ ስልክ",
                        textAlign: TextAlign.center,
                        style: MyText.title(context)!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          height: 1.6875,
                          fontSize: 22.4,
                        )),
                    const SizedBox(height: 10,),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16.0),
                      child: const Text(
                        "(+251)8175",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                          color: Color(0xFFEEEEEE),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Text(_isEnglish ? "Social Media" : "ማህበራዊ ሚዲያ",
                        textAlign: TextAlign.center,
                        style: MyText.title(context)!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          height: 1.6875,
                          fontSize: 22.4,
                        )),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(onTap: (){launch('https://www.facebook.com/teklehaimanothospital');}, child: const FaIcon(FontAwesomeIcons.facebook, color: MyColors.grey_3 , size: 40,)),
                          const SizedBox(width: 10,),
                          InkWell(onTap: (){launch('https://twitter.com/TeklehaimanotG4');}, child: const FaIcon(FontAwesomeIcons.twitter, color:  MyColors.grey_3, size: 40,)),
                          const SizedBox(width: 10,),
                          InkWell(onTap: (){launch('https://www.youtube.com/');}, child: const FaIcon(FontAwesomeIcons.youtube, color: MyColors.grey_3,size: 40,)),
                          const SizedBox(width: 10,),
                          InkWell(onTap: (){launch('https://www.linkedin.com/.../teklehaimanot-general-hospital/');}, child: const FaIcon(FontAwesomeIcons.linkedin, color: MyColors.grey_3, size: 40,)),
                          const SizedBox(width: 10,),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: const SubBottomNavBarContainer(),
      ),
    );
  }
}
