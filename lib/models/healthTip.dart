class HealthTip {
  String? id;
  String? category;
  String? titleEn;
  String? titleAm;
  String? subTitleEn;
  String? subTitleAm;
  String? descriptionEn;
  String? descriptionAm;
  String? image;
  String? pdfFile;
  String? createdBy;
  String? createdAt;
  Null? updatedAt;
  String? approval;

  HealthTip(
      {this.id,
        this.category,
        this.titleEn,
        this.titleAm,
        this.subTitleEn,
        this.subTitleAm,
        this.descriptionEn,
        this.descriptionAm,
        this.image,
        this.pdfFile,
        this.createdBy,
        this.createdAt,
        this.updatedAt,
        this.approval});

  HealthTip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    titleEn = json['title_en'];
    titleAm = json['title_am'];
    subTitleEn = json['sub_title_en'];
    subTitleAm = json['sub_title_am'];
    descriptionEn = json['description_en'];
    descriptionAm = json['description_am'];
    image = json['image'];
    pdfFile = json['pdf_file'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    approval = json['approval'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['title_en'] = this.titleEn;
    data['title_am'] = this.titleAm;
    data['sub_title_en'] = this.subTitleEn;
    data['sub_title_am'] = this.subTitleAm;
    data['description_en'] = this.descriptionEn;
    data['description_am'] = this.descriptionAm;
    data['image'] = this.image;
    data['pdf_file'] = this.pdfFile;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['approval'] = this.approval;
    return data;
  }
}