import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wowfit/Models/userAddedExcercise.dart';

class WorkOutModel {
  String? wId;
  String? workOutTitleName;
  String? startTime;
  String? duration;
  String? endTime;
  String? color;
  String? wDate;
  String? img;
  String? notify;
  List<UserList>? addedExercise;

  WorkOutModel({
    this.wId,
    this.workOutTitleName,
    this.startTime,
    this.duration,
    this.endTime,
    this.color,
    this.wDate,
    this.img,
    this.notify,
    this.addedExercise,
    //this.dairy
  });

  WorkOutModel.fromJson(Map<String, dynamic> json) {
    wId = json['wId'];
    workOutTitleName = json['workOutTitleName'];
    startTime = json['startTime'];

    duration = json['duration'];
    endTime = json['endTime'];
    color = json['color'];
    wDate = json['wDate'];
    img = json['img'];
    notify = json['notify'];
    addedExercise = json['addedExercise'] != null
        ? List.from(json['addedExercise'])
            .map((element) => UserList.fromJson(element))
            .toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wId'] = wId;
    data['workOutTitleName'] = workOutTitleName;
    data['startTime'] = startTime;
    data['duration'] = duration;
    data['endTime'] = endTime;
    data['color'] = color;
    data['wDate'] = wDate;
    data['img'] = img;
    data['notify'] = notify;
    data['addedExercise'] =
        addedExercise?.map((element) => element.toJson()).toList();
    // data['dairy'] = dairy?.map((element) => element.toJson()).toList();
    return data;
  }
}

class WorkOutData {
  String? workDate;
  String? createdAt;
  String? color;
  List<WorkOutModel>? workOut;

  WorkOutData({this.workOut, this.workDate});
  WorkOutData.fromJson(Map<String, dynamic> json) {
    workDate = json['workDate'];
    color = json['color'];
    createdAt = json['createdAt'].toString();
    workOut = json['workOut'] != null
        ? List.from(json['workOut'])
            .map((element) => WorkOutModel.fromJson(element))
            .toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['workOut'] = workOut?.map((element) => element.toJson()).toList();
    data['workDate'] = workDate;
    data['color'] = color;
    data['createdAt'] = FieldValue.serverTimestamp();
    return data;
  }
}
