import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitted_text_field_container/fitted_text_field_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wowfit/BottomSheet/editBottomSheet.dart';
import 'package:wowfit/BottomSheet/rateBottomSheet.dart';
import 'package:wowfit/DialougBox/deleteDefaultDialoug.dart';
import 'package:wowfit/Home/BottomNavigation/bottomNavigationScreen.dart';
import 'package:wowfit/Home/Screens/proScreen/buyProScreen.dart';
import 'package:wowfit/Models/userAddedExcercise.dart';
import 'package:wowfit/Models/userHistoryModel.dart';
import 'package:wowfit/Utils/color_resources.dart';
import 'package:wowfit/Utils/showtoaist.dart';
import 'package:wowfit/Utils/styles.dart';
import 'package:wowfit/Widgets/buttonWidget.dart';
import 'package:wowfit/WorkoutScreen/addExerciseScreen.dart';
import 'package:wowfit/controller/newWorkoutController.dart';

import '../DialougBox/progressDialog.dart';
import '../Models/WorkOutModel.dart';
import '../Models/singletons_data.dart';
import '../Utils/image_utils.dart';
import '../Utils/shareWorkout.dart';
import '../Widgets/CustomCheckBox.dart';
import '../Widgets/customContainer.dart';
import '../Widgets/dairyWidget2.dart';
import '../controller/addExcerciseController.dart';
import 'DetailExercise/exerciseDetail.dart';

var isBtnBlue = false.obs;

class ViewWorkOutScreen extends StatefulWidget {
  List<WorkOutModel> workout;
  int index;
  WorkOutData workOutData;

  ViewWorkOutScreen({Key? key, required this.workout, required this.index, required this.workOutData}) : super(key: key);

  @override
  State<ViewWorkOutScreen> createState() => _ViewWorkOutScreenState();
}

class _ViewWorkOutScreenState extends State<ViewWorkOutScreen> {
  final TextEditingController _workOutController = TextEditingController();
  List<UserList> userList = <UserList>[].obs;
  bool isOpenSuperSet = false;
  bool allowDrag = true;
  bool isSuperSetBtnPress = false;
  bool hide = false;
  bool isDown = false;
  List<UserList> newSupersetList = [];
  List<UserList> unSelectedList = [];
  double length = 0.0;
  int lastIndex = 0;
  int indexValue = 0;
  var rotateBtn = 0.obs;
  var showBtn = true.obs;
  bool isSuperSetDone = false;
  AddExerciseController con = Get.put(AddExerciseController());
  NewWorkOutController conNew = Get.put(NewWorkOutController());
  final List<String> _notification = [
    'Do not notify'.tr,
    'In 30 minutes'.tr,
    'In 1 hour'.tr,
    'In 12 hours'.tr,
  ];
  final ScrollController listViewScroller = ScrollController();

  @override
  void initState() {
    userList.addAll(widget.workout[widget.index].addedExercise!);
    _workOutController.text = widget.workout[widget.index].workOutTitleName.toString();
    updateCustomContainer();
    super.initState();
  }

  updateCustomContainer() {
    if (newSupersetList.isNotEmpty && unSelectedList.isNotEmpty) {
      newSupersetList.clear();
      unSelectedList.clear();
    }

    int i = 0;
    for (var element in userList) {
      if (element.isItemSelect == true) {
        element.selectedIndex = i;
        newSupersetList.add(element);
        i++;
      } else {
        unSelectedList.add(element);
      }
    }
    setState(() {
      userList.clear();
      if (newSupersetList.isNotEmpty) {
        isSuperSetDone = true;
        indexValue = newSupersetList.length;
        print('newsuper $indexValue');
        allowDrag = false;
      } else {
        isSuperSetDone = false;
        allowDrag = true;
      }
      // userList.addAll(unSelectedList);
      // userList.addAll(newSupersetList);
      userList.addAll(widget.workout[widget.index].addedExercise!);
      print("===========>seleted Length${newSupersetList.length}");
      lastIndex = userList.length - 1;
      print(lastIndex);
      for (var i = 0; i < userList.length; i++) {
        userList[i].selectedIndexLength = newSupersetList.length;
        if (userList[i].items != null && userList[i].items.isNotEmpty) {
          for (var item in userList[i].items) {
            if (item is DairyWidgetTwo) {
              item.parrentindex = i;
              item.indexValue = indexValue;
            }
          }
        }
      }
    });

    // widget.workOutData.workOut![widget.index].addedExercise!.clear();
    // widget.workOutData.workOut![widget.index].addedExercise!.addAll(userList);
    // con.updateWorkList(widget.workOutData.workDate.toString(),
    //     widget.workOutData, widget.index);
  }

