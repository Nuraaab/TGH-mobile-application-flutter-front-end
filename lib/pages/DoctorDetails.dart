import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing1212/data/my_colors.dart';
import 'package:testing1212/models/apiResponse.dart';
import 'package:testing1212/pages/404.dart';
import 'package:testing1212/pages/ExpandableWidgetContainer.dart';
import 'package:testing1212/pages/department.dart';
import 'package:testing1212/pages/doctors.dart';
import 'package:testing1212/pages/home.dart';
import 'package:testing1212/pages/share.dart';
import 'package:testing1212/pages/BottomNavBar.dart';
import 'package:testing1212/pages/somethingWrong.dart';
import 'package:testing1212/pages/webViewWidget.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:http/http.dart' as http;
import 'package:testing1212/widget/snackbar.dart';
import '../models/schedule.dart';
import '../service/user_service.dart';
import '../widget/my_text.dart';
import 'Payment.dart';
import 'package:intl/intl.dart';



class DoctorsDetails extends StatefulWidget {
  String? day;
  String? date;
  List list; //for doctors list
  int index; //for doctor index
  DoctorsDetails({super.key, required this.list, required this.index, this.day, this.date});// assign the variables to the constructor
  @override
  State<DoctorsDetails> createState() => _DoctorsDetailsState();
}
class _DoctorsDetailsState extends State<DoctorsDetails> {
  late String name = '';
  late String day = '';
  late String date = '';
  bool _timeTable = false;
  @override
  void initState(){
    super.initState();
    _getUserData();
    getData();
    _checkData();
    _checkTimeTable();
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
  void _checkData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isTime = prefs.getBool('timetable');
    if(isTime == true){
      setState(() {
        name = widget.list[0].nameEn;
        day = widget.day!;
        date = widget.date!;
      });
    }
  }
  List<dynamic> _data = [];// for schedule list
  String _email = '';// for email
  Future<void> getData() async {
    ApiResponse scheduleResponse = await getSchedule(_selectedDay, widget.list[widget.index].id);
    if(scheduleResponse.error == null){
      List<dynamic> schedule = scheduleResponse.data as List<dynamic>;
      setState(() {
        _data = schedule.cast<Schedule>();
      });
    }else if(scheduleResponse.error == '404'){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>Error404(routeWidget: DoctorsDetails(list: widget.list, index: widget.index,),)));
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>SomethingWrong(routeWidget: DoctorsDetails(list: widget.list, index: widget.index,),)));
    }
  }
  Future<void> _getUserData() async{
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? ''; //get email from session
    setState(() {
      _email= email; // set the email to local variable
    });
  }
  // methods used for navigating to doctors page
