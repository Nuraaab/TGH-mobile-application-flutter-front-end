class User {
  String? id;
  String? name;
  String? email;
  String? password;
  String? phone;
  String? avatar;
  String? role;
  Null? createdAt;
  Null? updatedAt;
  String? check;

  User(
      {this.id,
        this.name,
        this.email,
        this.password,
        this.phone,
        this.avatar,
        this.role,
        this.createdAt,
        this.updatedAt,
        this.check});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    avatar = json['avatar'];
    role = json['Role'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    check = json['check'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['phone'] = this.phone;
    data['avatar'] = this.avatar;
    data['Role'] = this.role;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['check'] = this.check;
    return data;
  }
}