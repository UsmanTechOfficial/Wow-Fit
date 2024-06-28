import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:wowfit/Models/ExceriseCategories.dart';
import 'package:wowfit/Models/WorkOutModel.dart';

import '../Home/BottomNavigation/bottomNavigationScreen.dart';
import '../Utils/notificationService.dart';
import '../Utils/showtoaist.dart';

var subCate = <SubCategories>[].obs;

class AddExerciseController extends GetxController {
  List<ExerciseCategories> cateList = [
    ExerciseCategories(
        id: '2',
        categoryName: 'Hip',
        img: 'assets/hip.svg',
        selectedBtn: false),
    ExerciseCategories(
        id: '3',
        categoryName: 'legs muscles',
        img: 'assets/leg.svg',
        selectedBtn: false),
    ExerciseCategories(
        id: '8',
        categoryName: 'Wings',
        img: 'assets/wing.svg',
        selectedBtn: false),
    ExerciseCategories(
        id: '5',
        categoryName: 'Pectoral',
        img: 'assets/chest.svg',
        selectedBtn: false),
    ExerciseCategories(
        id: '7',
        categoryName: 'Shoulder muscles',
        img: 'assets/shoulder.svg',
        selectedBtn: false),
    ExerciseCategories(
        id: '0',
        categoryName: 'Arm muscles',
        img: 'assets/arm.svg',
        selectedBtn: false),
    ExerciseCategories(
        id: '6',
        categoryName: 'Press',
        img: 'assets/aabs.svg',
        selectedBtn: false),
    ExerciseCategories(
        id: '1',
        categoryName: 'Cardio',
        img: 'assets/cardio.svg',
        selectedBtn: false),
    ExerciseCategories(
        id: '4',
        categoryName: 'Mind body',
        img: 'assets/mind_body.svg',
        selectedBtn: false),
    ExerciseCategories(
        id: '9',
        categoryName: 'Spa',
        img: 'assets/spa.svg',
        selectedBtn: false),
  ];
  var loader = false.obs;
  ExerciseCategories categories = ExerciseCategories();

  /*Stream documentStream =
  FirebaseFirestore.instance.collection('Users').doc('ABC123').snapshots();*/
  /// add categories on firebase but we add locally in app
  Future<void> addCategories() {
    categories.id = 5.toString();
    categories.img = "assets/arm.png";
    categories.categoryName = "legs muscles";
    return FirebaseFirestore.instance
        .collection("Categories")
        .doc()
        .set(categories.toJson())
        .whenComplete(() {})
        .timeout(const Duration(seconds: 5))
        .catchError((e) {
      if (kDebugMode) {
        print(e);
      }
      showToast(e.message.toString());
    });
  }

