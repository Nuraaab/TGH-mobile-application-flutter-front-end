class Team {
  String? id;
  String? nameEn;
  String? nameAm;
  String? position;
  String? descEn;
  String? descAm;
  String? photo;
  String? createdBy;
  String? createdAt;
  String? approval;

  Team(
      {this.id,
        this.nameEn,
        this.nameAm,
        this.position,
        this.descEn,
        this.descAm,
        this.photo,
        this.createdBy,
        this.createdAt,
        this.approval});

  Team.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameEn = json['name_en'];
    nameAm = json['name_am'];
    position = json['position'];
    descEn = json['desc_en'];
    descAm = json['desc_am'];
    photo = json['photo'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    approval = json['approval'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_en'] = this.nameEn;
    data['name_am'] = this.nameAm;
    data['position'] = this.position;
    data['desc_en'] = this.descEn;
    data['desc_am'] = this.descAm;
    data['photo'] = this.photo;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['approval'] = this.approval;
    return data;
  }
}