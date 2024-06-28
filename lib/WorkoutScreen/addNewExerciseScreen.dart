import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:wowfit/Utils/color_resources.dart';
import 'package:wowfit/Utils/styles.dart';
import 'package:wowfit/Widgets/buttonWidget.dart';
import 'package:wowfit/Widgets/customRadioButton.dart';
import 'package:wowfit/Widgets/inputField.dart';

import '../Models/ExceriseCategories.dart';
import '../Utils/showtoaist.dart';
import 'addExerciseScreen.dart';

class AddNewExerciseScreen extends StatefulWidget {
  const AddNewExerciseScreen({Key? key}) : super(key: key);

  @override
  State<AddNewExerciseScreen> createState() => _AddNewExerciseScreenState();
}

class _AddNewExerciseScreenState extends State<AddNewExerciseScreen> {
  int? _groupValue;
  int _currentIndex = -1;
  bool showSpinner = false;
  final TextEditingController _titleController = TextEditingController();
  bool blue = false;
  final exFormGlobalKey = GlobalKey<FormState>();
  List<ExerciseCategories> temp = [
    ExerciseCategories(
        id: '0',
        categoryName: 'Arm muscles',
        img: 'assets/arm.svg',
        selectedBtn: false),
    ExerciseCategories(
        id: '1',
        categoryName: 'Cardio',
        img: 'assets/cardio.svg',
        selectedBtn: false),
    ExerciseCategories(
        id: '2',
        categoryName: 'Hip',
        img: 'assets/hip.svg',
        selectedBtn: false),
    ExerciseCategories(
        id: '3',
        categoryName: 'Legs muscles',
        img: 'assets/leg.svg',
        selectedBtn: false),
    ExerciseCategories(
        id: '4',
        categoryName: 'Mind body',
        img: 'assets/mind_body.svg',
        selectedBtn: false),
    ExerciseCategories(
        id: '5',
        categoryName: 'Pectoral',
        img: 'assets/chest.svg',
        selectedBtn: false),
    ExerciseCategories(
        id: '6',
        categoryName: 'Press',
        img: 'assets/aabs.svg',
        selectedBtn: false),
    ExerciseCategories(
        id: '7',
        categoryName: 'Shoulder muscles',
        img: 'assets/shoulder.svg',
        selectedBtn: false),
    ExerciseCategories(
        id: '8',
        categoryName: 'Wings',
        img: 'assets/wing.svg',
        selectedBtn: false),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => AddExerciseScreen(
                      fromUpdate: false,
                    )),
            (route) => false);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 25, right: 25),
          child: ButtonWidget(
            text: "Save".tr,
            height: 50,
            color: blue ? Colors.white : null,
            containerColor: blue ? ColorResources.COLOR_BLUE : null,
            onTap: () async {
              if (kDebugMode) {
                print('save');
              }
              //if (CheckInternet.internetStatus) {
              if (exFormGlobalKey.currentState!.validate()) {
                setState(() {
                  showSpinner = true;
                });

                var userid = GetStorage().read('user');
                bool check = true;
                try {
                  for (var items in temp) {
                    if (items.selectedBtn == true) {
                      try {
                        CollectionReference collectionRef = FirebaseFirestore
                            .instance
                            .collection('Users')
                            .doc(GetStorage().read('user').toString())
                            .collection('SubCategories');
                        var doc = await collectionRef.doc('subCate').get();
                        if (doc.exists) {
                          Map<String, dynamic> data =
                              doc.data() as Map<String, dynamic>;
                          BuiltinCategories subCates =
                              BuiltinCategories.fromJson(data);
                          subCates.subCategories!.add(SubCategories(
                            id: items.id,
                            userid: userid.toString(),
                            img: items.img,
                            subCategoryName: _titleController.text,
                            rBtn: false,
                            date: DateTime.now().toString(),
                          ));
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
                            setState(() {
                              check = false;
                            });
                            showToast(e.message.toString());
                          });
                        }
                      } on FirebaseException catch (e) {
                        if (kDebugMode) {
                          print(e.message);
                        }
                        showToast(e.message.toString());
                      }
                    }
                  }
                  bool value =
                      temp.any((element) => element.selectedBtn == true);
                  if (!value) {
                    setState(() {
                      showSpinner = false;
                    });
                    showToast('Please choose type of exercise'.tr);
                  } else if (check) {
                    showToast('Exercise created successfully'.tr);
                    setState(() {
                      showSpinner = false;
                    });
                    Get.back();
                  } else {
                    setState(() {
                      showSpinner = false;
                    });
                    showToast('Something went wrong'.tr);
                  }
                } on FirebaseException catch (e) {
                  if (kDebugMode) {
                    print(e.message);
                  }
                  showToast(e.message.toString());
                }
              }
            },
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Add new exercise".tr,
            style: sFProDisplayMedium.copyWith(
                fontSize: 18, color: ColorResources.COLOR_NORMAL_BLACK),
          ),
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: ColorResources.COLOR_NORMAL_BLACK,
            ),
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Form(
              key: exFormGlobalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 80,
                    child: InputFields(
                      "Exercise title".tr,
                      "your email".tr,
                      exTitle: true,
                      controller: _titleController,
                      callback: (value) {},
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Choose type of exercise".tr,
                    style: sFProDisplayRegular.copyWith(
                        fontSize: 16, color: ColorResources.COLOR_NORMAL_BLACK),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 0),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemCount: temp.length,
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                blue = true;
                                _groupValue = i;

                                for (var items in temp) {
                                  if (int.parse(items.id.toString()) == i) {
                                    temp[int.parse(items.id.toString())]
                                        .selectedBtn = true;
                                  } else {
                                    temp[int.parse(items.id.toString())]
                                        .selectedBtn = false;
                                  }
                                }
                              });
                            },
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 45,
                                          height: 45,
                                          child: SvgPicture.asset(
                                            temp[i].img.toString(),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          temp[i].categoryName.toString().tr,
                                          style: sFProDisplayRegular.copyWith(
                                              fontSize: 16,
                                              color: ColorResources
                                                  .COLOR_NORMAL_BLACK),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: SizedBox(
                                      width: 40,
                                      height: 50,
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: CustomRadioWidget(
                                            onChanged: (int? newValue) {
                                              setState(() {
                                                blue = true;
                                                _groupValue = newValue!;

                                                for (var items in temp) {
                                                  if (int.parse(items.id
                                                          .toString()) ==
                                                      newValue) {
                                                    temp[int.parse(items.id
                                                            .toString())]
                                                        .selectedBtn = true;
                                                  } else {
                                                    temp[int.parse(items.id
                                                            .toString())]
                                                        .selectedBtn = false;
                                                  }
                                                }
                                              });
                                            },
                                            groupValue: _groupValue,
                                            value: i,
                                          ) /*RadioListTile(
                                          value: i,
                                          groupValue: _groupValue,
                                          onChanged: (int? newValue) =>
                                              setState(() => _groupValue = newValue!),
                                        ),*/
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
