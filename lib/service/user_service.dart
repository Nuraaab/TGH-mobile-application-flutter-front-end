import 'dart:convert';

import 'package:testing1212/constatnts/constant.dart';
import 'package:testing1212/models/booking.dart';
import 'package:testing1212/models/department.dart';
import 'package:testing1212/models/departmentCount.dart';
import 'package:testing1212/models/doctorCount.dart';
import 'package:testing1212/models/event.dart';
import 'package:testing1212/models/healthTip.dart';
import 'package:testing1212/models/patient.dart';
import 'package:testing1212/models/schedule.dart';
import 'package:testing1212/models/service.dart';
import 'package:testing1212/models/team.dart';
import 'package:testing1212/models/timeTable.dart';
import 'package:testing1212/models/user.dart';
import '../models/about.dart';
import '../models/apiResponse.dart';
import 'package:http/http.dart' as http;

import '../models/doctor.dart';
Future<ApiResponse> fetchAboutData() async {
  ApiResponse aboutResponse = ApiResponse();
  try{
    final response = await http.get(Uri.parse(aboutUrl));
    switch(response.statusCode){
      case 200:
        aboutResponse.data = List<About>.from(jsonDecode(response.body).map((x) => About.fromJson(x)));
        break;
      case 404:
        aboutResponse.error = error404;
        break;
      default:
        aboutResponse.error = something;
    }
  }catch(e){
    print('Error :$e');
    aboutResponse.error = something;
  }
  return aboutResponse;
}

Future<ApiResponse> getDepartmentCount() async {
  ApiResponse departmentCountResponse = ApiResponse();
  try{
    final response = await http.get(Uri.parse(departmentCountUrl));
    switch(response.statusCode){
      case 200:
        departmentCountResponse.data = List<DepartmentCount>.from(jsonDecode(response.body).map((x)=>DepartmentCount.fromJson(x)));
        break;
      case 404:
        departmentCountResponse.error = error404;
        break;
      default:
        departmentCountResponse.error = something;
    }
  }catch(e){
    departmentCountResponse.error =something;
  }
  return departmentCountResponse;
}
Future<ApiResponse> getDoctorsCount() async {
  ApiResponse doctorsCountResponse = ApiResponse();
  try{
    final response = await http.get(Uri.parse(doctorCountUrl));
    switch(response.statusCode){
      case 200:
        doctorsCountResponse.data = List<DoctorsCount>.from(jsonDecode(response.body).map((x)=>DoctorsCount.fromJson(x)));
        break;
      case 404:
        doctorsCountResponse.error = error404;
        break;
      default:
        doctorsCountResponse.error = something;
    }
  }catch(e){
    doctorsCountResponse.error =something;
  }
  return doctorsCountResponse;
}

Future<ApiResponse> getTestimonials() async {
  ApiResponse testimonialResponse = ApiResponse();
  try{
    final response = await http.get(Uri.parse(testimonialUrl));
    switch(response.statusCode){
      case 200:
        testimonialResponse.data = json.decode(response.body);
        break;
      case 404:
        testimonialResponse.error = error404;
        break;
      default:
        testimonialResponse.error = something;
    }
  }catch(e){
    testimonialResponse.error = something;
  }
  return testimonialResponse;
}
Future<ApiResponse> getSlider() async {
  ApiResponse sliderResponse = ApiResponse();
  try{
    final response = await http.get(Uri.parse(sliderUrl));
    switch(response.statusCode){
      case 200:
        sliderResponse.data = json.decode(response.body);
        break;
      case 404:
        sliderResponse.error = error404;
        break;
      default:
        sliderResponse.error = something;
        break;
    }
  }catch(e){
    sliderResponse.error = something;
  }
  return sliderResponse;
}

Future<ApiResponse> getDepartment() async {
  ApiResponse departmentResponse = ApiResponse();
  try{
    final response = await http.get(Uri.parse(departmentUrl));
    switch(response.statusCode){
      case 200:
        departmentResponse.data = List<Department>.from(jsonDecode(response.body).map((x) => Department.fromJson(x)));
        break;
      case 404:
        departmentResponse.error = error404;
        break;
      default:
        departmentResponse.error = something;
    }
  }catch(e){
    departmentResponse.error = something;
  }
  return departmentResponse;
}

Future<ApiResponse> getDoctor() async {
  ApiResponse doctorsResponse = ApiResponse();
  try{
    final response = await http.get(Uri.parse(allDoctorsUrl));
    switch(response.statusCode){
      case 200:
        doctorsResponse.data = List<Doctor>.from(jsonDecode(response.body).map((x) => Doctor.fromJson(x)));
        break;
      case 404:
        doctorsResponse.error = error404;
        break;
      default:
        doctorsResponse.error = something;
        break;
    }
  }catch(e){
    doctorsResponse.error = something;
  }
  return doctorsResponse;
}

