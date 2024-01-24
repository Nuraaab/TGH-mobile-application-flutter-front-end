import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing1212/models/apiResponse.dart';
import 'package:testing1212/pages/404.dart';
import 'package:testing1212/pages/BottomNavBar.dart';
import 'package:testing1212/pages/somethingWrong.dart';
import 'package:testing1212/service/services.dart';
import 'package:testing1212/service/user_service.dart';
import 'package:testing1212/widget/navigation_drawer.dart';
import 'dart:convert';
import 'dart:math';
import '../data/my_colors.dart';
import '../models/doctor.dart';
import '../models/timeTable.dart';
import '../widget/my_text.dart';
import 'DoctorDetails.dart';
import 'ExpandableWidgetContainer.dart';
import 'home.dart';
class TimeTablePage extends StatefulWidget {
  TimeTablePage({super.key});
  @override
  State<TimeTablePage> createState() => _TimeTablePageState();
}
class _TimeTablePageState extends State<TimeTablePage> {
  @override
  void initState(){
    super.initState();
    _checkLanguageStatus();
    _getSchedule();
  }
  List<dynamic> _data = [];
  List<dynamic> _dataAm = [];
  List<dynamic> _scheduleList = [];
  bool _isLodding = true;
  bool _isEnglish = false;
  late String selected_doctor = '';
  void _checkLanguageStatus() async{
    final prefs = await SharedPreferences.getInstance();
    final isEnglish = prefs.getBool('isEnglish') ?? true;
    setState(() {
      _isEnglish = isEnglish;
    });
  }
  Future<void> _getSchedule() async {
    ApiResponse scheduleResponse =  await getTimeTable();
    if(scheduleResponse.error == null){
      List<dynamic> scheduleList = scheduleResponse.data as List<dynamic>;
      setState(() {
        _scheduleList = scheduleList.cast<TimeTable>();
        print('schedule list $_scheduleList');
        _isLodding = false;
      });
    }else if(scheduleResponse.error == '404'){
      setState(() {
        _isLodding = false;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Error404(routeWidget: TimeTablePage(),)));
    }else{
      setState(() {
        _isLodding = false;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SomethingWrong(routeWidget: TimeTablePage(),)));
    }
  }
  Future<void> _getDoctorData() async {
    ApiResponse doctorByEnNameResponse = await getDoctorsByEnName(selected_doctor);
    if(doctorByEnNameResponse.error == null){
      List<dynamic> doctorByName = doctorByEnNameResponse.data as List<dynamic>;
      setState(() {
        _data = doctorByName.cast<Doctor>();
      });
    }else if(doctorByEnNameResponse.error == '404'){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Error404(routeWidget: TimeTablePage(),)));
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SomethingWrong(routeWidget: TimeTablePage(),)));
    }
  }
  Future<void> _getDoctorDataAm() async {
    ApiResponse doctorByNameAmResponse =  await getDoctorsByAmName(selected_doctor);
    if(doctorByNameAmResponse.error == null){
      List<dynamic> doctorByName = doctorByNameAmResponse.data as List<dynamic>;
      setState(() {
        _dataAm = doctorByName.cast<Doctor>();
      });
    }else if(doctorByNameAmResponse.error == '404'){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Error404(routeWidget: TimeTablePage(),)));
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SomethingWrong(routeWidget: TimeTablePage(),)));
    }
  }
  @override
  Widget build(BuildContext context) =>(_isLodding) ? WillPopScope(onWillPop: () => Services.onBackPressed(context),
  child: (Scaffold(body: Center(child: Lottie.asset('assets/images/animation_lkghd69s.json'),),))) :
  ((_scheduleList.isEmpty) ? WillPopScope(
    onWillPop: () => Services.onBackPressed(context),
    child: (
        Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_isEnglish ? 'Sorry, there are no Time Table available for now. Please try again later.' : 'ይቅርታ！ ለአሁን ምንም አይነት የዶክተሮች ክፍለ ጊዜ የለም:: እባክዎ ቆይተው ይሞክሩ', textAlign: TextAlign.center, style: MyText.subhead(context)!.copyWith(
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
    ) ),
  ) : 
  WillPopScope(
    onWillPop: () => Services.onBackPressed(context),
    child: Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: Text(_isEnglish ? 'Time Table' : 'የጊዜ ሴሌዳ',
            style: MyText.subhead(context)!.copyWith(
                color: MyColors.grey_3, fontSize: 20, fontWeight: FontWeight.w500)
        ),
        backgroundColor: MyColors.navBarColor,
        foregroundColor: MyColors.grey_3,
        centerTitle: true,
      ),
      floatingActionButton: const CustomFloatingActionButton(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF06aa9c),
                  Color(0xFF1976D2),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                transform: GradientRotation(-68 * pi / 180),
              ),
            ),
            child: DataTableTheme(
              data: DataTableThemeData(
                dataRowHeight: 56.0,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white,
                      width: 10.0,
                    ),
                  ),
                ),
              ),
              child: DataTableTheme(
                data:  DataTableThemeData(
                  headingRowColor: MaterialStateProperty.all(MyColors.secondary),
                  dataRowColor: MaterialStateProperty.all(Colors.white),
                  dividerThickness: 3,
                ),
                child: DataTable(
                  columnSpacing: 30,
                  dataRowHeight: 150,
                  border: TableBorder.all(
                    color: Colors.grey[300]!,
                    width: 3.0,
                    style: BorderStyle.solid,
                  ),
                  columns:  [
                    DataColumn(label: Text(_isEnglish ? 'Doctor Name' : 'የዶክተሩ ስም', style: MyText.subhead(context)!.copyWith(
                        color: MyColors.grey_3, fontWeight: FontWeight.w500)), ),
                    DataColumn(label: Text(_isEnglish ? 'Monday' : 'ሰኞ', style: MyText.subhead(context)!.copyWith(
                        color: MyColors.grey_3, fontWeight: FontWeight.w500))),
                    DataColumn(label: Text(_isEnglish ? 'Tuesday' : 'ማክሰኞ', style: MyText.subhead(context)!.copyWith(
                        color: MyColors.grey_3, fontWeight: FontWeight.w500))),
                    DataColumn(label: Text(_isEnglish ? 'Wednesday' : 'ረብዑ', style: MyText.subhead(context)!.copyWith(
                        color: MyColors.grey_3, fontWeight: FontWeight.w500))),
                    DataColumn(label: Text(_isEnglish ? 'Thursday' : 'ሀሙስ', style: MyText.subhead(context)!.copyWith(
                        color: MyColors.grey_3, fontWeight: FontWeight.w500))),
                    DataColumn(label: Text(_isEnglish ? 'Friday' : 'አርብ', style: MyText.subhead(context)!.copyWith(
                        color: MyColors.grey_3, fontWeight: FontWeight.w500))),
                    DataColumn(label: Text(_isEnglish ? 'Saturday' : 'ቅዳሜ', style: MyText.subhead(context)!.copyWith(
                        color: MyColors.grey_3, fontWeight: FontWeight.w500))),
                    DataColumn(label: Text(_isEnglish ? 'Sunday' : 'እሁድ', style: MyText.subhead(context)!.copyWith(
                        color: MyColors.grey_3, fontWeight: FontWeight.w500))),
                  ], rows: _buildRows(),
                  showBottomBorder: true,
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SubBottomNavBarContainer(),
    ),
  ));
  List<DataRow> _buildRows(){
    final rows = <DataRow>[];
    final doctorTimes = <String, Map<String, List<String>>>{};

    for (final item in _scheduleList) {
      final doctorName = _isEnglish ? item.nameEn : item.nameAm;
      final workingDay = item.workingDay;
      final workingTime = item.workingTime;
      if (!doctorTimes.containsKey(doctorName)) {
        doctorTimes[doctorName] = {
          'Monday': [],
          'Tuesday': [],
          'Wednesday': [],
          'Thursday': [],
          'Friday': [],
          'Saturday': [],
          'Sunday': []
        };
      }
      doctorTimes[doctorName]?[workingDay]?.add(workingTime);
    }

    for (final doctorName in doctorTimes.keys) {
      final cells = <DataCell>[];
      cells.add(DataCell(Text(doctorName.toString(), style: MyText.body1(context)!.copyWith(
          color: MyColors.grey_80, fontSize: 18, fontWeight: FontWeight.w500))));
      for (final day in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']) {
        final workingTimes = doctorTimes[doctorName]?[day];
        final workingTimesText = workingTimes != null
            ? workingTimes.map((time) => time.split('\n')).expand((x) => x).toList()
            : [];
        cells.add(DataCell(SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: workingTimesText
                .map((time){
              return GestureDetector(
                onTap: () async {
                  setState(() {
                    selected_doctor = doctorName.toString();
                  });
                   _isEnglish ? await _getDoctorData() : await _getDoctorDataAm();
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool('timetable', true);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => DoctorsDetails(
                      list: _isEnglish ? _data : _dataAm,
                      index: 0,
                      day: day,
                      date: time,
                    ),
                  ));
                },
                child: Column(
                  children: [
                    Divider(color: Colors.blueGrey,),
                    SizedBox(height: 5,),
                    Text(
                      time,
                      style: MyText.body1(context)!.copyWith(
                        color: MyColors.grey_80,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  ],
                ),
              );
            })
                .toList(),
          ),
        )));
      }
      rows.add(DataRow(
          cells: cells));
    }
    return rows;
  }

}
