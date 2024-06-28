import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:wowfit/Models/WorkOutModel.dart';
import 'package:wowfit/Models/userHistoryModel.dart';

import '../BottomSheet/editBottomSheet.dart';
import '../Utils/notificationService.dart';
import '../Utils/showtoaist.dart';
import '../WorkoutScreen/newWorkOutScreen.dart';

class NewWorkOutController extends GetxController {
  WorkOutModel workout = WorkOutModel();
  WorkOutData workOutData = WorkOutData();
  HistoryData history = HistoryData('', [], '');

  //ValueNotifier<List<DateModel>> events = ValueNotifier(<DateModel>[]);
  List<DateModel> events = <DateModel>[].obs;
  CollectionReference user = FirebaseFirestore.instance.collection('Users');
  Future<bool> uploadData(String workoutTitleName, var context,
      bool detailAdded, bool openFromShare, String notify) async {
    bool flag = false;
    int index = 0;
    if (workoutTitleName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter workout title'.tr)));
      return false;
    } else if (!detailAdded) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please complete workout detail from edit button'.tr)));
      return false;
    } else {
      workout.workOutTitleName = workoutTitleName;
      workout.addedExercise = [];
      if (userList.isNotEmpty) {
        for (var items in userList) {
          workout.addedExercise!.add(items);
        }
      }
      CollectionReference collectionRef =
          user.doc(GetStorage().read('user').toString()).collection('Workouts');
      /*var date = DateTime.parse(DateTime.now().toString());
    var formattedDate = "${date.day}-${date.month}-${date.year}";*/
      final date = DateTime.now();
      String dateFormated =
          DateFormat("yyyy-MM-dd").format(DateTime.parse(workout.wDate!));
      var doc = await collectionRef.doc(dateFormated.toString()).get();
      if (doc.exists) {
        WorkOutData temp = WorkOutData();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        var obj = WorkOutData.fromJson(data);
        temp.workDate = obj.workDate;
        temp.workOut = [];
        for (var item in obj.workOut!) {
          temp.workOut!.add(item);
          index++;
        }
        temp.workOut!.add(workout);
        index++;
        await user
            .doc(GetStorage().read('user').toString())
            .collection('Workouts')
            .doc(dateFormated.toString())
            .set(temp.toJson(), SetOptions(merge: true))
            .timeout(const Duration(seconds: 5))
            .catchError((e) {
          flag = false;
          showToast(e.message.toString());
        }).whenComplete(() {
          if (int.parse(notify) != 0) {
            NotificationService().setNotification(
                workout.startTime.toString(),
                index,
                workout.workOutTitleName.toString(),
                int.parse(notify),
                DateTime.parse(workout.wDate!));
          }

          userList.clear();
          workOutData = WorkOutData();
          workout = WorkOutModel();
          flag = true;
          /*  if (openFromShare)  Navigator.pop(context);*/
        });
        return flag;
      } else {
        if (kDebugMode) {
          print(GetStorage().read('user').toString());
        }
        if (kDebugMode) {
          print(dateFormated);
        }
        workOutData.workOut = [];
        workOutData.workDate = dateFormated;
        workOutData.workOut!.add(workout);
        await user
            .doc(GetStorage().read('user').toString())
            .collection('Workouts')
            .doc(dateFormated.toString())
            .set(workOutData.toJson())
            .timeout(const Duration(seconds: 5))
            .catchError((e) {
          if (kDebugMode) {
            print(e);
          }
          showToast(e.message.toString());

          flag = false;
        }).whenComplete(() {
          if (int.parse(notify) != 0) {
            NotificationService().setNotification(
                workout.startTime.toString(),
                index,
                workout.workOutTitleName.toString(),
                int.parse(notify),
                DateTime.parse(workout.wDate!));
          }

          workOutData = WorkOutData();
          workout = WorkOutModel();
          userList.clear();
          flag = true;
        });
        return flag;
      }
    }
  }

  Future<void> uploadHistoryData(
      String id, HistoryData historyData, Dairy dairy) async {
    CollectionReference collectionRef =
        user.doc(GetStorage().read('user').toString()).collection('History');
    var doc = await collectionRef.doc(id).get();
    if (doc.exists) {
      HistoryData temp = HistoryData('', [], '');
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      var obj = HistoryData.fromJson(data);
      temp.date = obj.date;
      temp.exerciseName = obj.exerciseName;
      temp.dairy = [];

      for (var item in obj.dairy!) {
        temp.dairy!.add(item);
      }
      bool yes = false;
      for (var item in temp.dairy!) {
        if (item.date == dairy.date) {
          yes = true;
          for (var items in dairy.history!) {
            int index = item.history!.indexWhere((element) =>
                element.workOutId == items.workOutId &&
                element.type == items.type);
            if (index == -1) {
              item.history!.add(items);
            } else {
              item.history![index] = items;
            }
          }
        }
      }
      if (yes == false) {
        temp.dairy!.add(dairy);
      }
      try {
        await user
            .doc(GetStorage().read('user').toString())
            .collection('History')
            .doc(id.toString())
            .update(temp.toJson())
            .timeout(const Duration(seconds: 5))
            .catchError((e) {
          if (kDebugMode) {
            print(e);
          }
          showToast(e.message.toString());
        }).whenComplete(() {
          if (kDebugMode) {
            print('history updated');
          }
        });
      } on FirebaseException catch (e) {
        showToast(e.message.toString());
      }
    } else {
      try {
        await user
            .doc(GetStorage().read('user').toString())
            .collection('History')
            .doc(id.toString())
            .set(historyData.toJson())
            .timeout(const Duration(seconds: 5))
            .catchError((e) {
          if (kDebugMode) {
            print(e);
          }
          showToast(e.message.toString());
        }).whenComplete(() {
          if (kDebugMode) {
            print('history updated');
          }
        });
      } on FirebaseException catch (e) {
        showToast(e.message.toString());
      }
    }
  }

  /// delete function for history
  Future<void> deleteHistoryData(String id, UserHistoryModel dairy,
      int mainIndex, String? dateOfWork) async {
    CollectionReference collectionRef =
        user.doc(GetStorage().read('user').toString()).collection('History');
    var doc = await collectionRef.doc(id).get();
    if (doc.exists) {
      HistoryData temp = HistoryData('', [], '');
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      var obj = HistoryData.fromJson(data);
      temp.date = obj.date;
      temp.exerciseName = obj.exerciseName;
      temp.dairy = [];

      for (var item in obj.dairy!) {
        temp.dairy!.add(item);
      }
      final date = DateTime.now();
      String dateFormated = dateOfWork ?? DateFormat("yyyy-MM-dd").format(date);
      print(dateFormated);
      int indexofDairy =
          temp.dairy!.indexWhere((element) => element.date == dateFormated);
      if (indexofDairy != -1) {
        int index = temp.dairy![indexofDairy].history!.indexWhere((element) =>
            element.workOutId == dairy.workOutId && element.type == dairy.type);
        if (index != -1) {
          if (temp.dairy!.length == 1 &&
              temp.dairy![indexofDairy].history!.length == 1) {
            try {
              await user
                  .doc(GetStorage().read('user').toString())
                  .collection('History')
                  .doc(id.toString())
                  .delete()
                  .timeout(const Duration(seconds: 5))
                  .catchError((e) {
                if (kDebugMode) {
                  print(e);
                }
                showToast(e.message.toString());
              }).whenComplete(() {
                if (kDebugMode) {
                  print('history updated');
                }
                return;
              });
            } on FirebaseException catch (e) {
              showToast(e.message.toString());
            }
          } else {
            if (temp.dairy![indexofDairy].history!.length == 1) {
              temp.dairy!.removeAt(indexofDairy);
            } else {
              temp.dairy![indexofDairy].history!.removeAt(index);
            }
            try {
              await user
                  .doc(GetStorage().read('user').toString())
                  .collection('History')
                  .doc(id.toString())
                  .update(temp.toJson())
                  .timeout(const Duration(seconds: 5))
                  .catchError((e) {
                if (kDebugMode) {
                  print(e);
                }
                showToast(e.message.toString());
              }).whenComplete(() {
                if (kDebugMode) {
                  print('history updated');
                }
                return;
              });
            } on FirebaseException catch (e) {
              showToast(e.message.toString());
            }
          }
        }
      }
      /*for (var item in temp.dairy!) {
        int index = item.history!.indexWhere((element) =>
            element.workOutId == dairy.workOutId && element.type == dairy.type);
        if (indexofDairy != -1) {
          if (index != -1) {
            if (temp.dairy!.length == 1 &&
                temp.dairy![indexofDairy].history!.length == 1) {
              try {
                await user
                    .doc(GetStorage().read('user').toString())
                    .collection('History')
                    .doc(id.toString())
                    .delete()
                    .timeout(const Duration(seconds: 5))
                    .catchError((e) {
                  if (kDebugMode) {
                    print(e);
                  }
                  showToast(e.message.toString());
                }).whenComplete(() {
                  if (kDebugMode) {
                    print('history updated');
                  }
                  return;
                });
              } on FirebaseException catch (e) {
                showToast(e.message.toString());
              }
            } else {
              if (temp.dairy![indexofDairy].history!.length == 1) {
                temp.dairy!.removeAt(indexofDairy);
              } else {
                temp.dairy![indexofDairy].history!.removeAt(index);
              }
              try {
                await user
                    .doc(GetStorage().read('user').toString())
                    .collection('History')
                    .doc(id.toString())
                    .update(temp.toJson())
                    .timeout(const Duration(seconds: 5))
                    .catchError((e) {
                  if (kDebugMode) {
                    print(e);
                  }
                  showToast(e.message.toString());
                }).whenComplete(() {
                  if (kDebugMode) {
                    print('history updated');
                  }
                  return;
                });
              } on FirebaseException catch (e) {
                showToast(e.message.toString());
              }
            }
          }
        }
      }*/
    }
  }

  Future<HistoryData?> readHistoryData(String id) async {
    try {
      CollectionReference collectionRef =
          user.doc(GetStorage().read('user').toString()).collection('History');
      var doc = await collectionRef
          .doc(id)
          .get()
          .timeout(const Duration(seconds: 5))
          .catchError((e) {
        if (kDebugMode) {
          print(e);
        }
        showToast(e.message.toString());
      });

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        HistoryData obj = HistoryData.fromJson(data);
        return obj;
      }
    } on FirebaseException catch (e) {
      showToast(e.message.toString());
    }

    return null;
  }

  Future<void> readUserWorkOutsForCalender() async {
    QuerySnapshot querySnapshot;
    try {
      querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(GetStorage().read('user').toString())
          .collection('Workouts')
          .get()
          .timeout(const Duration(seconds: 5))
          .catchError((e) {
        Future.value(e.message.toString());
      });
      if (querySnapshot.docs.isEmpty) {
        if (events.isNotEmpty) {
          events.clear();
        }
      }
      if (querySnapshot.docs.isNotEmpty) {
        if (events.isNotEmpty) {
          events.clear();
        }
        for (var doc in querySnapshot.docs.toList()) {
          var obj = WorkOutData.fromJson(doc.data() as Map<String, dynamic>);
          final itemDate = DateTime.parse(obj.workDate.toString());
          final dateNow = DateTime.now();
          String dateFormated = DateFormat("yyyy-MM-dd").format(dateNow);
          events.add(DateModel(
            color: colorList[int.parse(obj.workOut![0].color.toString())],
            dateTime: DateTime.parse(obj.workDate.toString()),
          ));
          update();
          /*if (itemDate.isAfter(dateNow) ||
              itemDate.isAtSameMomentAs(DateTime.parse(dateFormated))) {
            update();
          }*/
        }

        //return cateList;
      }
    } on FirebaseException catch (e) {
      showToast(e.message.toString());
    }
  }

  Stream<QuerySnapshot<Object?>> readUserWorkOuts(String date) {
    if (date == '') {
      final Stream<QuerySnapshot> _workoutsStream = FirebaseFirestore.instance
          .collection('Users')
          .doc(GetStorage().read('user').toString())
          .collection('Workouts')
          .where('workDate',
              isEqualTo: DateFormat("yyyy-MM-dd").format(DateTime.now()))
          .snapshots();
      return _workoutsStream;
    } else {
      final Stream<QuerySnapshot> _workoutsStream = FirebaseFirestore.instance
          .collection('Users')
          .doc(GetStorage().read('user').toString())
          .collection('Workouts')
          .where('workDate', isEqualTo: date)
          .snapshots();
      return _workoutsStream;
    }
  }

  //=====
  Stream<QuerySnapshot<Object?>> readUserWorkOutsall() {
    final Stream<QuerySnapshot> _workoutsStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(GetStorage().read('user').toString())
        .collection('Workouts')
        .snapshots();
    return _workoutsStream;
  }

  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      CollectionReference collectionRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(GetStorage().read('user').toString())
          .collection('Workouts');

      var doc = await collectionRef
          .doc(docId)
          .get()
          .timeout(const Duration(seconds: 5))
          .catchError((e) {
        if (kDebugMode) {
          print(e);
        }
        showToast(e.message.toString());
      });
      if (kDebugMode) {
        print(doc.data());
      }
      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }
}