Future<ApiResponse> getDoctorsByName(String? dept_id) async {
  ApiResponse doctorByNameResponse = ApiResponse();
  try{
    final response = await http.post(Uri.parse(doctorByDepartment),
    body: {
      'department_id':dept_id,
    }
    );
    switch(response.statusCode){
      case 200:
        doctorByNameResponse.data = List<Doctor>.from(jsonDecode(response.body).map((x) =>Doctor.fromJson(x)));
        break;
      case 404:
        doctorByNameResponse.error =error404;
        break;
      default:
        doctorByNameResponse.error = something;
    }
  }catch(e){
    doctorByNameResponse.error = something;
  }
  return doctorByNameResponse;
}

Future<ApiResponse> getSchedule(String? working_day, String? doctor_id) async {
  ApiResponse scheduleResponse =  ApiResponse();
  try{
    final response = await http.post(Uri.parse(scheduleByIdUrl),
    body: {
      'working_day':working_day,
      'doctor_id':doctor_id,
    }
    );
    switch(response.statusCode){
      case 200:
        scheduleResponse.data = List<Schedule>.from(jsonDecode(response.body).map((x) => Schedule.fromJson(x)));
        break;
      case 404:
        scheduleResponse.error = error404;
        break;
      default:
        scheduleResponse.error = something;
    }
  }catch(e){
    scheduleResponse.error = something;
  }
  return scheduleResponse;
}

Future<ApiResponse> getPatients(String? email) async {
  ApiResponse patientResponse = ApiResponse();
  try{
    final response = await http.post(Uri.parse(patientUrl),
    body: {
      'email':email,
    }
    );
    switch(response.statusCode){
      case 200:
        patientResponse.data = List<Patient>.from(jsonDecode(response.body).map((x) =>Patient.fromJson(x)));
        break;
      case 404:
        patientResponse.error = error404;
        break;
      default:
        patientResponse.error = something;
        break;
    }
  }catch(e){
    patientResponse.error = something;
  }
  return patientResponse;
}
Future<ApiResponse> getBooking(String? patient_id) async {
  ApiResponse bookingResponse = ApiResponse();
  try{
    final response = await http.post(Uri.parse(bookingUrl),
    body: {
      'patient_id': patient_id,
    }
    );
    switch(response.statusCode){
      case 200:
        bookingResponse.data = List<Booking>.from(jsonDecode(response.body).map((x) => Booking.fromJson(x)));
        break;
      case 404:
        bookingResponse.error = error404;
        break;
      default:
        bookingResponse.error = something;
        break;
    }
  }catch(e){
    bookingResponse.error = something;
  }
  return bookingResponse;
}

Future<ApiResponse> getEvents() async {
  ApiResponse eventResponse = ApiResponse();
  try{
    final response = await http.get(Uri.parse(eventUrl));
    switch(response.statusCode){
      case 200:
        eventResponse.data = List<Event>.from(jsonDecode(response.body).map((x) => Event.fromJson(x)));
        break;
      case 404:
        eventResponse.error = error404;
        break;
      default:
        eventResponse.error = something;
    }
  }catch(e){
    eventResponse.error = something;
  }
  return eventResponse;
}

Future<ApiResponse> getTips() async {
  ApiResponse tipResponse = ApiResponse();
  try{
    final response  = await http.get(Uri.parse(healthTipUrl));
    switch(response.statusCode){
      case 200:
        tipResponse.data = List<HealthTip>.from(jsonDecode(response.body).map((x) =>HealthTip.fromJson(x)));
        break;
      case 404:
        tipResponse.error = error404;
        break;
      default:
        tipResponse.error = something;
        break;
    }
  }catch(e)
  {
    tipResponse.error = something;
  }
  return tipResponse;
}
Future<ApiResponse> getService() async {
  ApiResponse serviceResponse =  ApiResponse();
  try{
    final response = await http.get(Uri.parse(serviceUrl));
    switch(response.statusCode){
      case 200:
        serviceResponse.data = List<Service>.from(jsonDecode(response.body).map((x) => Service.fromJson(x)));
        break;
      case 404:
        serviceResponse.error = error404;
        break;
      default:
        serviceResponse.error = something;
        break;
    }
  }catch(e){
    serviceResponse.error = something;
  }
  return serviceResponse;
}

Future<ApiResponse> login(String? email, String? password) async {
  ApiResponse loginResponse = ApiResponse();
  try{
    final response = await http.post(Uri.parse(loginUrl),
    body: {
      'email':email,
      'password':password,
    }
    );
    switch(response.statusCode){
      case 200:
        loginResponse.data = json.decode(response.body);
        loginResponse.success = 'You are logged in successfully!';
        break;
      case 404:
        loginResponse.error = error404;
        break;
      default:
        loginResponse.error = something;
        break;
    }
  }catch(e){
    loginResponse.error = something;
  }
  return loginResponse;
}

Future<ApiResponse> payment(var body) async {
  ApiResponse paymentResponse  = ApiResponse();
  try{
    final response = await http.post(Uri.parse(addBookingUrl),
    body: body,
    );
    var data = jsonDecode(response.body);
    switch(data){
      case 'fail':
        paymentResponse.error = something;
        break;
      default:
        paymentResponse.success = 'Your Payment is successfull!';
        break;
    }
  }catch(e){
    paymentResponse.error = something;
  }
  return paymentResponse;
}

