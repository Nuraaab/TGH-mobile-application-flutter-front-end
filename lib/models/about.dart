class About {
  String? id;
  String? motoEn;
  String? motoAm;
  String? subTitleEn;
  String? subTitleAm;
  String? descriptionEn;
  String? descriptionAm;
  String? logo;
  String? createdBy;
  String? createdAt;
  String? approval;

  About(
      {this.id,
        this.motoEn,
        this.motoAm,
        this.subTitleEn,
        this.subTitleAm,
        this.descriptionEn,
        this.descriptionAm,
        this.logo,
        this.createdBy,
        this.createdAt,
        this.approval});

  About.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    motoEn = json['moto_en'];
    motoAm = json['moto_am'];
    subTitleEn = json['sub_title_en'];
    subTitleAm = json['sub_title_am'];
    descriptionEn = json['description_en'];
    descriptionAm = json['description_am'];
    logo = json['logo'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    approval = json['approval'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['moto_en'] = this.motoEn;
    data['moto_am'] = this.motoAm;
    data['sub_title_en'] = this.subTitleEn;
    data['sub_title_am'] = this.subTitleAm;
    data['description_en'] = this.descriptionEn;
    data['description_am'] = this.descriptionAm;
    data['logo'] = this.logo;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['approval'] = this.approval;
    return data;
  }
}