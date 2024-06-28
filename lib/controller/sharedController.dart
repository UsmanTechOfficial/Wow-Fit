import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:wowfit/Models/WorkOutModel.dart';

import '../Models/ExceriseCategories.dart';
import '../Utils/showtoaist.dart';
import '../WorkoutScreen/newWorkOutScreen.dart';
import 'newWorkoutController.dart';

class SharedController extends GetxController {
  CollectionReference user = FirebaseFirestore.instance.collection('Users');
  late BuiltinCategories cateList;

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

  Future<void> readAnotherUserWorkOuts(
      String userId, String workoutId, String index) async {
    readSubCategories();
    CollectionReference collectionRef = user.doc(userId).collection('Workouts');
    var docAnotherUser = await collectionRef.doc(workoutId).get();
    Map<String, dynamic> data = docAnotherUser.data() as Map<String, dynamic>;
    //anotherUser
    var objAnotherUser = WorkOutData.fromJson(data);
    CollectionReference collectionRef2 =
        user.doc(GetStorage().read('user').toString()).collection('Workouts');
    String dateFormated = DateFormat("yyyy-MM-dd")
        .format(DateTime.parse(objAnotherUser.workDate!.toString()));
    var doc = await collectionRef2.doc(dateFormated.toString()).get();
    if (doc.exists) {
      WorkOutData temp = WorkOutData();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      var obj = WorkOutData.fromJson(data);
      temp.workDate = obj.workDate;
      temp.workOut = [];
      for (var item in obj.workOut!) {
        temp.workOut!.add(item);
      }
      temp.workOut!.add(objAnotherUser.workOut![int.parse(index)]);

      addNewExerciseIfAny(objAnotherUser,userId,index);
      String u = GetStorage().read('user') ?? '';
      if (u.isNotEmpty) {
        NewWorkOutController con = Get.put(NewWorkOutController());
        con.workOutData = objAnotherUser;
        con.workout = objAnotherUser.workOut![int.parse(index)];
        Get.offAll(WorkOutScreen(
          controller: con,
          openFromShare: true,
        ));
      }
    } else {
      objAnotherUser.workDate = dateFormated.toString();
      addNewExerciseIfAny(objAnotherUser,userId,index);
      String u = GetStorage().read('user') ?? '';
      if (u.isNotEmpty) {
        NewWorkOutController con = Get.put(NewWorkOutController());
        con.workOutData = objAnotherUser;
        con.workout = objAnotherUser.workOut![int.parse(index)];
        Get.offAll(WorkOutScreen(
          controller: con,
          openFromShare: true,
        ));
      }
    }
  }
  addNewExerciseIfAny(WorkOutData objAnotherUser,String userId, String index) async {
    for (var elements
    in objAnotherUser.workOut![int.parse(index)].addedExercise!) {
      bool exist = cateList.subCategories!
          .any((element) => element.subCategoryName == elements.title);
      if (!exist) {
        cateList.subCategories!.add(SubCategories(
            id: elements.subcategoriesId,
            date: DateTime.now().toString(),
            img: elements.image,
            rBtn: false,
            subCategoryName: elements.title,
            userid: GetStorage().read('user').toString()));
        await user
            .doc(GetStorage().read('user').toString())
            .collection('SubCategories')
            .doc('subCate')
            .update(cateList.toJson())
            .timeout(const Duration(seconds: 5))
            .catchError((e) {
          if (kDebugMode) {
            print(e);
          }
          showToast(e.message.toString());
        });
        var doc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('UserNotes')
            .doc(elements.title)
            .get()
            .catchError((e) {
          showToast(e);
        });
        if(doc.exists){
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(GetStorage().read('user').toString())
              .collection('UserNotes')
              .doc(elements.title)
              .set(doc.data() as Map<String, dynamic>)
              .catchError((error) {
            if (kDebugMode) {
              print("Failed to update user: $error");
            }
            showToast(error);
          });
        }
      }
    }
  }

  Future<void> readSubCategories() async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(GetStorage().read('user').toString())
          .collection('SubCategories');
      var doc = await collectionRef.doc('subCate').get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        cateList = BuiltinCategories.fromJson(data);
      }
    } catch (e) {
      print(e);
    }
  }
}