Future<ApiResponse> registerPatient(var body) async {
  ApiResponse registerResponse = ApiResponse();
  try{
    final response = await http.post(Uri.parse(registerUrl),
    body: body,
    );
    var data = jsonDecode(response.body);
    print('status : ${data['status']}');
    switch(data['status']){
      case 'registerfail':
        registerResponse.error = 'Phone number or email address already exists';
        break;
      default:
        registerResponse.data = json.decode(response.body);
        registerResponse.success = 'You are registerd successfully!';
        break;
    }
  }catch(e){
    registerResponse.error = something;
  }
  return registerResponse;
}

Future<ApiResponse> getTeams() async{
  ApiResponse teamResponse = ApiResponse();
  try{
    final response =  await http.get(Uri.parse(teamsUrl));
    switch(response.statusCode){
      case 200:
        teamResponse.data = List<Team>.from(jsonDecode(response.body).map((x) => Team.fromJson(x)));
        break;
      case 404:
        teamResponse.error = error404;
        break;
      default:
        teamResponse.error = something;
        break;
    }
  }catch(e){
    teamResponse.error = something;
  }
  return teamResponse;
}

Future<ApiResponse> getUser(String? email) async {
  ApiResponse userResponse = ApiResponse();
  try{
    final response = await http.post(Uri.parse(userProfileUrl),
    body: {
      'email':email,
    }
    );
    switch(response.statusCode){
      case 200:
        userResponse.data = List<User>.from(jsonDecode(response.body).map((x) => User.fromJson(x)));
        break;
      case 404:
        userResponse.error = error404;
        break;
      default:
        userResponse.error = something;
    }
  }catch(e){
    userResponse.error = something;
  }
  return userResponse;
}

Future<ApiResponse> getTimeTable() async {
  ApiResponse timeTableResponse = ApiResponse();
  try{
    final response = await http.get(Uri.parse(timeTableUrl));
    switch(response.statusCode){
      case 200:
        timeTableResponse.data = List<TimeTable>.from(jsonDecode(response.body).map((x) => TimeTable.fromJson(x)));
        break;
      case 404:
        timeTableResponse.error = error404;
        break;
      default:
        timeTableResponse.error = something;
    }
  }catch(e){
    timeTableResponse.error = something;
  }
  return timeTableResponse;
}
Future<ApiResponse> getDoctorsByEnName(String? doctor_name) async {
  ApiResponse doctorByNameResponse = ApiResponse();
  try{
    final response = await http.post(Uri.parse(doctorsByNameUrl),
    body: {
      'doctor_name': doctor_name,
    }
    );
    switch(response.statusCode){
      case 200:
        doctorByNameResponse.data = List<Doctor>.from(jsonDecode(response.body).map((x) => Doctor.fromJson(x)));
        break;
      case 404:
        doctorByNameResponse.error = error404;
        break;
      default:
        doctorByNameResponse.error = something;
    }
  }catch(e){
    doctorByNameResponse.error = something;
  }
  return doctorByNameResponse;
}

Future<ApiResponse> getDoctorsByAmName(String? doctor_name) async {
  ApiResponse scheduleByAmNameResponse = ApiResponse();
  try{
    final response =  await http.post(Uri.parse(doctorsByNameAmUrl),
    body: {
      'doctor_name': doctor_name,
    }
    );
    switch(response.statusCode){
      case 200:
        scheduleByAmNameResponse.data = List<Doctor>.from(jsonDecode(response.body).map((x) => Doctor.fromJson(x)));
        break;
      case 404:
        scheduleByAmNameResponse.error = error404;
        break;
      default:
        scheduleByAmNameResponse.error = something;
    }
  }catch(e){
    scheduleByAmNameResponse.error = something;
  }
  return scheduleByAmNameResponse;
}

Future<ApiResponse> updateProfile(String? avator, String? email) async {
  ApiResponse profileResponse = ApiResponse();
  try{
    final response = await http.post(Uri.parse(updateProfileUrl),
    body: {
      'email': email,
      'avator':avator,
    }
    );
    print('data avatar= ${avator} and email = ${email}');
    var data = jsonDecode(response.body);
    print('other status :${data['status']}');

    switch(data){
      case 'fail':
        profileResponse.error = something;
        break;
      default:
        profileResponse.success = 'Profile updated Successfully!!!';
        break;
    }
  }catch(e){
    profileResponse.error = something;
  }
  return profileResponse;
}

Future<ApiResponse> uploadImage(var data) async {
  ApiResponse uploadImageResponse = ApiResponse();
  try{
    final response = await http.post(Uri.parse(uploadImageUrl),
    body: jsonEncode(data),
    );
    final message = jsonDecode(response.body);
    print('message status :${message['status']}');
    switch(message['status']){
      case 1:
        uploadImageResponse.message = "1";
        break;
      default:
        uploadImageResponse.message = "0";
        uploadImageResponse.error = something;
        break;
    }
  }catch(e){
    uploadImageResponse.error = something;
  }
  return uploadImageResponse;
}