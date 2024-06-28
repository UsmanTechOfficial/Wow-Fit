import 'dart:async';
import 'dart:io';

import 'package:fitted_text_field_container/fitted_text_field_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:wowfit/BottomSheet/editBottomSheet.dart';
import 'package:wowfit/Home/BottomNavigation/bottomNavigationScreen.dart';
import 'package:wowfit/Utils/color_resources.dart';
import 'package:wowfit/Utils/styles.dart';
import 'package:wowfit/Widgets/CustomCheckBox.dart';
import 'package:wowfit/Widgets/buttonWidget.dart';
import 'package:wowfit/Widgets/customContainer.dart';
import 'package:wowfit/WorkoutScreen/DetailExercise/exerciseDetail.dart';

import '../Models/WorkOutModel.dart';
import '../Models/userAddedExcercise.dart';
import '../Models/userHistoryModel.dart';
import '../Utils/image_utils.dart';
import '../Widgets/dairyWidget2.dart';
import '../controller/newWorkoutController.dart';
import 'addExerciseScreen.dart';

var userList = <UserList>[
  /*UserList("assets/chest.png", "Pectoral muscles", false, false, false, false,
      false, 0),
  UserList(
      "assets/arm.png", "Arm muscles", false, false, false, false, false, 1),
  UserList("assets/shoulder.png", "Shoulder muscles", false, false, false,
      false, false, 2),
  UserList(
      "assets/leg.png", "Leg muscles", false, false, false, false, false, 3),
  UserList("assets/aabs.png", "Press", false, false, false, false, false, 4),*/
].obs;

class WorkOutScreen extends StatefulWidget {
  final NewWorkOutController? controller;
  final bool openFromShare;

  const WorkOutScreen({Key? key, required this.controller, required this.openFromShare}) : super(key: key);

  @override
  State<WorkOutScreen> createState() => _WorkOutScreenState();
}