void _navigateToDoctorsPage(BuildContext context) async{
  String weekday = DateFormat('EEEE').format(_selectedDate); // get the date format of the selected date
    if(_timeTable){
     setState(() {
       _selectedDay =widget.day!;
       updatedWorkingTime = [widget.date!.toString()];
     });
    }
  if(_selectedDay!= weekday || updatedWorkingTime.isEmpty ){ //check if the selected date is the same as the selected day
      snackBar.show(
          context, _isEnglish ? "Oops! Looks like you left a field empty or selected an invalid schedule/date format. Please correct it and try again." : 'ውይ! ባዶ ቦታ ያስቀሩ ወይም ልክ ያልሆነ የጊዜ ሰሌዳ/ቀን የመረጡ ይመስላል። እባክዎ አስተካክለው እንደገና ይሞክሩ።', Colors.red,);
    }else if(_selectedDate.isBefore(currentDate)){
      snackBar.show(
          context, _isEnglish ? "Oops! Looks like you selected past date. Please correct it and try again." : 'ውይ! ያለፈውን ቀን የመረጡት ይመስላል። እባክዎ አስተካክለው እና እንደገና ይሞክሩ።', Colors.red);
    }else{
      if(_email.isEmpty){ // if no email in the session navigate to login page
        Navigator.pushNamed(context, '/appointment');
      }else{
        // if there is email in the session navigate to payment method with the required information
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>
            Payment(
              doctorId: widget.list[widget.index].id,
              email: _email,
              day: _timeTable ? widget.day! :_selectedDay,
              date: '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
              schedule:_timeTable ? widget.date! : updatedWorkingTime[_selectedIndex],),));
      }
    }


  }
  DateTime currentDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate)
    {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  Future<void> _checkTimeTable() async{
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    bool timeTable = prefs.getBool('timetable') ?? false;
    setState(() {
      _timeTable= timeTable;
    });
  }
  late int _selectedIndex=0;
   String _selectedDay = 'Monday' ;
  Map<String, String> amharicToEnglishDayNames = {
    'Monday' :  'ሰኞ',
    'Tuesday' :'ማክሰኞ',
    'Wednesday' : 'ረብዑ',
    'Thursday':'ሀሙስ' ,
    'Friday' : 'አርብ',
    'Saturday' : 'ቅዳሜ',
    'Sunday' : 'እሁድ',
  };

  late final List<String> englishDayNames = amharicToEnglishDayNames.values.toList();

  List<String>updatedWorkingTime=[];
  @override
  Widget build(BuildContext context) {
    final String description='${widget.list[widget.index].descEn}';// assign the doctors description to description variable
    final String encodedDescription = jsonEncode(description);// encode the fetched value since it has html tag
    final String noQuotesDescription = encodedDescription.replaceAll('"', '');// replaced the double quote with space character
    final String breakReplaced = noQuotesDescription.replaceAll(RegExp(r'<br>|<\/br>'), '');// replace the breaks with space character
    final String descriptionAm='${widget.list[widget.index].descAm}';// assign the doctors description to description variable
    final String encodedDescriptionAm = jsonEncode(descriptionAm);// encode the fetched value since it has html tag
    final String noQuotesDescriptionAm = encodedDescriptionAm.replaceAll('"', '');// replaced the double quote with space character
    final String breakReplacedAm = noQuotesDescriptionAm.replaceAll(RegExp(r'<br>|<\/br>'), '');
    return Scaffold(
      floatingActionButton: const CustomFloatingActionButton(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child:  SizedBox(
                width: double.maxFinite,
                height: 350,
                child: CachedNetworkImage(
                  key: UniqueKey(),
                  imageUrl:
                  'http://www.teklehaimanothospital.com/admin/${widget.list[widget.index].photo}',
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/place_holder.png',
                    height: 250,
                    width:double.maxFinite,
                    fit: BoxFit.cover,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 2, right: 2),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 2, right: 2),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_isEnglish ? "${widget.list[widget.index].nameEn}" : "${widget.list[widget.index].nameAm}",// display doctors name
                                textAlign: TextAlign.center,
                                style: MyText.subhead(context)!.copyWith(
                                    color: MyColors.grey_80,  fontWeight: FontWeight.w500),
                              ),

                            ],
                          ),
                          const SizedBox(height: 10),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_isEnglish ? '${widget.list[widget.index].poEn}' : '${widget.list[widget.index].poAm}',
                                textAlign: TextAlign.center,
                                style: MyText.body1(context)!.copyWith(
                                    color: MyColors.grey_80,  fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                         _isEnglish ? DoctorsEn(docsEn: breakReplaced,) : DoctorsAm(docsAm: breakReplacedAm),
                          const SizedBox(height: 10,),
                          Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: MyColors.grey_3,
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: MyColors.grey_3,
                                elevation: 5,
                                child: ExpansionTile(
                                  leading: const Icon(Icons.calendar_month, color: MyColors.grey_60,),
                                  title: Text(_isEnglish ? 'Schedule' : 'መርሀግብር',
                                    style: MyText.subhead(context)!.copyWith(
                                        color: MyColors.grey_60,  fontWeight: FontWeight.w500),
                                  ),
                                  iconColor: MyColors.grey_60,
                                  trailing: const Icon(Icons.expand_more, color: MyColors.grey_60, size: 28,),
                                  initiallyExpanded: _timeTable ? false: true,
                                  children: [

                                    Padding(padding: const EdgeInsets.symmetric(horizontal: 2),
                                      child: SizedBox(
                                        height: 300,
                                        child: ListView.builder(
                                          itemCount: 1,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              color: MyColors.grey_3,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 15.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text(_timeTable ? (_isEnglish ? 'Selected schedule day:' : 'የተመረጠው ቀን') : (_isEnglish ? 'Select schedule day': 'የቀጠሮ ቀን ይምረጡ'),
                                                          style: MyText.body1(context)!.copyWith(
                                                              color: MyColors.grey_60, fontWeight: FontWeight.w500),

                                                        ),
                                                        SizedBox(width: 20,),
                                                        _timeTable ? (_isEnglish ? Text(widget.day!, style: MyText.body1(context)!.copyWith(
                                                            color: MyColors.grey_60, fontWeight: FontWeight.w500)): (() {
                                                          switch (widget.day) {
                                                            case 'Monday':
                                                              return  Text('ሰኞ',  style: MyText.body1(context)!.copyWith(
                                                                  color: MyColors.grey_60, fontWeight: FontWeight.w500));
                                                            case 'Tuesday':
                                                              return  Text('ማክሰኞ',  style: MyText.body1(context)!.copyWith(
                                                                  color: MyColors.grey_60, fontWeight: FontWeight.w500));
                                                            case 'Wednesday':
                                                              return  Text('ረቡዕ',  style: MyText.body1(context)!.copyWith(
                                                                  color: MyColors.grey_60, fontWeight: FontWeight.w500));
                                                            case 'Thursday':
                                                              return  Text('ሐሙስ',  style: MyText.body1(context)!.copyWith(
                                                                  color: MyColors.grey_60, fontWeight: FontWeight.w500));
                                                            case 'Friday':
                                                              return  Text('ዓርብ', style: MyText.body1(context)!.copyWith(
                                                                  color: MyColors.grey_60, fontWeight: FontWeight.w500));
                                                            case 'Saturday':
                                                              return  Text('ቅዳሜ', style: MyText.body1(context)!.copyWith(
                                                                  color: MyColors.grey_60, fontWeight: FontWeight.w500));
                                                            case 'Sunday':
                                                              return  Text('እሑድ',  style: MyText.body1(context)!.copyWith(
                                                                  color: MyColors.grey_60, fontWeight: FontWeight.w500));
                                                            default:
                                                              return  Text('...',  style: MyText.body1(context)!.copyWith(
                                                                  color: MyColors.grey_60, fontWeight: FontWeight.w500));
                                                          }
                                                        })()) : Text('') ,
                                                      ],
                                                    ),
                                                   _timeTable ? Text('') :
                                                DropdownButton<String>(
                                                icon: Icon(Icons.arrow_drop_down, color: MyColors.grey_60),
                                            iconSize: 24,
                                            elevation: 16,
                                            underline: Container(
                                            height: 2,
                                            color: MyColors.grey_60,
                                            ),
                                            isExpanded: true,
                                            value: amharicToEnglishDayNames[_selectedDay] ?? englishDayNames[0],
                                            onChanged: (String? value) {
                                            setState(() {
                                            _selectedDay = amharicToEnglishDayNames.entries
                                                .firstWhere((entry) => entry.value == value, orElse: () => MapEntry('', ''))
                                                .key;
                                            final List<String> workingTime = _data
                                                .where((item) => item.workingDay == _selectedDay)
                                                .map<String>((item) => item.workingTime as String)
                                                .toSet()
                                                .toList();
                                            updatedWorkingTime = workingTime;
                                            });
                                            },
                                            items: _isEnglish
                                            ? amharicToEnglishDayNames.keys.map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: amharicToEnglishDayNames[value],
                                                child: Text(
                                                  value,
                                                  style: MyText.body1(context)!
                                                      .copyWith(color: MyColors.grey_60, fontWeight: FontWeight.w500),
                                                ),
                                              );
                                            }).toList()
                                                : englishDayNames.map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: MyText.body1(context)!
                                                      .copyWith(color: MyColors.grey_60, fontWeight: FontWeight.w500),
                                                ),
                                              );
                                            }).toList(),
                                            ),
                                                    Container(
                                                      margin: EdgeInsets.only(top: 10),
                                                      width: double.maxFinite,
                                                      height: 100,
                                                      child: ListView.builder(
                                                        itemCount: _timeTable ? 1 : updatedWorkingTime.length,
                                                        itemBuilder: (BuildContext context, int index) {
                                                          return  RadioListTile(
                                                            title: Text(_timeTable ? '${widget.date}' : updatedWorkingTime[index],
                                                              style: MyText.body1(context)!.copyWith(
                                                                  color: MyColors.grey_60, fontWeight: FontWeight.w500),
                                                            ),
                                                            value:_timeTable ? 0 : index,
                                                            groupValue: _selectedIndex,
                                                            onChanged: (int? value) {
                                                              setState(() {
                                                                _selectedIndex = value!;
                                                              });
                                                            },
                                                            activeColor: MyColors.grey_60,
                                                          );
                                                        },
                                                      ),

                                                    ),
                                                    ListTile(

                                                      title: Text(_isEnglish ? 'Please select a valid date' : 'እባክዎ ትክክለኛውን ቀን ይምረጡ',
                                                        style: MyText.body1(context)!.copyWith(
                                                            color: MyColors.grey_60,fontWeight: FontWeight.w500),
                                                      ),
                                                      subtitle: Text('${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                                                        style: MyText.body1(context)!.copyWith(
                                                            color: MyColors.grey_60,  fontWeight: FontWeight.w500),
                                                      ),
                                                      trailing: Icon(Icons.keyboard_arrow_down,color: MyColors.grey_60, size: 35,),
                                                      onTap: () => _selectDate(context),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),



                          ),
                          const SizedBox(height: 25,),
                          Container(
                            width: double.maxFinite,
                            height: 55,
                            margin: EdgeInsets.only(left: 4, right: 4),
                            child: ElevatedButton(
                              onPressed: (){
                                _navigateToDoctorsPage(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: MyColors.navBarColor),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.schedule,
                                    color: Colors.white, size: 30.0,),
                                  SizedBox(width: 20,),
                                  Text(_isEnglish ? 'Make Appointment' : 'ቀጠሮ ይያዙ',
                                    style: MyText.subhead(context)!.copyWith(
                                        color: MyColors.grey_3, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 80,),
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
     bottomNavigationBar: SubBottomNavBarContainer(),
    );
  }
}