  /// read categories but we read locally in app
  Future<void> readCategories() async {
    if (cateList.isNotEmpty) {
      cateList.clear();
    }
    QuerySnapshot querySnapshot;
    try {
      querySnapshot = await FirebaseFirestore.instance
          .collection('Categories')
          .get()
          .timeout(const Duration(seconds: 5))
          .catchError((e) {
        if (kDebugMode) {
          print(e);
        }
        showToast(e.message.toString());
      });
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          cateList.add(ExerciseCategories.fromJson(doc));
        }
        update();
        //return cateList;
      }
    } catch (e) {
      print(e);
    }
  }

  /// delete user complete workout
  Future<void> deleteUserWorkout(WorkOutData workOutData, int index) async {
    print(workOutData.workOut!.length);
    if (workOutData.workOut!.length == 1) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(GetStorage().read('user').toString())
          .collection('Workouts')
          .doc(workOutData.workDate.toString())
          .delete()
          .then((value) => print("User Deleted"))
          .timeout(const Duration(seconds: 5))
          .catchError((e) {
        if (kDebugMode) {
          print(e);
        }
        showToast(e.message.toString());
      }).whenComplete(() => {
                Get.offAll(() => BottomNavigationScreen(
                      index: 0,
                    ))
              });
    } else {
      workOutData.workOut!.removeAt(index);
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(GetStorage().read('user').toString())
          .collection('Workouts')
          .doc(workOutData.workDate.toString())
          .update(workOutData.toJson())
          .then((value) => print("User Deleted"))
          .timeout(const Duration(seconds: 5))
          .catchError((e) {
        if (kDebugMode) {
          print(e);
        }
        showToast(e.message.toString());
      }).whenComplete(() => {
                Get.offAll(() => BottomNavigationScreen(
                      index: 0,
                    ))
              });
    }
  }

  /// delete user categories
  Future<void> deleteUserCategories(String exerciseName) async {

    try {
      CollectionReference collectionRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(GetStorage().read('user').toString())
          .collection('SubCategories');
      var doc = await collectionRef.doc('subCate').get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        BuiltinCategories subCates = BuiltinCategories.fromJson(data);
        // for (var element in subCates.subCategories!) {
        //   if (element.rBtn!) {
        //     element.rBtn = false;
        //   }
        // }
        subCates.subCategories!.removeWhere((element) {
          return element.subCategoryName ==
              exerciseName;
        });
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(GetStorage().read('user').toString())
            .collection('SubCategories')
            .doc('subCate')
            .update(subCates.toJson())
            .then((value) => print("Exercise Updated"))
            .timeout(const Duration(seconds: 5))
            .catchError((e) {
          if (kDebugMode) {
            print(e);
          }
          showToast(e.message.toString());
        });
      }
    } on FirebaseException catch (e) {
      showToast(e.message.toString());
    }
  }

  /// Search Query for exercise
  Stream<DocumentSnapshot<Object?>>? readUserCategories(String name) {
    final Stream<DocumentSnapshot> _subCateStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(GetStorage().read('user').toString())
        .collection('SubCategories')
        .doc('subCate')
        /*.where('rBtn', isGreaterThanOrEqualTo: false)
          .orderBy('rBtn', descending: true)*/
        .snapshots();
    return _subCateStream;
    /*if (name.isNotEmpty) {
      final Stream<DocumentSnapshot> _subCateStreamSearch = FirebaseFirestore
          .instance
          .collection('Users')
          .doc(GetStorage().read('user').toString())
          .collection('SubCategories')
          .doc('SubCate')
          */ /*.where('subCategoryName', isGreaterThanOrEqualTo: name)
          .where('subCategoryName', isLessThan: name + '~')*/ /*
          .snapshots();
      return _subCateStreamSearch;
    } else {

    }*/
  }

  /// update user categories only true and false value
  Future<void> updateUserSubCategory(int index, bool value) async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(GetStorage().read('user').toString())
          .collection('SubCategories');
      var doc = await collectionRef.doc('subCate').get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        BuiltinCategories subCates = BuiltinCategories.fromJson(data);
        subCates.subCategories![index].rBtn = value;
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(GetStorage().read('user').toString())
            .collection('SubCategories')
            .doc('subCate')
            .update(subCates.toJson())
            .then((value) => print("Exercise Updated"))
            .timeout(const Duration(seconds: 5))
            .catchError((e) {
          if (kDebugMode) {
            print(e);
          }
          showToast(e.message.toString());
        });
      }
    } on FirebaseException catch (e) {
      showToast(e.message.toString());
    }
  }

  Future<void> refreshSubCategories() async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(GetStorage().read('user').toString())
          .collection('SubCategories');
      var doc = await collectionRef.doc('subCate').get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        BuiltinCategories subCates = BuiltinCategories.fromJson(data);
        for (var element in subCates.subCategories!) {
          if (element.rBtn!) {
            element.rBtn = false;
          }
        }
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(GetStorage().read('user').toString())
            .collection('SubCategories')
            .doc('subCate')
            .update(subCates.toJson())
            .then((value) => print("Exercise Updated"))
            .timeout(const Duration(seconds: 5))
            .catchError((e) {
          if (kDebugMode) {
            print(e);
          }
          showToast(e.message.toString());
        });
      }
    } on FirebaseException catch (e) {
      showToast(e.message.toString());
    }
  }

  Future<void> updateWorkList(
      String id, WorkOutData workOutData, int index) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(GetStorage().read('user').toString())
          .collection('Workouts')
          .doc(id)
          .update(workOutData.toJson())
          .then((value) {
            print("Successfully Saved");
          })
          .timeout(const Duration(seconds: 5))
          .catchError((e) {
            if (kDebugMode) {
              print(e);
            }
            loader.value = false;
            showToast(e.message.toString());
          })
          .whenComplete(() {
            loader.value = false;
          });
    } on FirebaseException catch (e) {
      showToast(e.message.toString());
    }
  }




  String getRandomGeneratedId() {
    const int AUTO_ID_LENGTH = 20;
    const String AUTO_ID_ALPHABET =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

    const int maxRandom = AUTO_ID_ALPHABET.length;
    final Random randomGen = Random();

    String id = '';
    for (int i = 0; i < AUTO_ID_LENGTH; i++) {
      id = id + AUTO_ID_ALPHABET[randomGen.nextInt(maxRandom)];
    }
    return id;
  }

  Future<void> updateWorkout(
      WorkOutData workOutData, String workoutDate, int index) async {
    final user = FirebaseFirestore.instance.collection('Users');
    CollectionReference collectionRef =
        user.doc(GetStorage().read('user').toString()).collection('Workouts');
    String dateFormated =
        DateFormat("yyyy-MM-dd").format(DateTime.parse(workoutDate));
    var docOldDate = await collectionRef.doc(dateFormated.toString()).get();
    var docNewDate = await collectionRef
        .doc(workOutData.workOut![index].wDate.toString())
        .get();

    if (dateFormated == workOutData.workOut![index].wDate) {
      if (docOldDate.exists) {
        user
            .doc(GetStorage().read('user').toString())
            .collection('Workouts')
            .doc(dateFormated.toString())
            .update(workOutData.toJson())
            .timeout(const Duration(seconds: 5))
            .catchError((e) {
          if (kDebugMode) {
            print(e);
          }

          loader.value = false;
          showToast(e.message.toString());
        }).whenComplete(() {
          if (int.parse(workOutData.workOut![index].notify.toString()) != 0) {
            NotificationService().setNotification(
                workOutData.workOut![index].startTime.toString(),
                index,
                workOutData.workOut![index].workOutTitleName.toString(),
                int.parse(workOutData.workOut![index].notify.toString()),
                DateTime.parse(workOutData.workDate!));
          }
          Get.back();
          loader.value = false;
        });
      }
    } else {
      workOutData.workOut![index].wId = getRandomGeneratedId();
      if (docOldDate.exists) {
        if (workOutData.workOut!.length == 1) {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(GetStorage().read('user').toString())
              .collection('Workouts')
              .doc(dateFormated)
              .delete()
              .then((value) => print("User Deleted"))
              .timeout(const Duration(seconds: 5))
              .catchError((e) {
            if (kDebugMode) {
              print(e);
            }
            showToast(e.message.toString());
          }).whenComplete(() async {
            if (docNewDate.exists) {
              WorkOutData temp = WorkOutData();
              Map<String, dynamic> data =
                  docNewDate.data() as Map<String, dynamic>;
              var obj = WorkOutData.fromJson(data);
              temp.workDate = workOutData.workOut![index].wDate.toString();
              temp.color = workOutData.color;
              temp.workOut = [];
              for (var item in obj.workOut!) {
                temp.workOut!.add(item);
              }
              temp.workOut!.add(workOutData.workOut![index]);
              await user
                  .doc(GetStorage().read('user').toString())
                  .collection('Workouts')
                  .doc(workOutData.workOut![index].wDate.toString())
                  .set(temp.toJson())
                  .timeout(const Duration(seconds: 5))
                  .catchError((e) {
                if (kDebugMode) {
                  loader.value = false;
                  print(e);
                }
                showToast(e.message.toString());
              }).whenComplete(() {
                loader.value = false;
                if (int.parse(workOutData.workOut![index].notify.toString()) !=
                    0) {
                  NotificationService().setNotification(
                      workOutData.workOut![index].startTime.toString(),
                      index,
                      workOutData.workOut![index].workOutTitleName.toString(),
                      int.parse(workOutData.workOut![index].notify.toString()),
                      DateTime.parse(workOutData.workDate!));
                }
                Get.offAll(() => BottomNavigationScreen(
                      index: 0,
                    ));
              });
            } else {
              WorkOutData temp = WorkOutData();
              temp.workDate = workOutData.workOut![index].wDate.toString();
              temp.color = workOutData.color;
              temp.workOut = [];
              temp.workOut!.add(workOutData.workOut![index]);
              await user
                  .doc(GetStorage().read('user').toString())
                  .collection('Workouts')
                  .doc(workOutData.workOut![index].wDate.toString())
                  .set(temp.toJson())
                  .timeout(const Duration(seconds: 5))
                  .catchError((e) {
                if (kDebugMode) {
                  loader.value = false;
                  print(e);
                }
                showToast(e.message.toString());
              }).whenComplete(() {
                loader.value = false;
                if (int.parse(workOutData.workOut![index].notify.toString()) !=
                    0) {
                  NotificationService().setNotification(
                      workOutData.workOut![index].startTime.toString(),
                      index,
                      workOutData.workOut![index].workOutTitleName.toString(),
                      int.parse(workOutData.workOut![index].notify.toString()),
                      DateTime.parse(workOutData.workDate!));
                }
                Get.offAll(() => BottomNavigationScreen(
                      index: 0,
                    ));
              });
            }
          });
        } else {
          WorkOutData temp = WorkOutData();
          temp.workDate = dateFormated;
          temp.color = workOutData.color;
          temp.workOut = [];
          temp.workOut!.addAll(workOutData.workOut!);
          temp.workOut!.removeAt(index);
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(GetStorage().read('user').toString())
              .collection('Workouts')
              .doc(dateFormated)
              .update(temp.toJson())
              .timeout(const Duration(seconds: 5))
              .catchError((e) {
            if (kDebugMode) {
              print(e);
            }

            loader.value = false;
            showToast(e.message.toString());
          }).whenComplete(() async {
            if (docNewDate.exists) {
              WorkOutData temp = WorkOutData();
              Map<String, dynamic> data =
              docNewDate.data() as Map<String, dynamic>;
              var obj = WorkOutData.fromJson(data);
              temp.workDate = workOutData.workOut![index].wDate.toString();
              temp.color = workOutData.color;
              temp.workOut = [];
              for (var item in obj.workOut!) {
                temp.workOut!.add(item);
              }
              temp.workOut!.add(workOutData.workOut![index]);
              await user
                  .doc(GetStorage().read('user').toString())
                  .collection('Workouts')
                  .doc(workOutData.workOut![index].wDate.toString())
                  .set(temp.toJson())
                  .timeout(const Duration(seconds: 5))
                  .catchError((e) {
                if (kDebugMode) {
                  loader.value = false;
                  print(e);
                }
                showToast(e.message.toString());
              }).whenComplete(() {
                loader.value = false;
                if (int.parse(workOutData.workOut![index].notify.toString()) !=
                    0) {
                  NotificationService().setNotification(
                      workOutData.workOut![index].startTime.toString(),
                      index,
                      workOutData.workOut![index].workOutTitleName.toString(),
                      int.parse(workOutData.workOut![index].notify.toString()),
                      DateTime.parse(workOutData.workDate!));
                }
                Get.offAll(() => BottomNavigationScreen(
                  index: 0,
                ));
              });
            } else {
              WorkOutData temp = WorkOutData();
              temp.workDate = workOutData.workOut![index].wDate.toString();
              temp.color = workOutData.color;
              temp.workOut = [];
              temp.workOut!.add(workOutData.workOut![index]);
              await user
                  .doc(GetStorage().read('user').toString())
                  .collection('Workouts')
                  .doc(workOutData.workOut![index].wDate.toString())
                  .set(temp.toJson())
                  .timeout(const Duration(seconds: 5))
                  .catchError((e) {
                if (kDebugMode) {
                  loader.value = false;
                  print(e);
                }
                showToast(e.message.toString());
              }).whenComplete(() {
                loader.value = false;
                if (int.parse(workOutData.workOut![index].notify.toString()) !=
                    0) {
                  NotificationService().setNotification(
                      workOutData.workOut![index].startTime.toString(),
                      index,
                      workOutData.workOut![index].workOutTitleName.toString(),
                      int.parse(workOutData.workOut![index].notify.toString()),
                      DateTime.parse(workOutData.workDate!));
                }
                Get.offAll(() => BottomNavigationScreen(
                  index: 0,
                ));
              });
            }
          });
        }
      }
    }
  }

  Future<void> copyWorkout(
      WorkOutData workOutData, String dates, int index) async {
    String copyName = workOutData.workOut![index].workOutTitleName.toString();
    workOutData.workOut![index].workOutTitleName = copyName + " Copy";
    if (workOutData.workOut![index].addedExercise!.isNotEmpty) {
      for (var element in workOutData.workOut![index].addedExercise!) {
        if (element.dairy!.isNotEmpty) {
          for (var elements in element.dairy!) {
            elements.tick = false;
          }
        }
      }
    }
    final user = FirebaseFirestore.instance.collection('Users');
    CollectionReference collectionRef =
        user.doc(GetStorage().read('user').toString()).collection('Workouts');
    final date = DateTime.now();
    String dateFormated =
        DateFormat("yyyy-MM-dd").format(DateTime.parse(dates));
    var doc = await collectionRef.doc(dateFormated.toString()).get();
    workOutData.workOut![index].wId = getRandomGeneratedId();
    if (doc.exists) {
      WorkOutData temp = WorkOutData();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      var obj = WorkOutData.fromJson(data);
      temp.workDate = dateFormated;
      temp.color = workOutData.color;
      temp.workOut = [];
      for (var item in obj.workOut!) {
        temp.workOut!.add(item);
      }
      workOutData.workOut![index].img == "assets/bydeef.svg";
      temp.workOut!.add(workOutData.workOut![index]);

      user
          .doc(GetStorage().read('user').toString())
          .collection('Workouts')
          .doc(dateFormated.toString())
          .set(temp.toJson(), SetOptions(merge: true))
          .timeout(const Duration(seconds: 5))
          .catchError((e) {
        if (kDebugMode) {
          print(e);
        }

        loader.value = false;
        showToast(e.message.toString());
      }).whenComplete(() {
        if (int.parse(workOutData.workOut![index].notify.toString()) != 0) {
          NotificationService().setNotification(
              workOutData.workOut![index].startTime.toString(),
              index,
              workOutData.workOut![index].workOutTitleName.toString(),
              int.parse(workOutData.workOut![index].notify.toString()),
              DateTime.parse(workOutData.workOut![index].wDate.toString()));
        }
        NotificationService().showSimpleNotification(
            index,
            workOutData.workOut![index].workOutTitleName.toString(),
            'Copy Workout Successful'.tr);
        loader.value = false;
        Get.offAll(() => BottomNavigationScreen(
              index: 0,
            ));
      });
    } else {
      if (kDebugMode) {
        print(GetStorage().read('user').toString());
      }
      if (kDebugMode) {
        print(dateFormated);
      }
      workOutData.workDate = dateFormated;
      var worko = workOutData.workOut;
      workOutData.workOut = [];
      workOutData.workOut!.add(worko![index]);
      await user
          .doc(GetStorage().read('user').toString())
          .collection('Workouts')
          .doc(dateFormated.toString())
          .set(workOutData.toJson())
          .timeout(const Duration(seconds: 5))
          .catchError((e) {
        if (kDebugMode) {
          loader.value = false;
          print(e);
        }
        showToast(e.message.toString());
      }).whenComplete(() {
        if (int.parse(workOutData.workOut![index].notify.toString()) != 0) {
          NotificationService().setNotification(
              workOutData.workOut![index].startTime.toString(),
              index,
              workOutData.workOut![index].workOutTitleName.toString(),
              int.parse(workOutData.workOut![index].notify.toString()),
              DateTime.parse(workOutData.workOut![index].wDate.toString()));
        }
        loader.value = false;
        Get.offAll(() => BottomNavigationScreen(
              index: 0,
            ));
      });
    }
  }
}
