import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing1212/models/apiResponse.dart';
import 'package:testing1212/models/departmentCount.dart';
import 'package:testing1212/models/doctorCount.dart';
import 'package:testing1212/pages/404.dart';
import 'package:testing1212/pages/booking.dart';
import 'package:testing1212/pages/department.dart';
import 'package:testing1212/pages/login_card_overlap.dart';
import 'package:testing1212/pages/share.dart';
import 'package:testing1212/pages/BottomNavBar.dart';
import 'package:testing1212/pages/somethingWrong.dart';
import 'package:testing1212/pages/webViewWidget.dart';
import 'package:testing1212/service/services.dart';
import 'package:testing1212/service/user_service.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import '../data/my_colors.dart';
import '../models/about.dart';
import '../widget/my_text.dart';
import '../widget/navigation_drawer.dart';
import 'ExpandableWidgetContainer.dart';
import 'doctors.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
class HomePage extends StatefulWidget {
   HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _getUserData();
    _getAboutData();
    _getDepartmentCount();
    _getDoctorsCount();
    _getTestimonialData();
    _setSelectedLanguage();
    _getSliders();
  }
  late int currentYear = DateTime.now().year;
  late int intialYear = 2000;
  late int yearDifference = (currentYear - intialYear).toInt();
  List<dynamic> _data = [];
  List<dynamic> _dept_no = [];
  List<dynamic> _docs_no = [];
  List<dynamic> _testimonial = [];
  List<dynamic> sliderList = [];
  late List<dynamic> dynamicCountList = _dept_no as List<dynamic>;
  late List<DepartmentCount> countList = dynamicCountList.map((item) => item as DepartmentCount).toList();
  late List<DoctorsCount> docsCount = _docs_no.map((item) => item as DoctorsCount).toList();
  late List<dynamic> dynamicList = _data as List<dynamic>;
  late List<About> aboutList = dynamicList.map((item) => item as About).toList();
  late String description ='${aboutList[0].descriptionEn}';
  late String trimedDescription = description.trim();
  late  String encodedDescription = jsonEncode(trimedDescription);
  late String noQuotesDescription = encodedDescription.replaceAll('"', '');
  late String breakReplaced = noQuotesDescription.replaceAll(RegExp(r'<br>|<\/br>'), '');
  late String descriptionAm ='${aboutList[0].descriptionAm}';
  late String encodedText = descriptionAm.codeUnits.map((unit) => '\\u${unit.toRadixString(16).padLeft(4, '0')}').join('');
  late String encodedTextBreakReplaced = encodedText.replaceAll(RegExp(r'<br>|<\/br>'), '');
  late  String encodedDescriptionAm = jsonEncode(encodedText);
  late String noQuotesDescriptionAm = encodedDescription.replaceAll('"', '');
  late String breakReplacedAm = noQuotesDescription.replaceAll(RegExp(r'<br>|<\/br>'), '');
  late String _selectedLanguage = "English";
  late bool _isEnglish;
  List<String> _languages = ['English','አማርኛ'];

  void _setSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool selectedLanguage = prefs.getBool('isEnglish') ?? true;
    print('selected status ${selectedLanguage}');
    setState(() {
      if(selectedLanguage == true){
        _selectedLanguage = "English";
        _isEnglish =true;
      }else{
        _selectedLanguage = "አማርኛ";
        _isEnglish = false;
      }
    });
  }
  Future<void> _getSliders() async {
    ApiResponse sliderResponse = await getSlider();
    if(sliderResponse.error ==null){
      List<dynamic> slider = sliderResponse.data as List<dynamic>;
      setState(() {
        sliderList = slider;
      });
    }else if(sliderResponse.error =='404'){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Error404(routeWidget: HomePage(),)));
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SomethingWrong(routeWidget: HomePage(),)));
    }
  }
  Future<void> _getAboutData() async {
ApiResponse aboutResponse =  await fetchAboutData();
if(aboutResponse.error == null){
  List<dynamic> about = aboutResponse.data as List<dynamic>;
  setState(() {
    _data = about;
  });
}else if(aboutResponse.error == '404'){
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>Error404(routeWidget: HomePage(),)));
}else{
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> SomethingWrong(routeWidget: HomePage()),));
}
  }

  Future<void> _getDepartmentCount() async {
    ApiResponse departmentCountResponse  = await getDepartmentCount();
    if(departmentCountResponse.error == null){
      List<dynamic> count = departmentCountResponse.data as List<dynamic>;
      setState(() {
        _dept_no =count;
      });
    }else if(departmentCountResponse.error == '404'){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Error404(routeWidget: HomePage(),)));
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SomethingWrong(routeWidget: HomePage(),)));
    }
  }

  Future<void> _getTestimonialData() async {

    ApiResponse testimonialResponse = await getTestimonials();
    if(testimonialResponse.error == null){
      List<dynamic> testimonial = testimonialResponse.data as List<dynamic>;
      setState(() {
        _testimonial = testimonial;
      });
    }else if(testimonialResponse.error == '404'){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Error404(routeWidget: HomePage(),)));
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SomethingWrong(routeWidget: HomePage(),)));
    }

  }

  Future<void> _getDoctorsCount() async {
    ApiResponse doctorsCountResponse = await getDoctorsCount();
    if(doctorsCountResponse.error == null){
      List<dynamic> count = doctorsCountResponse.data as List<dynamic>;
      setState(() {
        _docs_no = count;
      });
    }else if(doctorsCountResponse.error == '404'){
     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Error404(routeWidget: HomePage(),)));
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SomethingWrong(routeWidget: HomePage(),)));
    }
  }
  String _email = '';
  Future<void> _getUserData() async{
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    setState(() {
      _email= email;
    });
  }
