import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing1212/data/my_colors.dart';
import 'package:testing1212/models/apiResponse.dart';
import 'package:testing1212/pages/404.dart';
import 'package:testing1212/pages/booking.dart';
import 'package:testing1212/pages/department.dart';
import 'package:testing1212/pages/doctors.dart';
import 'package:testing1212/pages/events.dart';
import 'package:testing1212/pages/login_card_overlap.dart';
import 'package:testing1212/pages/somethingWrong.dart';
import 'package:testing1212/service/services.dart';
import 'package:testing1212/service/user_service.dart';
import '../constatnts/constant.dart';
import '../models/user.dart';
import '../pages/about.dart';
import '../pages/health_tip.dart';
import 'package:testing1212/widget/snackbar.dart';
import '../pages/home.dart';
import '../pages/service.dart';
import '../pages/teams.dart';
import '../pages/timetable.dart';
import 'package:uuid/uuid.dart';
import '/widget/my_text.dart';
import '/data/img.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({super.key});

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}
class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final padding = const EdgeInsets.symmetric(horizontal: 20);
  File? _image;
  String _email = '';
  Future<void> _getUserData() async{
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    setState(() {
      _email= email;
    });
  }
  List<dynamic> _profileData = [];
  bool _isLoggedIn=false;
  bool _isProfileLodding = true;
  @override
  void initState(){
    super.initState();
    _checkLoginStatus();
    _getUserData();
    _getProfile();
    _checkLanguageStatus();
  }
  bool _isEnglish =false;
  void _checkLanguageStatus() async{
    final prefs = await SharedPreferences.getInstance();
    final isEnglish = prefs.getBool('isEnglish') ?? false;
    setState(() {
      _isEnglish = isEnglish;
    });
  }
  Future<void> _getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    ApiResponse userResponse = await getUser(email);
    if(userResponse.error == null){
      List<dynamic> profileData = userResponse.data as List<dynamic>;
      setState(() {
        _profileData = profileData.cast<User>();
        print('profile photo :${profileData[0].avatar}');
        _isProfileLodding = false;
      });
    }else if(userResponse.error == '404'){
      setState(() {
        _isProfileLodding =false;
      });
      snackBar.show(
          context, _isEnglish ? "Page not found. please try again" : "ገጹ አልተገኘም። እባክዎ እንደገና ይሞክሩ：：", Colors.red);
    }else{
      setState(() {
        _isProfileLodding =false;
      });
      snackBar.show(
          context, _isEnglish ? "Something went wrong. please try again" : "ስህተት ተገኝቷል። እባክዎ እንደገና ይሞክሩ：：", Colors.red);
    }
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var temp = prefs.getString('profile');
    // String email = prefs.getString('email') ?? '';
    // temp=null;
    // try {
    //   if(temp==null){
    //     final response = await http.post(Uri.parse("https://teklehaimanothospital.com/api/userGetData.php"), body: {
    //       'email': email,
    //     });
    //     final data = json.decode(response.body); // decode the response body as a List<dynamic>
    //     prefs.setString('profile', response.body); // store the response body as a String
    //     setState(() {
    //       _profileData = data; // assign the decoded data to the _dept_no variable
    //     });
    //   }else{
    //     setState(() {
    //       _profileData = json.decode(temp!);
    //     });
    //   }
    // } catch (e) {
    //   print('Error fetching data: $e');
    //   setState(() {
    //     _profileData = [];
    //   });
    // }
  }
  Future _updateProfile(BuildContext context, String avator) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    ApiResponse profileResponse = await updateProfile(avator, email);
    if(profileResponse.error == null){
      snackBar.show(
          context,_isEnglish ?
      "${profileResponse.success}" : "ፕሮፋይልዎን ማስተካከል ተሳክቷል።",
          Colors.green);
    }else if(profileResponse.error == something){
      snackBar.show(
          context, _isEnglish ? "Something went wrong. please try again" : "ስህተት ተገኝቷል። እባክዎ እንደገና ይሞክሩ：：", Colors.red);
    }else{
      snackBar.show(
          context, _isEnglish ? "Something went wrong. please try again" : "ስህተት ተገኝቷል። እባክዎ እንደገና ይሞክሩ：：", Colors.red);
    }
  }
