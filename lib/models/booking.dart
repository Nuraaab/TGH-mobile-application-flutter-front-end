class Booking {
  String? id;
  String? patientId;
  String? doctorId;
  String? selectedDay;
  String? selectedTime;
  String? selectedDate;
  String? orderId;
  String? bankName;
  String? account;
  String? trsId;
  String? amount;
  String? status;
  String? createdBy;
  String? createdAt;
  String? nameEn;
  String? nameAm;

  Booking(
      {this.id,
        this.patientId,
        this.doctorId,
        this.selectedDay,
        this.selectedTime,
        this.selectedDate,
        this.orderId,
        this.bankName,
        this.account,
        this.trsId,
        this.amount,
        this.status,
        this.createdBy,
        this.createdAt,
        this.nameEn,
        this.nameAm});

  Booking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    doctorId = json['doctor_id'];
    selectedDay = json['selected_day'];
    selectedTime = json['selected_time'];
    selectedDate = json['selected_date'];
    orderId = json['order_id'];
    bankName = json['bank_name'];
    account = json['account'];
    trsId = json['trs_id'];
    amount = json['amount'];
    status = json['status'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    nameEn = json['name_en'];
    nameAm = json['name_am'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['doctor_id'] = this.doctorId;
    data['selected_day'] = this.selectedDay;
    data['selected_time'] = this.selectedTime;
    data['selected_date'] = this.selectedDate;
    data['order_id'] = this.orderId;
    data['bank_name'] = this.bankName;
    data['account'] = this.account;
    data['trs_id'] = this.trsId;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['name_en'] = this.nameEn;
    data['name_am'] = this.nameAm;
    return data;
  }
}