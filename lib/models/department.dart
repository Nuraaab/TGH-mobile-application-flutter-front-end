class Department {
  String? id;
  String? titleEn;
  String? titleAm;
  String? subTitleEn;
  String? subTitleAm;
  String? bodyEn;
  String? bodyAm;
  String? icon;
  String? image;
  String? createdBy;
  String? createdAt;
  String? approval;
  String? depList;

  Department(
      {this.id,
        this.titleEn,
        this.titleAm,
        this.subTitleEn,
        this.subTitleAm,
        this.bodyEn,
        this.bodyAm,
        this.icon,
        this.image,
        this.createdBy,
        this.createdAt,
        this.approval,
        this.depList});

  Department.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titleEn = json['title_en'];
    titleAm = json['title_am'];
    subTitleEn = json['sub_title_en'];
    subTitleAm = json['sub_title_am'];
    bodyEn = json['body_en'];
    bodyAm = json['body_am'];
    icon = json['icon'];
    image = json['image'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    approval = json['approval'];
    depList = json['dep_list'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title_en'] = this.titleEn;
    data['title_am'] = this.titleAm;
    data['sub_title_en'] = this.subTitleEn;
    data['sub_title_am'] = this.subTitleAm;
    data['body_en'] = this.bodyEn;
    data['body_am'] = this.bodyAm;
    data['icon'] = this.icon;
    data['image'] = this.image;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['approval'] = this.approval;
    data['dep_list'] = this.depList;
    return data;
  }
}