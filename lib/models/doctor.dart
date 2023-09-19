class Doctor {
  String? id;
  String? nameEn;
  String? nameAm;
  String? departmentId;
  String? descEn;
  String? descAm;
  String? photo;
  String? createdBy;
  String? createdAt;
  String? approval;
  String? poAm;
  String? poEn;

  Doctor(
      {this.id,
        this.nameEn,
        this.nameAm,
        this.departmentId,
        this.descEn,
        this.descAm,
        this.photo,
        this.createdBy,
        this.createdAt,
        this.approval,
        this.poAm,
        this.poEn});

  Doctor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameEn = json['name_en'];
    nameAm = json['name_am'];
    departmentId = json['department_id'];
    descEn = json['desc_en'];
    descAm = json['desc_am'];
    photo = json['photo'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    approval = json['approval'];
    poAm = json['po_am'];
    poEn = json['po_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_en'] = this.nameEn;
    data['name_am'] = this.nameAm;
    data['department_id'] = this.departmentId;
    data['desc_en'] = this.descEn;
    data['desc_am'] = this.descAm;
    data['photo'] = this.photo;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['approval'] = this.approval;
    data['po_am'] = this.poAm;
    data['po_en'] = this.poEn;
    return data;
  }
}