class _WorkOutScreenState extends State<WorkOutScreen> {
  final TextEditingController _workOutController = TextEditingController();
  NewWorkOutController con = Get.put(NewWorkOutController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isOpenSuperSet = false;
  bool allowDrag = true;
  var showBlue = false.obs;
  bool isSuperSetBtnPress = false;
  bool hide = false;
  bool isDown = false;
  List<UserList> newSupersetList = [];
  List<UserList> unSelectedList = [];
  double length = 0.0;
  int lastIndex = 0;
  int indexValue = 0;
  bool detailAdded = false;
  bool isSuperSetDone = false;
  var rotateBtn = 0.obs;
  bool showSpinner = false;
  final ScrollController listViewScroller = ScrollController();

  final List<String> _notification = [
    'Do not notify'.tr,
    'In 30 minutes'.tr,
    'In 1 hour'.tr,
    'In 12 hours'.tr,
  ];

  updateCustomContainer() {
    if (newSupersetList.isNotEmpty && unSelectedList.isNotEmpty) {
      newSupersetList.clear();
      unSelectedList.clear();
    }
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
      userList.addAll(unSelectedList);
      userList.addAll(newSupersetList);
      print("===========>seleted Length${newSupersetList.length}");
      lastIndex = userList.length - 1;
      print(lastIndex);
      for (var item in userList) {
        item.selectedIndexLength = newSupersetList.length;
      }
      // length = unSelectedList.length / 10;
      //hide = true;
      detailAdded = true;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.controller != null) {
        con = widget.controller!;
        if (userList != null) {
          userList.clear();
          userList.addAll(widget.controller!.workout.addedExercise!);
        }
        _workOutController.text = widget.controller!.workout.workOutTitleName ?? "";
        updateCustomContainer();
      } else {
        con = Get.put(NewWorkOutController());
      }
    });

    /*if (userList.isNotEmpty) {
      for (int i = 0; i < userList.length; i++) {
        setState(() {
          userList[i].items.add(DairyWidget(
              userList: userList,
              isOpenSuperSet: isOpenSuperSet,
              i: i,
              indexValue: indexValue,
              con: con));
        });
      }
    }*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        con.workOutData = WorkOutData();
        con.workout = WorkOutModel();
        userList.clear();
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
          key: scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "New workout".tr,
              style: sFProDisplayRegular.copyWith(fontSize: 18, color: ColorResources.COLOR_NORMAL_BLACK),
            ),
            leading: InkWell(
              onTap: () {
                if (widget.openFromShare) {
                  con.workOutData = WorkOutData();
                  con.workout = WorkOutModel();
                  userList.clear();
                  Get.offAll(() => BottomNavigationScreen(
                        index: 0,
                      ));
                } else {
                  con.workOutData = WorkOutData();
                  con.workout = WorkOutModel();
                  userList.clear();
                  Get.back();
                }
              },
              child: const Icon(
                Icons.arrow_back_ios,
                size: 18,
                color: ColorResources.COLOR_NORMAL_BLACK,
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(left: 30, right: 25, top: 10, bottom: Platform.isIOS ? 25 : 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (isOpenSuperSet == false) {
                      int index = 0;
                      rotateBtn.value = 45;
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
                        isOpenSuperSet = true;
                        isSuperSetDone = false;
                        allowDrag = false;
                      });
                    } else {
                      /*if (newSupersetList.isNotEmpty) {
                        setState(() {
                          isSuperSetDone = true;
                        });
                      } else {
                        if (isSuperSetDone == false) {
                          for (var element in userList) {
                            element.isItemSelect = false;
                          }
                        }
                      }*/
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
                          setState(() {
                            isOpenSuperSet = true;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select more than 1'.tr)));
                        } else {
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
                          userList.addAll(unSelectedList);
                          userList.addAll(newSupersetList);
                          lastIndex = userList.length - 1;
                          print(lastIndex);
                          for (var item in userList) {
                            item.selectedIndexLength = newSupersetList.length;
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
                          setState(() {
                            isOpenSuperSet = false;
                          });
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
                GestureDetector(
                  onTap:
                      /*isOpenSuperSet == true
                      ? () {
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
                                isSuperSetDone = false;
                                indexValue = newSupersetList.length;
                                print('newsuper $indexValue');
                                allowDrag = false;
                              } else {
                                isSuperSetDone = false;
                                allowDrag = true;
                              }
                              userList.addAll(unSelectedList);
                              userList.addAll(newSupersetList);
                              lastIndex = userList.length - 1;
                              print(lastIndex);
                              */ /*for (var item in userList) {
                                  item.selectedIndexLength =
                                      newSupersetList.length;
                                }*/ /*
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
                            }
                          }
                        }
                      :*/
                      () async {
                    if (!showSpinner) {
                      setState(() {
                        showSpinner = true;
                      });
                    }
                    con
                        .uploadData(_workOutController.text, context, detailAdded, widget.openFromShare,
                            con.workout.notify != null ? con.workout.notify.toString() : '0')
                        .then((value) {
                      if (value) {
                        setState(() {
                          showSpinner = false;
                        });
                        showBlue.value = false;
                        Get.offAll(() => BottomNavigationScreen(
                              index: 0,
                            ));
                      } else {
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    });
                  },
                  child: ButtonWidget(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 45,
                    color: showBlue.value ? Colors.white : null,
                    containerColor: showBlue.value ? ColorResources.COLOR_BLUE : null,
                    text: 'Create'.tr,
                  ),
                ),
              ],
            ),
          ),
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Column(
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
                            onChanged: (value) {
                              setState(() {
                                con.workout.workOutTitleName = value;
                              });

                              showBlue.value = true;
                            },
                            controller: _workOutController,
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
                          final GlobalKey<ScaffoldState> modelScaffoldKey = GlobalKey<ScaffoldState>();
                          showModalBottomSheet(
                            isScrollControlled: true,
                            enableDrag: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(builder: (newcontext, bottomSheetState) {
                                return EditBottomSheet(
                                  context: newcontext,
                                  bottomSheetState: bottomSheetState,
                                  workout: con.workout,
                                  isWorkOut: false,
                                  callback: (value) {
                                    setState(() {
                                      detailAdded = value;
                                    });
                                    if (detailAdded) {
                                      showBlue.value = true;
                                    }
                                  },
                                );
                              });
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
                if (con.workout.wDate != null && con.workout.startTime != null && con.workout.endTime != null && con.workout.notify != null)
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
                                con.workout.wDate != null &&
                                        con.workout.startTime != null &&
                                        con.workout.duration != "00:00" &&
                                        con.workout.duration != ":"
                                    ? "${DateFormat('dd.MM').format(DateTime.parse(con.workout.wDate.toString()))}  ${con.workout.startTime} - ${con.workout.endTime ?? ''}"
                                    : "${DateFormat('dd.MM').format(DateTime.parse(con.workout.wDate.toString()))}  ${con.workout.startTime}",
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
                                con.workout.notify != null ? _notification[int.parse(con.workout.notify.toString())].tr : 'Notification'.tr,
                                style: sFProDisplayRegular.copyWith(fontSize: 16, color: ColorResources.INPUT_HINT_ICON),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (con.workout.wDate != null && con.workout.startTime != null && con.workout.endTime != null && con.workout.notify != null)
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddExerciseScreen(
                                      fromUpdate: false,
                                    )));
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
                      onReorder: (int oldIndex, int newIndex) {
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
                      },
                      children: _getListItems(),
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
      ),
    );
  }

  List<Widget> _getListItems() => userList.asMap().map((i, item) => MapEntry(i, _buildTenableListTile(item, i))).values.toList();

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
                            // listViewScroller.jumpTo(((i + (i == 0 ? 0 : ((userList[i].dairy?.length ?? 0) + 1))) * (Get.width * 0.1)));
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

  void setvalue(int i) {
    if (userList.isNotEmpty) {
      if (userList[i].items == null || userList[i].items.isEmpty) {
        userList[i].items = [];
        TextEditingController weight = TextEditingController();
        TextEditingController resp = TextEditingController();
        Timer timer = Timer(const Duration(milliseconds: 100), () {});
        List<UserHistoryModel> history = [];
        Dairy dairy = Dairy(history: history);
        userList[i].dairy!.add(UserHistoryModel(
              time: '00:00',
              tick: false,
              reps: weight.text,
              weight: resp.text,
              playBtn: true,
              number: (userList[i].items.length + 1).toString(),
              id: (userList[i].items.length + 1).toString(),
              isAddData: false,
              workOutId:
                  con.workout.wId.toString() + con.workout.wDate.toString() + (userList[i].items.length).toString() + userList[i].id.toString(),
              exeIndexId: i.toString(),
              type: userList[i].title.toString(),
            ));
        userList[i].items.add(DairyWidgetTwo(
              onSetAdd: () {
                // listViewScroller.jumpTo(((i + (i == 0 ? 0 : ((userList[i].dairy?.length ?? 0) + 1))) * (Get.width * 0.1)));
              },
              parrentindex: i,
              conNew: con,
              indexValue: indexValue,
              i: userList[i].items.length,
              isOpenSuperSet: isOpenSuperSet,
              conWeight: weight,
              conResp: resp,
              timer: timer,
              elapsedTime: '00:00',
              startStop: true,
              dairy: dairy,
              userList: userList,
              cameFrom: false,
              isAddData: false,
              isFilledBlue: false,
              //isFilledBlue: false,
              // workOutData: widget.workOutData, workOutDataIndex: widget.workOutDataIndex,
            ));
      }
    }
  }
}