void _navigateToAppointmentPage()  {
    if(_email.isEmpty){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginCardOverlapRoute()));
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => BookingPage(email: _email)));
    }
}

  @override
  Widget build(BuildContext context)=>
      _data.isEmpty || _dept_no.isEmpty || _docs_no.isEmpty || _testimonial.isEmpty ?  WillPopScope(
        onWillPop: ()=> Services.onBackPressed(context),
        child: Scaffold(
          body: Center(
            child: Lottie.asset('assets/images/animation_lkghd69s.json'),
          ),
        ),
      ): 
      WillPopScope( onWillPop: () => Services.onBackPressed(context),
        child: Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Text(_isEnglish ? 'TGH' : 'ተ.ጠ.ሆ',
            style: TextStyle(
              fontWeight:_isEnglish ? FontWeight.bold: FontWeight.normal,
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(top: 5),
              child: DropdownButton<String>(
                icon: Icon(Icons.arrow_drop_down, color: MyColors.grey_3,),
                value: _selectedLanguage,
                onChanged: (String? language) async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  setState(() {
                    _selectedLanguage = language!;
                   if (language == 'English') {
                      prefs.setBool('isEnglish', true);
                    } else {
                      prefs.setBool('isEnglish', false);
                    }
                    bool? isEnglish = prefs.getBool('isEnglish');
                    _isEnglish = isEnglish!;
                  });
                },
                items: _languages.map<DropdownMenuItem<String>>((String language) {
                  print('language : ${language}');
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(
                      language,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MyColors.grey_20,
                      ),
                    ),
                  );
                }).toList(),
                underline: Container(
                  height: 0,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
          backgroundColor: MyColors.navBarColor,
          foregroundColor: MyColors.grey_3,
        ),
        floatingActionButton: const CustomFloatingActionButton(),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 15),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 5/1,
                      autoPlayCurve: Curves.easeInOut,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 1.5,
                    ),
                    items: sliderList.map((imageUrl) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height:200,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child:  CachedNetworkImage(
                              key: UniqueKey(),
                              imageUrl:
                              'http://www.teklehaimanothospital.com/admin/${imageUrl['image']}',
                              height: 200,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                ),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/images/place_holder.png',
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,

                              ),

                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),

                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // ignore: prefer_const_constructors
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(_isEnglish ? 'About Us' : 'ስለ ተክለሀይማኖት ሆስፒታል',
                              style: MyText.subhead(context)!.copyWith(
                                  color: MyColors.secondary, fontSize: _isEnglish ? 40 : 30,letterSpacing: 1, fontWeight: FontWeight.w500)
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Container(height: 50,width: 2, color: MyColors.secondary,),
                            SizedBox(width: 20,),
                            Text(_isEnglish ? aboutList[0].motoEn.toString() : aboutList[0].motoAm.toString(),
                                style: MyText.body2(context)!.copyWith(
                                    color: MyColors.grey_60,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500
                                )
                            ),
                          ],
                        ),
                      ),
                      _isEnglish ? WebViewWidget(webViewContents: breakReplaced): WebViewPlusAm(amharicContent: encodedTextBreakReplaced),
                      SizedBox(height: 10,),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height:200,
                        child:  CachedNetworkImage(
                          key: UniqueKey(),
                          imageUrl:
                          'http://www.teklehaimanothospital.com/admin/${aboutList[0].logo}',
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/place_holder.png',
                            height: 155,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,

                          ),

                        ),
                      ),
                      Container(height: 20),
                      Container(
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                IconButton(onPressed: (){}, icon: Icon(Icons.person_2_outlined, color: MyColors.secondary, size: 40,)),
                                SizedBox(height: 5,),
                                Text('${docsCount[0].totalDocs}+',
                                    style: MyText.medium(context).copyWith(
                                      color: MyColors.secondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    )),
                                SizedBox(height: 5,),
                                Text(_isEnglish ? "Doctors" : 'ሀኪሞች',
                                    style: MyText.medium(context).copyWith(
                                      color: MyColors.secondary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    )),

                              ],
                            ),
                            SizedBox(width: 10,),
                            Column(
                              children: [
                                IconButton(onPressed: (){}, icon: Icon(Icons.business, color: MyColors.secondary, size: 40,)),
                                SizedBox(height: 5,),
                                Text('${countList[0].totalDept}+',
                                    style: MyText.medium(context).copyWith(
                                      color: MyColors.secondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    )),
                                SizedBox(height: 5,),
                                Text(_isEnglish ? "Departments" : 'የስራ ክፍሎች',
                                    style: MyText.medium(context).copyWith(
                                      color: MyColors.secondary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    )),

                              ],
                            ),
                            SizedBox(width: 10,),
                            Column(
                              children: [
                                IconButton(onPressed: (){}, icon: Icon(Icons.calendar_today, color: MyColors.secondary, size: 40,)),
                                SizedBox(height: 5,),
                                Text('${yearDifference}+',
                                    style: MyText.medium(context).copyWith(
                                      color: MyColors.secondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    )),
                                SizedBox(height: 5,),
                                Text(_isEnglish ? "Years" : 'አመታት',
                                    style: MyText.medium(context).copyWith(
                                        color: MyColors.secondary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18
                                    )),
                              ],
                            ),
                          ],),
                      ),
                      Container(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _navigateToAppointmentPage();
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: Colors.white,
                              elevation: 6,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: SizedBox(
                                height: 150,
                                width: 160,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20), // set border radius of container
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.white60, // set shadow color
                                        spreadRadius: 1, // set the spread radius of the shadow
                                        blurRadius: 1, // set the blur radius of the shadow
                                        offset: Offset(0, 1), // set offset of the shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Icon(Icons.more_time,
                                            size: 40, color: Colors.yellow[900]),
                                      ),
                                      Text(_isEnglish ? 'Appointment' : 'ቀጠሮ',
                                          textAlign: TextAlign.center,
                                          style: MyText.subhead(context)!
                                              .copyWith(color: MyColors.primaryDark,  letterSpacing: 1)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setBool('status', false);
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>  DepartmentPage()));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: Colors.white,
                              elevation: 6,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Container(
                                height: 150,
                                width: 160,
                                alignment: Alignment.center,
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20), // set border radius of container
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.white60, // set shadow color
                                      spreadRadius: 1, // set the spread radius of the shadow
                                      blurRadius: 1, // set the blur radius of the shadow
                                      offset: Offset(0, 1), // set offset of the shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(Icons.people,
                                          size: 40, color: Colors.pink[600]),
                                    ),
                                    Text(_isEnglish ? 'Departments' : 'የስራ ክፍሎች',
                                        textAlign: TextAlign.center,
                                        style: MyText.subhead(context)!
                                            .copyWith(color: MyColors.primaryDark, letterSpacing: 1)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async  {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setBool('status', false);
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (context) => DoctorsPage(),
                              ));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),

                              color: Colors.white,
                              elevation: 6,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Container(
                                height: 150,
                                width: 160,
                                alignment: Alignment.center,
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20), // set border radius of container
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.white60, // set shadow color
                                      spreadRadius: 1, // set the spread radius of the shadow
                                      blurRadius: 1, // set the blur radius of the shadow
                                      offset: Offset(0, 1), // set offset of the shadow
                                    ),
                                  ],
                                ),

                                child: Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Icon(Icons.medical_services,
                                            size: 40, color: Colors.red[600]),
                                      ),
                                      Text(_isEnglish ? 'Doctors' : 'ሀኪሞች',
                                          textAlign: TextAlign.center,
                                          style: MyText.subhead(context)!
                                              .copyWith(color: MyColors.primaryDark, letterSpacing: 1)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (context) => ContactPage(),
                              ));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: Colors.white,
                              elevation: 6,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Container(
                                height: 150,
                                width: 160,
                                alignment: Alignment.center,
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20), // set border radius of container
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.white60, // set shadow color
                                      spreadRadius: 1, // set the spread radius of the shadow
                                      blurRadius: 1, // set the blur radius of the shadow
                                      offset: Offset(0, 1), // set offset of the shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(Icons.contact_phone,
                                          size: 40, color: Colors.green[600]),
                                    ),
                                    Text(_isEnglish ? 'Contact' : 'ግንኙነት',
                                        textAlign: TextAlign.center,
                                        style: MyText.subhead(context)!
                                            .copyWith(color: MyColors.primaryDark, letterSpacing: 1)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30,),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: 400,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            aspectRatio: 5/1,
                            autoPlayCurve: Curves.easeInOut,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration: Duration(milliseconds: 900),
                            viewportFraction: 1.0,
                          ),
                          items: _testimonial.map((testimonial) {
                            final String testimonialDescription = '${testimonial['testimon']}';
                            final String encodedtestimonialDescription = jsonEncode(testimonialDescription);
                            final String replacedencodedtestimonialDescription = encodedtestimonialDescription.replaceAll('"', '');
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                  width: MediaQuery.of(context).size.width,
                                  color: MyColors.secondary,
                                  child:   Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: MyColors.secondary,
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.5),
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(100),
                                        ),



                                        child: const RotatedBox(quarterTurns: 90,
                                            child: Icon(Icons.format_quote_rounded, color: MyColors.grey_3,size: 50,)),
                                      ),
                                      const Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          RotatedBox(quarterTurns: 90,
                                              child: Icon(Icons.format_quote, color: MyColors.grey_3, size: 30,)),

                                        ],
                                      ),
                                      Container(
                                        color: MyColors.secondary,
                                        height: 170,
                                        width: MediaQuery.of(context).size.width,
                                        child: WebViewPlus(
                                          onWebViewCreated: (controller) {
                                            final htmlContent = """
        <!DOCTYPE html>
        <html>
          <head>
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <style>
                p {
                     color: white;
    line-height: 24px;
    margin: 0 0 20px;
    display: block;
    margin-block-start: 1em;
    margin-block-end: 1em;
    margin-inline-start: 0px;
    margin-inline-end: 0px;
                }
                body{
                background-color:#06aa9c;
                  font-family: Poppins, sans-serif;
                }
                li {
                list_style:none;
                }
              </style>
          </head>
          <body>
              <div id="content"></div>
              <script>
                const contentDiv = document.getElementById('content');
                contentDiv.innerHTML = '${replacedencodedtestimonialDescription.replaceAll('/n', '')}';
              </script>
          </body>
        </html>
    """;
                                            final uri = Uri.dataFromString(htmlContent,
                                                mimeType: 'text/html', encoding: utf8);
                                            controller.loadUrl(uri.toString());
                                          },

                                          javascriptMode: JavascriptMode.unrestricted,
                                          navigationDelegate: (NavigationRequest request) {
                                            return NavigationDecision.navigate;
                                          },
                                          gestureNavigationEnabled: true,
                                          onWebResourceError: (error) {
                                            print('Error loading page: $error');
                                          },
                                        ),
                                      ),
                                      const Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Icon(Icons.format_quote, color: MyColors.grey_3, size: 30,)
                                        ],
                                      ),
                                      Center(
                                        child: Text(testimonial['name'],
                                            style: MyText.body2(context)!.copyWith(
                                              color: MyColors.grey_3,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            )
                                        ),
                                      ),
                                      SizedBox(height: 5,),

                                      Center(
                                        child: Text(testimonial['position'],
                                            style: MyText.body2(context)!.copyWith(
                                              color: MyColors.grey_3,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15,
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),

                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
          bottomNavigationBar: SubBottomNavBarContainer(),
      ),
      );
}

