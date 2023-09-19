class DepartmentCount {
  String? totalDept;

  DepartmentCount({this.totalDept});

  DepartmentCount.fromJson(Map<String, dynamic> json) {
    totalDept = json['total_dept'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_dept'] = this.totalDept;
    return data;
  }
}