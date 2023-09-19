class Schedule {
  String? workingTime;
  String? workingDay;

  Schedule({this.workingTime, this.workingDay});

  Schedule.fromJson(Map<String, dynamic> json) {
    workingTime = json['working_time'];
    workingDay = json['working_day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['working_time'] = this.workingTime;
    data['working_day'] = this.workingDay;
    return data;
  }
}