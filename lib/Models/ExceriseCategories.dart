import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseCategories {
  String? id;
  String? img;
  String? categoryName;
  bool? selectedBtn;
  //List<SubCategories>? subCategories;

  ExerciseCategories({this.id, this.categoryName, this.img, this.selectedBtn});

  ExerciseCategories.fromJson(DocumentSnapshot json) {
    id = json['id'];
    img = json['img'];
    categoryName = json['categoryName'];
    selectedBtn = json['selectedBtn'];
    /*subCategories = json['subCategories'] != null
        ? List.from(json['subCategories'])
            .map((element) => SubCategories.fromJson(element))
            .toList()
        : [];*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['img'] = img;
    data['categoryName'] = categoryName;
    data['selectedBtn'] = selectedBtn;
    return data;
  }
}

class BuiltinCategories {
  String? id;
  List<SubCategories>? subCategories;
  BuiltinCategories({
    this.id,
    this.subCategories,
  });

  BuiltinCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subCategories = json['subCategories'] != null
        ? List.from(json['subCategories'])
            .map((element) => SubCategories.fromJson(element))
            .toList()
        : [];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['subCategories'] =
        subCategories?.map((element) => element.toJson()).toList();
    return data;
  }
}

class SubCategories {
  String? id;
  String? userid;
  String? img;
  String? subCategoryName;
  bool? rBtn;
  String? date;

  SubCategories(
      {this.id,
      this.userid,
      this.img,
      this.subCategoryName,
      this.rBtn,
      this.date});

  SubCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    img = json['img'];
    subCategoryName = json['subCategoryName'];
    rBtn = json['rBtn'];
    date = json['date'];
    userid = json['userid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['img'] = img;
    data['subCategoryName'] = subCategoryName;
    data['rBtn'] = rBtn;
    data['date'] = date;
    data['userid'] = userid;
    return data;
  }
}
