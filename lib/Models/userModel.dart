class UserModel {
  String? uid;
  String? email;
  Gender? gender;

  UserModel({this.uid, this.email});

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['userId'];
    email = json['email'];
    gender = json['gender'] !=null ? Gender.values[json['gender']] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = uid;
    data['email'] = email;
    data['gender'] = gender?.index;
    return data;
  }
}
enum Gender{
  male,
  female
}
