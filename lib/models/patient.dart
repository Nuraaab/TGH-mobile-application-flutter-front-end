class Patient {
  String? id;
  String? mrn;
  String? nationalId;
  String? fname;
  String? mname;
  String? lname;
  String? motherName;
  String? sex;
  String? age;
  String? birthdate;
  String? mobile;
  String? mobile1;
  String? region;
  String? subcity;
  String? houseNo;
  String? officeTel;
  String? organization;
  String? city;
  String? wereda;
  String? email;
  String? cardStatus;
  String? createdAt;
  String? createdBy;
  String? updateBy;

  Patient(
      {this.id,
        this.mrn,
        this.nationalId,
        this.fname,
        this.mname,
        this.lname,
        this.motherName,
        this.sex,
        this.age,
        this.birthdate,
        this.mobile,
        this.mobile1,
        this.region,
        this.subcity,
        this.houseNo,
        this.officeTel,
        this.organization,
        this.city,
        this.wereda,
        this.email,
        this.cardStatus,
        this.createdAt,
        this.createdBy,
        this.updateBy});

  Patient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mrn = json['mrn'];
    nationalId = json['national_id'];
    fname = json['fname'];
    mname = json['mname'];
    lname = json['lname'];
    motherName = json['mother_name'];
    sex = json['sex'];
    age = json['age'];
    birthdate = json['birthdate'];
    mobile = json['mobile'];
    mobile1 = json['mobile1'];
    region = json['region'];
    subcity = json['subcity'];
    houseNo = json['house_no'];
    officeTel = json['office_tel'];
    organization = json['organization'];
    city = json['city'];
    wereda = json['wereda'];
    email = json['email'];
    cardStatus = json['card_status'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updateBy = json['update_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mrn'] = this.mrn;
    data['national_id'] = this.nationalId;
    data['fname'] = this.fname;
    data['mname'] = this.mname;
    data['lname'] = this.lname;
    data['mother_name'] = this.motherName;
    data['sex'] = this.sex;
    data['age'] = this.age;
    data['birthdate'] = this.birthdate;
    data['mobile'] = this.mobile;
    data['mobile1'] = this.mobile1;
    data['region'] = this.region;
    data['subcity'] = this.subcity;
    data['house_no'] = this.houseNo;
    data['office_tel'] = this.officeTel;
    data['organization'] = this.organization;
    data['city'] = this.city;
    data['wereda'] = this.wereda;
    data['email'] = this.email;
    data['card_status'] = this.cardStatus;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['update_by'] = this.updateBy;
    return data;
  }
}