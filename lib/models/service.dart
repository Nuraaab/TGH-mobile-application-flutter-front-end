class Service {
  String? id;
  String? titleEn;
  String? titleAm;
  String? subTitleEn;
  String? subTitleAm;
  String? descriptionEn;
  String? descriptionAm;
  String? image;
  String? approval;
  String? createdBy;
  String? createdAt;

  Service(
      {this.id,
        this.titleEn,
        this.titleAm,
        this.subTitleEn,
        this.subTitleAm,
        this.descriptionEn,
        this.descriptionAm,
        this.image,
        this.approval,
        this.createdBy,
        this.createdAt});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titleEn = json['title_en'];
    titleAm = json['title_am'];
    subTitleEn = json['sub_title_en'];
    subTitleAm = json['sub_title_am'];
    descriptionEn = json['description_en'];
    descriptionAm = json['description_am'];
    image = json['image'];
    approval = json['approval'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title_en'] = this.titleEn;
    data['title_am'] = this.titleAm;
    data['sub_title_en'] = this.subTitleEn;
    data['sub_title_am'] = this.subTitleAm;
    data['description_en'] = this.descriptionEn;
    data['description_am'] = this.descriptionAm;
    data['image'] = this.image;
    data['approval'] = this.approval;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    return data;
  }
}