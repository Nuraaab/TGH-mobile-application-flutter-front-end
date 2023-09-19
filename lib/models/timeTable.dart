class TimeTable {
  String? id;
  String? doctorId;
  String? workingDay;
  String? workingTime;
  String? approval;
  String? createdAt;
  String? createdBy;
  String? nameEn;
  String? nameAm;

  TimeTable(
      {this.id,
        this.doctorId,
        this.workingDay,
        this.workingTime,
        this.approval,
        this.createdAt,
        this.createdBy,
        this.nameEn,
        this.nameAm});

  TimeTable.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorId = json['doctor_id'];
    workingDay = json['working_day'];
    workingTime = json['working_time'];
    approval = json['approval'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    nameEn = json['name_en'];
    nameAm = json['name_am'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doctor_id'] = this.doctorId;
    data['working_day'] = this.workingDay;
    data['working_time'] = this.workingTime;
    data['approval'] = this.approval;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['name_en'] = this.nameEn;
    data['name_am'] = this.nameAm;
    return data;
  }
}