void _checkLoginStatus() async{
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
}

void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      _isLoggedIn = false;
    });
}
Widget _buildLogOutButton(){
    return  ListTile(
      title: Text(_isEnglish ? "Logout" : "ውጣ",
          style: MyText.subhead(context)!.copyWith(
              color: Colors.black, fontWeight: FontWeight.w500)),
      leading: const Icon(Icons.logout, size: 25.0, color: Colors.black,),
      onTap: () {
        _logout();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> HomePage()));
      },
    );
}
Widget _buildLoginButton(){
    return ListTile(
      title: Text("",
          style: MyText.subhead(context)!.copyWith(
              color: MyColors.grey_3, fontWeight: FontWeight.w500)),

    );
}
  void _navigateToAppointmentPage(){
    if(_email.isEmpty){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginCardOverlapRoute()));
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => BookingPage(email: _email)));
    }
  }
  late bool _isUploaded =false;
  Future<void> _pickImage(ImageSource sources) async {
    final image = (await ImagePicker().pickImage(source: sources));
   if(image == null) return;
   final imageTemporary = File(image.path);
   setState(() {
     this._image = imageTemporary;
     _isUploaded = false;
   });
    var uuid = Uuid();
    var imageName = uuid.v4();
    String imagn = path.basename(image.path);
    print('imagge name is ${imagn}');
   var isUploaded  = await upload(this._image!, imageName);
   print('status : $_isUploaded');
   if(isUploaded){
     print('profile uploaded successfully');
     _updateProfile(context, 'user_images/${imageName}.jpg' );
     setState(() {
       _isUploaded =true;
     });
   }else{
     setState(() {
       _isUploaded =true;
     });
     snackBar.show(
         context, _isEnglish ? "Profile image can not uploaded!" : "ፕሮፋይልዎን መጫን አልተቻለም። እባክዎ እንደገና ይሞክሩ：：", Colors.red);
     print('error during uploading');
   }
  }
  Future<bool> upload(File user_image, String file_name) async {
    final bytes = user_image.readAsBytesSync();
    final data = {
      "user_image": base64Encode(bytes),
      "file_name": file_name,
    };
    ApiResponse uploadImageResponse = await uploadImage(data);
    print('message :${uploadImageResponse.message}');
    if(uploadImageResponse.error == null){
      if(uploadImageResponse.message == '1'){
        return true;
      }else{
        return false;
      }
    }else{
     return false;
    }
  }
  Widget CustomeButton({required String title, required IconData icon, required VoidCallback onClick}){
    return Container(
      width: 200,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.navBarColor,),
        onPressed: onClick,
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 20,),
            Text(title),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context)=>
      ((_profileData.isEmpty) && _isLoggedIn) ? Center(child: Lottie.asset('assets/images/animation_lkgign21.json'),) : WillPopScope(
        onWillPop: () => Services.onBackPressed(context),
        child: Drawer(
    child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: _isLoggedIn ? 300 :270,
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      Img.get('tk_home.jpg'),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: _isLoggedIn ? Colors.black.withOpacity(0.8): Colors.black.withOpacity(0.1)),
                    _isLoggedIn ?  Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Container(
                                    width:300,
                                    child: Column(
                                      mainAxisAlignment:MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                          child: ClipOval(
                                            child: _image!=null ? Container(
                                              width: 100,
                                              height: 100,
                                              child: _isUploaded ? Image.file(_image!,
                                                fit: BoxFit.cover,
                                              ) : Center(child: Lottie.asset('assets/images/animation_lkf75omg.json'),),
                                            ):CachedNetworkImage(
                                              key: UniqueKey(),
                                              imageUrl:
                                              'http://www.teklehaimanothospital.com/admin/${_profileData[0].avatar}',
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
                                        ),
                                        SizedBox(height: 10,),
                                        Text(_profileData[0].name,
                                            textAlign: TextAlign.center,
                                            style: MyText.body1(context)!.copyWith(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 3,),
                                      ],
                                    ),
                                  ),
                                  CustomeButton(title:_isEnglish ? 'Pick From Gallery' : 'ከጋለሪ ምረጥ', icon: Icons.image_outlined, onClick:()=> _pickImage(ImageSource.gallery)),
                                  CustomeButton(title: _isEnglish ? 'Pick From Camera' :  'ካሜራ አንሳ', icon: Icons.camera_alt_outlined, onClick: ()=> _pickImage(ImageSource.camera)),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                          ],
                        )) : Text(''),
                  ],
                ),
              ),
              ListTile(
                title: Text(_isEnglish ? "Home" : "መነሻ",
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.black,   fontWeight: FontWeight.w500)),
                leading: const Icon(Icons.home, size: 25.0, color: Colors.black,),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> HomePage()));
                },
              ),
              ListTile(
                title: Text(_isEnglish ? "Appointment" : "ቀጠሮ",
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.black,   fontWeight: FontWeight.w500),
                ),
                leading:
                const Icon(Icons.more_time, size: 25.0, color: Colors.black,),
                onTap: () {
                  _navigateToAppointmentPage();
                },
              ),
              ListTile(
                title: Text(_isEnglish ? "Deparments" : "የስራ ክፍሎች",
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w500)),
                leading:
                const Icon(Icons.category, size: 25.0, color: Colors.black,),
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool('status', false);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>  DepartmentPage()));
                },
              ),
              ListTile(
                title: Text(_isEnglish ? "Doctors" : "ሀኪሞች",
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w500)),
                leading: const Icon(Icons.monitor_heart,
                  size: 25.0, color: Colors.black,),
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool('status', false);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => DoctorsPage()));
                },
              ),
              const Padding(
                padding: EdgeInsets.only(right: 100),
                child: Divider(color: Colors.black,),
              ),
              ListTile(
                title: Text(_isEnglish ? "Time Table" : "የሀኪሞች የጊዜ ሴሌዳ",
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w500)),
                leading: const Icon(Icons.calendar_month_rounded,
                  size: 25.0, color: Colors.black,),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>  TimeTablePage()));
                },
              ),
              ListTile(
                title: Text(_isEnglish ? "Events" : "ዝግጅቶች",
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w500)),
                leading: const Icon(Icons.event_available,
                  size: 25.0, color: Colors.black,),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>  EventssPage()));
                },
              ),
              const Padding(
                padding: EdgeInsets.only(right: 100),
                child: Divider(color: Colors.black),
              ),
              ListTile(
                title: Text(_isEnglish ? "About" : "ስለ ተክለሀይማኖት ሆስፒታል",
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.black,  fontWeight: FontWeight.w500)),
                leading: const Icon(Icons.info, size: 25.0, color: Colors.black,),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>  AboutCompanyImageRoute()));
                },
              ),
              ListTile(
                title: Text(_isEnglish ? "Services" : "አገልግሎቶች",
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w500)),
                leading: const FaIcon(FontAwesomeIcons.briefcase, size: 22.0, color: Colors.black,),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>  SupportiveServices()));
                },
              ),
              ListTile(
                title: Text(_isEnglish ? "Health Tips" : "የጤና ምክሮች",
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w500)),
                leading: const FaIcon(FontAwesomeIcons.heartPulse, size: 22.0, color: Colors.black,),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>  HealthTips()));
                },
              ),
              ListTile(
                title: Text(_isEnglish ? "Management Teams" : "የማኔጅመንት አባላት",
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w500)),
                leading: const FaIcon(FontAwesomeIcons.users, size: 22.0, color: Colors.black,),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const Teams()));
                },
              ),
              const Padding(
                padding: EdgeInsets.only(right: 100),
                child: Divider(color: Colors.black,),
              ),
              _isLoggedIn ? _buildLogOutButton() : _buildLoginButton(),

            ],
          ),
        ),
    ),
  ),
      );
}
