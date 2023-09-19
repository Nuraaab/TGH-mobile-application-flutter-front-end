class DoctorsCount {
  String? totalDocs;

  DoctorsCount({this.totalDocs});

  DoctorsCount.fromJson(Map<String, dynamic> json) {
    totalDocs = json['total_docs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_docs'] = this.totalDocs;
    return data;
  }
}