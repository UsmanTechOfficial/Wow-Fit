import 'package:flutter/material.dart';
import 'package:wowfit/Models/userHistoryModel.dart';

class UserList {
  String? id;
  String? image;
  String? title;
  String? subcategoriesId;
  bool isDownData = false;
  bool isAddData = false;
  bool isFilledBlue = false;
  bool isSelectSuperSet = false;
  bool isItemSelect = false;
  int? selectedIndex;
  int? selectedIndexLength;
  int? index;
  List<Widget> items = [];
  List<UserHistoryModel>? dairy;
  TextEditingController? weight2Controller;
  TextEditingController? weight1Controller;
  TextEditingController? rap1Controller;
  TextEditingController? rap2Controller;
/*  Dairy? dairy;*/

  UserList(
    this.image,
    this.title,
    this.isDownData,
    this.isAddData,
    this.isItemSelect,
    this.isFilledBlue,
    this.isSelectSuperSet,
    this.index, {
    this.selectedIndex,
    this.id,
    required this.items,
    this.subcategoriesId,
    //  this.dairy,
    this.weight1Controller,
    this.weight2Controller,
    this.rap1Controller,
    required this.dairy,
    this.rap2Controller,
  });

  UserList.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    title = json['title'];
    isDownData = json['isDownData'] ?? false;
    isAddData = json['isAddData'] ?? false;
    isFilledBlue = json['isFilledBlue'] ?? false;
    isSelectSuperSet = json['isSelectSuperSet'] ?? false;
    isItemSelect = json['isItemSelect'] ?? false;
    selectedIndex = json['selectedIndex'];
    index = json['index'];
    id = json['id'];
    dairy = [];
    dairy = json['dairy'] != null
        ? List.from(json['dairy'])
            .map((element) => UserHistoryModel.fromJson(element))
            .toList()
        : [];
    subcategoriesId = json['subcategoriesId'];
    //  dairy = Dairy.fromJson(json['dairy']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['title'] = title;
    data['isDownData'] = isDownData;
    data['isFilledBlue'] = isFilledBlue;
    data['isSelectSuperSet'] = isSelectSuperSet;
    data['isItemSelect'] = isItemSelect;
    data['selectedIndex'] = selectedIndex;
    data['index'] = index;
    data['id'] = id;
    data['dairy'] = dairy?.map((element) => element.toJson()).toList();
    data['subcategoriesId'] = subcategoriesId;
    //  data['dairy'] = dairy!.toJson();
    return data;
  }
}