  Widget getListItem(int i) {
    return SizedBox(
      key: ValueKey(i),
      width: MediaQuery.of(context).size.width,
      child: ReorderableDragStartListener(
        index: i,
        enabled: userList[i].isItemSelect == true ? false : true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                isOpenSuperSet == true
                    ? SizedBox(
                        width: 40,
                        height: 50,
                        child: GestureDetector(
                          child: CustomCheckBox(
                            index: i,
                            isSelected: userList[i].isItemSelect == false ? false : true,
                            callback: (value) {
                              if (value) {
                                userList[i].isItemSelect = true;
                                List<UserList> sList = userList.where((element) => element.isItemSelect == true).toList();
                                List<UserList> unList = userList.where((element) => element.isItemSelect == false).toList();
                                userList.clear();
                                setState(() {
                                  userList.addAll(unList);
                                  userList.addAll(sList);
                                });
                              } else {
                                userList[i].isItemSelect = false;
                              }
                            },
                          ),
                        ))
                    : Container(),
                userList[i].isItemSelect == true
                    ? Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExerciseDetail(
                                          id: userList[i].title.toString(),
                                          categoryId: userList[i].subcategoriesId.toString(),
                                        )));
                          },
                          child: Row(
                            children: [
                              CustomContainer(
                                child: SizedBox(
                                  width: 45,
                                  height: 45,
                                  child: SvgPicture.asset(
                                    getGenderPathString(userList[i].image.toString()),
                                  ),
                                ),
                                value: userList[i].selectedIndex == 0 && isSuperSetDone == true
                                    ? CustomContainer.TOP
                                    : userList[i].selectedIndex == indexValue - 1 &&
                                            (userList[i].isDownData == false && isSuperSetDone == true ||
                                                userList[i].isDownData == true && isOpenSuperSet == true)
                                        ? CustomContainer.BOTTOM
                                        : isSuperSetDone == true
                                            ? CustomContainer.MID
                                            : 4,
                                height: 70,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  userList[i].title.toString().tr,
                                  maxLines: 3,
                                  textAlign: TextAlign.start,
                                  style: sFProDisplayRegular.copyWith(fontSize: 16, color: ColorResources.COLOR_NORMAL_BLACK),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExerciseDetail(
                                          id: userList[i].title.toString(),
                                          categoryId: userList[i].subcategoriesId.toString(),
                                        )));
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 45,
                                height: 45,
                                child: SvgPicture.asset(
                                  getGenderPathString(userList[i].image.toString()),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  userList[i].title.toString().tr,
                                  maxLines: 3,
                                  textAlign: TextAlign.start,
                                  style: sFProDisplayRegular.copyWith(fontSize: 16, color: ColorResources.COLOR_NORMAL_BLACK),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                InkWell(
                  onTap: () {
                    if (userList[i].isDownData == false) {
                      setState(() {
                        userList[i].isDownData = true;
                      });
                    } else {
                      setState(() {
                        userList[i].isDownData = false;
                      });
                    }
                  },
                  child: isOpenSuperSet
                      ? const SizedBox(
                          height: 70,
                          width: 30,
                        )
                      : SizedBox(
                          width: 30,
                          height: 70,
                          child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                userList[i].isDownData == true ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down_outlined,
                                color: ColorResources.COLOR_NORMAL_BLACK,
                              )),
                        ),
                ),
              ],
            ),
            userList[i].isDownData == true && !isOpenSuperSet
                ? ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: userList[i].items.isEmpty ? [const SizedBox()] : userList[i].items,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => BottomNavigationScreen(
                      index: 0,
                    )),
            (route) => false);
        return true;
      },
      child: Obx(
        () => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "My workout".tr,
              style: sFProDisplayRegular.copyWith(fontSize: 18, color: ColorResources.COLOR_NORMAL_BLACK),
            ),
            leading: InkWell(
              onTap: () {
                isBtnBlue.value = false;
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomNavigationScreen(
                              index: 0,
                            )),
                    (route) => false);
              },
              child: const Icon(
                Icons.arrow_back_ios,
                size: 18,
                color: ColorResources.COLOR_NORMAL_BLACK,
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(left: 15, right: 20, top: 10, bottom: Platform.isIOS ? 25 : 10),
            child: Obx(
              () => Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (isOpenSuperSet == false) {
                        int index = 0;
                        rotateBtn.value = 45;
                        showBtn.value = false;
                        for (var item in userList) {
                          if (item.isItemSelect == true) {
                            index++;
                          }
                        }
                        if (index == 0) {
                          setState(() {
                            isSuperSetDone = false;
                          });
                        }
                        setState(() {
                          isSuperSetDone = false;
                          isOpenSuperSet = true;
                          allowDrag = false;
                        });
                      } else {
                        /*if (isSuperSetDone == false) {
                          for (var element in userList) {
                            element.isItemSelect = false;
                          }
                          try {
                            widget
                                .workOutData.workOut![widget.index].addedExercise!
                                .clear();
                            widget
                                .workOutData.workOut![widget.index].addedExercise!
                                .addAll(userList);
                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(GetStorage().read('user').toString())
                                .collection('Workouts')
                                .doc(widget.workOutData.workDate.toString())
                                .update(widget.workOutData.toJson())
                                .then((value) {
                                  print("Successfully Saved");
                                })
                                .timeout(const Duration(seconds: 5))
                                .catchError((e) {
                                  showToast(e.message.toString());
                                })
                                .whenComplete(() {});
                          } on FirebaseException catch (e) {
                            showToast(e.message.toString());
                          }
                        }*/
                        if (hide == false) {
                          newSupersetList.clear();
                          unSelectedList.clear();
                          int i = 0;
                          for (var element in userList) {
                            if (element.isItemSelect == true) {
                              element.selectedIndex = i;
                              newSupersetList.add(element);
                              i++;
                            } else {
                              unSelectedList.add(element);
                            }
                          }

                          if (i == 1) {
                            setState(() {
                              isOpenSuperSet = true;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select more than 1')));
                          } else {
                            userList.clear();
                            if (newSupersetList.isNotEmpty) {
                              isSuperSetDone = true;
                              indexValue = newSupersetList.length;
                              if (kDebugMode) {
                                print('newsuper $indexValue');
                              }
                              allowDrag = false;
                            } else {
                              isSuperSetDone = false;
                              allowDrag = true;
                            }
                            userList.addAll(unSelectedList);
                            userList.addAll(newSupersetList);
                            if (kDebugMode) {
                              print("===========>seleted Length${newSupersetList.length}");
                            }
                            lastIndex = userList.length - 1;
                            if (kDebugMode) {
                              print(lastIndex);
                            }
                            for (var i = 0; i < userList.length; i++) {
                              userList[i].selectedIndexLength = newSupersetList.length;
                              if (userList[i].items != null && userList[i].items.isNotEmpty) {
                                for (var item in userList[i].items) {
                                  if (item is DairyWidgetTwo) {
                                    item.parrentindex = i;
                                    item.indexValue = indexValue;
                                  }
                                }
                              }
                            }

                            widget.workOutData.workOut![widget.index].addedExercise!.clear();
                            widget.workOutData.workOut![widget.index].addedExercise!.addAll(userList);
                            con.updateWorkList(widget.workOutData.workDate.toString(), widget.workOutData, widget.index);
                            setState(() {
                              isOpenSuperSet = false;
                            });
                            showBtn.value = true;
                            rotateBtn.value = 0;
                          }
                        }
                      }
                    },
                    child: Obx(
                      () => RotationTransition(turns: AlwaysStoppedAnimation(rotateBtn.value / 360), child: SvgPicture.asset("assets/superset.svg")),
                    ),
                  ),
                  const Spacer(),
                  if (showBtn.value)
                    Obx(
                      () => InkWell(
                        onTap: () async {
                          if (isBtnBlue.value) {
                            try {
                              if (_workOutController.text.isNotEmpty) {
                                widget.workout[widget.index].workOutTitleName = _workOutController.text;
                              }
                              widget.workOutData.workOut![widget.index].addedExercise!.clear();
                              widget.workOutData.workOut![widget.index].addedExercise!.addAll(userList);
                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(GetStorage().read('user').toString())
                                  .collection('Workouts')
                                  .doc(widget.workOutData.workDate.toString())
                                  .update(widget.workOutData.toJson())
                                  .then((value) {
                                    print("Successfully Saved");
                                  })
                                  .timeout(const Duration(seconds: 5))
                                  .catchError((e) {
                                    if (kDebugMode) {
                                      print(e);
                                    }
                                    showToast(e.message.toString());
                                  })
                                  .whenComplete(() {
                                    setState(() {
                                      isBtnBlue.value = false;
                                    });
                                  });
                            } on FirebaseException catch (e) {
                              showToast(e.message.toString());
                            }
                          }
                        },
                        child: ButtonWidget(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 45,
                          containerColor: isBtnBlue.value ? ColorResources.COLOR_BLUE : null,
                          color: isBtnBlue.value ? Colors.white : null,
                          text: 'Save'.tr,
                        ),
                      ),
                    ),
                  const SizedBox(
                    width: 10,
                  ),
                  if (showBtn.value)
                    InkWell(
                      onTap:
                          /*isOpenSuperSet == false
                          ?*/
                          () {
                        showModalBottomSheet<void>(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 300,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        color: const Color(0xFF979797).withOpacity(0.5),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (appData.entitlementIsActive.value) {
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            enableDrag: true,
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return StatefulBuilder(builder: (context, bottomSheetState) {
                                                return EditBottomSheet(
                                                  context: context,
                                                  isWorkOut: true,
                                                  workOutData: widget.workOutData,
                                                  bottomSheetState: bottomSheetState,
                                                  index: widget.index,
                                                  cameForm: true,
                                                );
                                              });
                                            },
                                          );
                                        } else {
                                          Get.back();
                                          Get.to(() => const BuyProScreen());
                                        }
                                      },
                                      child: Container(
                                        height: 45,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: ColorResources.LOGOUT_BUTTON,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Copy workout".tr,
                                            style: sFProDisplayRegular.copyWith(fontSize: 16, color: ColorResources.COLOR_NORMAL_BLACK),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        CustomProgressDialog progressDialog = defaultProgressDialog;
                                        progressDialog.show();
                                        await DynamicLinksApi.createReferralLink(
                                                GetStorage().read('user').toString(), widget.workOutData.workDate.toString(), widget.index.toString())
                                            .then((value) {
                                          progressDialog.dismiss();
                                          String link = value;
                                          Share.share(link);
                                        });
                                      },
                                      child: Container(
                                        height: 45,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: ColorResources.LOGOUT_BUTTON,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Share workout".tr,
                                            style: sFProDisplayRegular.copyWith(fontSize: 16, color: ColorResources.COLOR_NORMAL_BLACK),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (Platform.isIOS) {
                                          showCupertinoDialog(
                                            context: context,
                                            builder: (_) => DeleteDefaultDialog(
                                              context: context,
                                              errorText: "Do you want to delete a workout?".tr,
                                              callback: () {
                                                con.deleteUserWorkout(widget.workOutData, widget.index);
                                              },
                                            ),
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (_) => DeleteDefaultDialog(
                                              context: context,
                                              errorText: "Do you want to delete a workout?".tr,
                                              callback: () {
                                                con.deleteUserWorkout(widget.workOutData, widget.index);
                                              },
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: 45,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: ColorResources.LOGOUT_BUTTON,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Delete workout".tr,
                                            style: sFProDisplayRegular.copyWith(fontSize: 16, color: ColorResources.COLOR_NORMAL_BLACK),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    ButtonWidget(
                                      widthColor: Colors.black,
                                      containerColor: Colors.black,
                                      color: Colors.white,
                                      height: 50,
                                      text: "Rate workout".tr,
                                      onTap: () {
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          enableDrag: true,
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return RateBottomSheet(
                                              workOutData: widget.workOutData,
                                              index: widget.index,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      /*: () {
                              if (hide == false) {
                                newSupersetList.clear();
                                unSelectedList.clear();
                                int i = 0;
                                int count = 0;
                                for (var element in userList) {
                                  if (element.isItemSelect == true) {
                                    element.selectedIndex = i;
                                    newSupersetList.add(element);
                                    i++;
                                  } else {
                                    unSelectedList.add(element);
                                  }
                                }

                                if (i == 1) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Please select more than 1')));
                                } else {
                                  userList.clear();
                                  if (newSupersetList.isNotEmpty) {
                                    rotateBtn.value = 45;
                                    isSuperSetDone = true;
                                    indexValue = newSupersetList.length;
                                    if (kDebugMode) {
                                      print('newsuper $indexValue');
                                    }
                                    allowDrag = false;
                                  } else {
                                    isSuperSetDone = false;
                                    allowDrag = true;
                                  }
                                  userList.addAll(unSelectedList);
                                  userList.addAll(newSupersetList);
                                  if (kDebugMode) {
                                    print(
                                        "===========>seleted Length${newSupersetList.length}");
                                  }
                                  lastIndex = userList.length - 1;
                                  if (kDebugMode) {
                                    print(lastIndex);
                                  }
                                  for (var i = 0; i < userList.length; i++) {
                                    userList[i].selectedIndexLength =
                                        newSupersetList.length;
                                    if (userList[i].items != null &&
                                        userList[i].items.isNotEmpty) {
                                      for (var item in userList[i].items) {
                                        if (item is DairyWidgetTwo) {
                                          item.parrentindex = i;
                                          item.indexValue = indexValue;
                                        }
                                      }
                                    }
                                  }

                                  widget.workOutData.workOut![widget.index]
                                      .addedExercise!
                                      .clear();
                                  widget.workOutData.workOut![widget.index]
                                      .addedExercise!
                                      .addAll(userList);
                                  con.updateWorkList(
                                      widget.workOutData.workDate.toString(),
                                      widget.workOutData,
                                      widget.index);
                                }
                              }
                            }*/

                      child: ButtonWidget(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 45,
                        containerColor: ColorResources.COLOR_BLUE,
                        color: Colors.white,
                        text: 'Actions'.tr,
                      ),
                    ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: FittedTextFieldContainer(
                        calculator: FittedTextFieldCalculator.fitAll,
                        child: TextField(
                          cursorColor: ColorResources.COLOR_NORMAL_BLACK,
                          style: const TextStyle(
                            fontSize: 16,
                            color: ColorResources.COLOR_NORMAL_BLACK,
                          ),
                          controller: _workOutController,
                          onChanged: (value) {
                            isBtnBlue.value = true;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            hintText: "Workout Title".tr,
                            errorStyle: const TextStyle(fontSize: 0, height: 0),
                            border: InputBorder.none,
                            hintStyle: const TextStyle(
                              color: ColorResources.INPUT_HINT_COLOR,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          enableDrag: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext context) {
                            return EditBottomSheet(
                              context: context,
                              isWorkOut: true,
                              index: widget.index,
                              workOutData: widget.workOutData,
                              callback: (value) {
                                if (value) {
                                  print('hello');
                                }
                                setState(() {});
                              },
                            );
                          },
                        );
                      },
                      child: ButtonWidget(
                        text: "Settings".tr,
                        width: 100,
                        height: 38,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/calendar.svg',
                            color: ColorResources.INPUT_HINT_ICON,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.workout[widget.index].wDate != null &&
                                    widget.workout[widget.index].startTime != null &&
                                    widget.workout[widget.index].duration != "00:00" &&
                                    widget.workout[widget.index].duration != ":"
                                ? "${DateFormat('dd.MM').format(DateTime.parse(widget.workout[widget.index].wDate.toString()))}  ${widget.workout[widget.index].startTime} - ${widget.workout[widget.index].endTime}"
                                : "${DateFormat('dd.MM').format(DateTime.parse(widget.workout[widget.index].wDate.toString()))}  ${widget.workout[widget.index].startTime}",
                            style: sFProDisplayRegular.copyWith(fontSize: 16, color: ColorResources.INPUT_HINT_ICON),
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/notification.svg',
                            color: ColorResources.INPUT_HINT_ICON,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            _notification[int.parse(widget.workout[widget.index].notify.toString())],
                            style: sFProDisplayRegular.copyWith(fontSize: 16, color: ColorResources.INPUT_HINT_ICON),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.to(() => AddExerciseScreen(
                            fromUpdate: true,
                            updateList: userList,
                            mainIndex: widget.index,
                            workOutData: widget.workOutData,
                            callback: () {
                              setState(() {});
                            },
                          ));
                    },
                    child: Text(
                      "+ Add exercise".tr,
                      style: sFProDisplayRegular.copyWith(fontSize: 16, color: ColorResources.COLOR_BLUE),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(
                thickness: 1,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: ReorderableListView(
                    scrollController: listViewScroller,
                    onReorder: (int oldIndex, int newIndex) async {
                      if (newIndex != userList.length && newIndex != 0) {
                        if (userList[newIndex].isItemSelect == true) {
                          if (kDebugMode) {
                            print('cant move');
                          }
                          return;
                        }
                      }
                      if (newIndex > oldIndex) newIndex--;
                      final item = userList.removeAt(oldIndex);
                      userList.insert(newIndex, item);
                      for (var i = 0; i < userList.length; i++) {
                        for (var item in userList[i].items) {
                          (item as DairyWidgetTwo).parrentindex = i;
                          (item).indexValue = indexValue;
                        }
                      }
                      try {
                        widget.workOutData.workOut![widget.index].addedExercise!.clear();
                        widget.workOutData.workOut![widget.index].addedExercise!.addAll(userList);
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(GetStorage().read('user').toString())
                            .collection('Workouts')
                            .doc(widget.workOutData.workDate.toString())
                            .update(widget.workOutData.toJson())
                            .then((value) {
                              print("Successfully Saved");
                            })
                            .timeout(const Duration(seconds: 5))
                            .catchError((e) {
                              if (kDebugMode) {
                                print(e);
                              }
                              showToast(e.message.toString());
                            });
                      } on FirebaseException catch (e) {
                        showToast(e.message.toString());
                      }
                    },
                    children: _getListItems(userList),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getListItems(List<UserList> value) => value.asMap().map((i, item) => MapEntry(i, _buildTenableListTile(item, i))).values.toList();

  Widget _buildTenableListTile(UserList item, int i) {
    setvalue(i);
    return SingleChildScrollView(
      key: ValueKey(i),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                setState(() {
                  userList.remove(userList[i]);
                  for (var i = 0; i < userList.length; i++) {
                    for (var item in userList[i].items) {
                      (item as DairyWidgetTwo).parrentindex = i;
                      (item).indexValue = indexValue;
                    }
                  }
                });
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete'.tr,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ReorderableDragStartListener(
                          index: i,
                          enabled: userList[i].isItemSelect == true ? false : true,
                          child: SvgPicture.asset(
                            'assets/more.svg',
                            width: 20,
                          )),
                      isOpenSuperSet == true
                          ? SizedBox(
                              width: 40,
                              height: 50,
                              child: GestureDetector(
                                child: CustomCheckBox(
                                  index: i,
                                  isSelected: userList[i].isItemSelect == false ? false : true,
                                  callback: (value) {
                                    if (value) {
                                      setState(() {
                                        userList[i].isItemSelect = true;
                                        List<UserList> sList = userList.where((element) => element.isItemSelect == true).toList();
                                        List<UserList> unList = userList.where((element) => element.isItemSelect == false).toList();
                                        userList.clear();
                                        setState(() {
                                          userList.addAll(unList);
                                          userList.addAll(sList);
                                        });
                                      });
                                    } else {
                                      setState(() {
                                        userList[i].isItemSelect = false;
                                        /*(userList[i].items.where(
                                                                  (element) => (element
                                                                              as DairyWidgetTwo)
                                                                          .userList[i]
                                                                          .isItemSelect =
                                                                      false));*/
                                      });
                                    }
                                  },
                                ),
                              ))
                          : Container(),
                      userList[i].isItemSelect == true
                          ? Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ExerciseDetail(
                                                id: userList[i].title.toString(),
                                                categoryId: userList[i].subcategoriesId.toString(),
                                              )));
                                },
                                child: Row(
                                  children: [
                                    CustomContainer(
                                      child: SizedBox(
                                        width: 45,
                                        height: 45,
                                        child: SvgPicture.asset(
                                          getGenderPathString(userList[i].image.toString()),
                                        ),
                                      ),
                                      value: userList[i].selectedIndex == 0 && isSuperSetDone == true
                                          ? CustomContainer.TOP
                                          : userList[i].selectedIndex == indexValue - 1 &&
                                                  (userList[i].isDownData == false && isSuperSetDone == true ||
                                                      userList[i].isDownData == true && isOpenSuperSet == true)
                                              ? CustomContainer.BOTTOM
                                              : isSuperSetDone == true
                                                  ? CustomContainer.MID
                                                  : 4,
                                      height: 70,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        userList[i].title.toString().tr,
                                        maxLines: 3,
                                        textAlign: TextAlign.start,
                                        style: sFProDisplayRegular.copyWith(fontSize: 16, color: ColorResources.COLOR_NORMAL_BLACK),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ExerciseDetail(
                                                id: userList[i].title.toString(),
                                                categoryId: userList[i].subcategoriesId.toString(),
                                              )));
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 45,
                                      height: 45,
                                      child: SvgPicture.asset(
                                        getGenderPathString(userList[i].image.toString()),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        userList[i].title.toString().tr,
                                        maxLines: 3,
                                        textAlign: TextAlign.start,
                                        style: sFProDisplayRegular.copyWith(fontSize: 16, color: ColorResources.COLOR_NORMAL_BLACK),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      InkWell(
                        onTap: () {
                          if (userList[i].isDownData == false) {
                            setState(() {
                              userList[i].isDownData = true;
                            });
                            // listViewScroller.jumpTo(((i+(i==0?0:((userList[i].dairy?.length??0)+1)))*(Get.height*0.04)));
                          } else {
                            setState(() {
                              userList[i].isDownData = false;
                            });
                          }
                        },
                        child: isOpenSuperSet
                            ? const SizedBox(
                                height: 70,
                                width: 30,
                              )
                            : SizedBox(
                                width: 30,
                                height: 70,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      userList[i].isDownData == true ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down_outlined,
                                      color: ColorResources.COLOR_NORMAL_BLACK,
                                    )),
                              ),
                      ),
                    ],
                  ),
                  userList[i].isDownData == true && !isOpenSuperSet
                      ? Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 3),
                          child: ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: userList[i].items.isEmpty ? [const SizedBox()] : userList[i].items,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setvalue(int i) async {
    if (userList.isNotEmpty) {
      if (userList[i].items == null || userList[i].items.isEmpty) {
        userList[i].items = [];
        TextEditingController w = TextEditingController();
        TextEditingController r = TextEditingController();
        Timer timer = Timer(const Duration(milliseconds: 100), () {});
        List<UserHistoryModel> history = [];
        Dairy dairy = Dairy(history: history);
        List.generate(
          userList[i].dairy!.isNotEmpty ? userList[i].dairy!.length : 1,
          (index) {
            if (userList[i].dairy!.isNotEmpty) {
              TextEditingController w = TextEditingController();
              TextEditingController r = TextEditingController();
              Timer timer = Timer(const Duration(milliseconds: 100), () {});
              List<UserHistoryModel> history = [];
              Dairy dairy = Dairy(history: history);
              w.text = userList[i].dairy![index].weight!.toString();
              r.text = userList[i].dairy![index].reps.toString();

              return userList[i].items.add(
                    DairyWidgetTwo(
                      onSetAdd: () {
                        // listViewScroller.jumpTo(listViewScroller.position.pixels + (Get.height * 0.04));
                      },
                      parrentindex: i,
                      conNew: conNew,
                      indexValue: indexValue,
                      i: userList[i].items.length,
                      isOpenSuperSet: isOpenSuperSet,
                      conResp: r,
                      conWeight: w,
                      elapsedTime: userList[i].dairy![index].time.toString(),
                      timer: timer,
                      startStop: true,
                      dairy: dairy,
                      userList: userList,
                      workOutData: widget.workOutData,
                      workOutDataIndex: widget.index,
                      cameFrom: true,
                      isAddData: userList[i].dairy![index].isAddData!,
                      // isAddData: false,
                      //isFilledBlue: false,
                      isFilledBlue: userList[i].dairy![index].tick!,
                    ),
                  );
            }
            userList[i].dairy!.add(UserHistoryModel(
                  time: '00:00',
                  tick: false,
                  reps: r.text,
                  weight: w.text,
                  playBtn: true,
                  number: (userList[i].items.length + 1).toString(),
                  id: (userList[i].items.length + 1).toString(),
                  isAddData: false,
                  workOutId:
                      '${widget.workOutData.workOut![widget.index].wId.toString()}${widget.workOutData.workOut![widget.index].wDate.toString()}${userList[i].items.length}${userList[i].id}',
                  type: userList[i].title,
                  exeIndexId: i.toString(),
                ));
            return userList[i].items.add(
                  DairyWidgetTwo(
                    onSetAdd: () {
                      // listViewScroller.jumpTo(listViewScroller.position.pixels + (Get.height * 0.04));
                    },
                    parrentindex: i,
                    conNew: conNew,
                    indexValue: indexValue,
                    i: userList[i].items.length,
                    isOpenSuperSet: isOpenSuperSet,
                    conResp: r,
                    conWeight: w,
                    elapsedTime: '00:00',
                    timer: timer,
                    startStop: true,
                    dairy: dairy,
                    userList: userList,
                    workOutData: widget.workOutData,
                    workOutDataIndex: widget.index,
                    cameFrom: true,
                    isFilledBlue: false,
                    isAddData: false,
                  ),
                );
          },
        );
      }
    }
  }
}
