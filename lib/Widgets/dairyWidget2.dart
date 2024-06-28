import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:wowfit/Models/userHistoryModel.dart';
import 'package:wowfit/Widgets/timeInputField.dart';

import '../Models/WorkOutModel.dart';
import '../Models/userAddedExcercise.dart';
import '../Utils/color_resources.dart';
import '../Utils/showtoaist.dart';
import '../Utils/styles.dart';
import '../WorkoutScreen/viewWorkOutScreen.dart';
import '../controller/newWorkoutController.dart';
import 'customContainer.dart';

class DairyWidgetTwo extends StatefulWidget {
  Function()? callback;
  bool isOpenSuperSet;
  int i;
  int indexValue = 0;
  int parrentindex;
  int? workOutDataIndex;
  bool cameFrom = false;
  WorkOutData? workOutData;
  List<UserList> userList;
  TextEditingController conWeight;
  TextEditingController conResp;
  NewWorkOutController conNew;
  bool isFilledBlue;
  bool isAddData = false;
  Stopwatch watch = Stopwatch();
  Timer timer;
  Dairy dairy;
  bool startStop = true;
  String elapsedTime = '00:00';
  Function() onSetAdd;

  DairyWidgetTwo(
      {Key? key,
      this.callback,
      required this.conWeight,
      required this.conResp,
      required this.isOpenSuperSet,
      required this.i,
      required this.timer,
      required this.startStop,
      required this.elapsedTime,
      required this.indexValue,
      required this.parrentindex,
      required this.userList,
      required this.conNew,
      required this.cameFrom,
      required this.dairy,
      this.workOutData,
      required this.isFilledBlue,
      required this.isAddData,
      this.workOutDataIndex,
      required this.onSetAdd})
      : super(key: key);

  @override
  State<DairyWidgetTwo> createState() => _DairyWidgetTwoState();
}

class _DairyWidgetTwoState extends State<DairyWidgetTwo> {
  @override
  Widget build(BuildContext context) {
    // print(widget.parrentindex.toString() + "/" + widget.indexValue.toString());
    return Padding(
      padding: widget.userList[widget.parrentindex].isItemSelect == false
          ? const EdgeInsets.only(left: 2, bottom: 5)
          : const EdgeInsets.only(left: 0, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.userList[widget.parrentindex].isItemSelect == false
              ? Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Container(
                    height: 36,
                    width: 35,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                        color: const Color(0xFF767680).withOpacity(0.12),
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        (widget.i + 1).toString(),
                        style: sFProDisplayMedium.copyWith(fontSize: 18, color: ColorResources.COLOR_NORMAL_BLACK),
                      ),
                    ),
                  ),
                )
              : CustomContainer(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 13, left: 5, right: 5, bottom: 10),
                    child: Container(
                      height: 36,
                      width: 35,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: const Color(0xFF767680).withOpacity(0.12),
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          (widget.i + 1).toString(),
                          style: sFProDisplayMedium.copyWith(fontSize: 22, color: ColorResources.COLOR_NORMAL_BLACK),
                        ),
                      ),
                    ),
                  ),
                  value: getValue(),
                  height: 60,
                ),
          if (widget.userList[widget.parrentindex].subcategoriesId != '4' && widget.userList[widget.parrentindex].subcategoriesId != '9')
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5, right: 10, left: 20),
                child: Container(
                  decoration: BoxDecoration(
                      color: ColorResources.INPUT_BORDER,
                      border: Border.all(color: ColorResources.INPUT_BORDER),
                      borderRadius: BorderRadius.circular(5)),
                  height: 35,
                  width: widget.userList[widget.parrentindex].subcategoriesId == '1' ? 90 : 65,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: TimeInputFields(
                        widget.userList[widget.parrentindex].subcategoriesId == '1' ? "distance".tr : "weight".tr,
                        "error".tr,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textInputAction: TextInputAction.done,
                        controller: widget.conWeight,
                        inputFormator: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                        ],
                        callback: (value) {
                          // widget.conWeight.text = value;
                          //widget.dairy.history!.weight = value;

                          if (widget.cameFrom) {
                            isBtnBlue.value = true;
                          }

                          if (widget.userList[widget.parrentindex].dairy!.isNotEmpty) {
                            int index =
                                widget.userList[widget.parrentindex].dairy!.indexWhere((element) => (int.parse(element.number!) - 1) == widget.i);

                            if (index == -1) {
                              widget.userList[widget.parrentindex].dairy!.add(UserHistoryModel(
                                time: widget.elapsedTime,
                                tick: false,
                                reps: widget.conResp.text,
                                weight: widget.conWeight.text,
                                playBtn: widget.startStop,
                                number: (widget.i + 1).toString(),
                                id: (widget.i + 1).toString(),
                                isAddData: true,
                              ));
                            } else {
                              if (kDebugMode) {
                                print('indexWhere $index');
                              }
                              widget.userList[widget.parrentindex].dairy![index].weight = widget.conWeight.text;
                            }
                          } else {
                            widget.userList[widget.parrentindex].dairy!.add(UserHistoryModel(
                              time: widget.elapsedTime,
                              tick: false,
                              reps: widget.conResp.text,
                              weight: widget.conWeight.text,
                              playBtn: widget.startStop,
                              number: (widget.i + 1).toString(),
                              id: (widget.i + 1).toString(),
                              isAddData: false,
                            ));
                          }

                          /*widget.conNew.history.dairy.add()*/
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (widget.userList[widget.parrentindex].subcategoriesId != '1' &&
              widget.userList[widget.parrentindex].subcategoriesId != '4' &&
              widget.userList[widget.parrentindex].subcategoriesId != '9')
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5, right: 20, left: 10),
                child: Container(
                  decoration: BoxDecoration(
                      color: ColorResources.INPUT_BORDER,
                      border: Border.all(color: ColorResources.INPUT_BORDER),
                      borderRadius: BorderRadius.circular(5)),
                  height: 35,
                  width: 65,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: TimeInputFields(
                        "reps".tr,
                        "your email".tr,
                        isEmail: true,
                        controller: widget.conResp,
                        textInputAction: TextInputAction.done,
                        inputFormator: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        callback: (value) {
                          if (widget.cameFrom) {
                            isBtnBlue.value = true;
                          }

                          if (widget.userList[widget.parrentindex].dairy!.isNotEmpty) {
                            int index =
                                widget.userList[widget.parrentindex].dairy!.indexWhere((element) => (int.parse(element.number!) - 1) == widget.i);

                            if (index == -1) {
                              widget.userList[widget.parrentindex].dairy!.add(UserHistoryModel(
                                time: widget.elapsedTime,
                                tick: false,
                                reps: widget.conResp.text,
                                weight: widget.conWeight.text,
                                playBtn: widget.startStop,
                                number: (widget.i + 1).toString(),
                                id: (widget.i + 1).toString(),
                                isAddData: true,
                              ));
                            } else {
                              if (kDebugMode) {
                                print('indexWhere $index');
                              }
                              widget.userList[widget.parrentindex].dairy![index].reps = widget.conResp.text;
                            }
                          } else {
                            widget.userList[widget.parrentindex].dairy!.add(UserHistoryModel(
                              time: widget.elapsedTime,
                              tick: false,
                              reps: widget.conResp.text,
                              weight: widget.conWeight.text,
                              playBtn: widget.startStop,
                              number: (widget.i + 1).toString(),
                              id: (widget.i + 1).toString(),
                              isAddData: false,
                            ));
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (widget.userList[widget.parrentindex].subcategoriesId == '1' ||
              widget.userList[widget.parrentindex].subcategoriesId == '4' ||
              widget.userList[widget.parrentindex].subcategoriesId == '9')
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: InkWell(
                  onTap: () {
                    Picker(
                      adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
                        NumberPickerColumn(begin: 0, end: 10, suffix: Text('hours'.tr)),
                        NumberPickerColumn(begin: 0, end: 60, suffix: Text('minutes'.tr), jump: 1),
                      ]),
                      delimiter: <PickerDelimiter>[
                        PickerDelimiter(
                          child: Container(
                            width: 30.0,
                            alignment: Alignment.center,
                            child: Icon(Icons.more_vert),
                          ),
                        )
                      ],
                      hideHeader: true,
                      confirmText: 'Okay'.tr,
                      confirmTextStyle: TextStyle(color: ColorResources.COLOR_BLUE),
                      title: Text('Duration'.tr),
                      cancelText: 'Cancel'.tr,
                      cancelTextStyle: TextStyle(color: Colors.red),
                      selectedTextStyle: TextStyle(color: ColorResources.COLOR_BLUE),
                      onConfirm: (Picker picker, List<int> value) {
                        // You get your duration here
                        NumberFormat formatter = NumberFormat("00");

                        setState(() {
                          widget.elapsedTime =
                              "${formatter.format(picker.getSelectedValues()[0])}:${formatter.format(picker.getSelectedValues()[1])}";
                        });
                        if (widget.userList[widget.parrentindex].dairy!.isNotEmpty) {
                          int index =
                              widget.userList[widget.parrentindex].dairy!.indexWhere((element) => (int.parse(element.number!) - 1) == widget.i);

                          if (index == -1) {
                            widget.userList[widget.parrentindex].dairy!.add(UserHistoryModel(
                              time: widget.elapsedTime,
                              tick: false,
                              reps: widget.conResp.text,
                              weight: widget.conWeight.text,
                              playBtn: widget.startStop,
                              number: (widget.i + 1).toString(),
                              id: (widget.i + 1).toString(),
                              isAddData: true,
                            ));
                          } else {
                            if (kDebugMode) {
                              print('indexWhere $index');
                            }
                            widget.userList[widget.parrentindex].dairy![index].time = widget.elapsedTime;
                          }
                        } else {
                          widget.userList[widget.parrentindex].dairy!.add(UserHistoryModel(
                            time: widget.elapsedTime,
                            tick: false,
                            reps: widget.conResp.text,
                            weight: widget.conWeight.text,
                            playBtn: widget.startStop,
                            number: (widget.i + 1).toString(),
                            id: (widget.i + 1).toString(),
                            isAddData: false,
                          ));
                        }
                        isBtnBlue.value = true;
                      },
                    ).showDialog(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: ColorResources.INPUT_BORDER, width: 1),
                        borderRadius: BorderRadius.circular(5)),
                    height: 35,
                    width: 65,
                    child: Center(
                      child: Text(
                        widget.elapsedTime,
                        style: sFProDisplayRegular.copyWith(fontSize: 20, color: ColorResources.LIGHT_TITLE_TEXT),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: (widget.userList[widget.parrentindex].items[widget.i] as DairyWidgetTwo).isFilledBlue == true &&
                    widget.i != widget.userList[widget.parrentindex].items.length - 1
                ? InkWell(
                    onTap: () async {
                      setState(() {
                        if (widget.i == widget.userList[widget.parrentindex].items.length - 1) {
                          TextEditingController w = TextEditingController();
                          TextEditingController r = TextEditingController();
                          Timer timer = Timer(const Duration(milliseconds: 100), () {});
                          List<UserHistoryModel> history = [];
                          Dairy dairy = Dairy(history: history);
                          widget.userList[widget.parrentindex].items.add(
                            DairyWidgetTwo(
                              dairy: dairy,
                              parrentindex: widget.parrentindex,
                              conNew: widget.conNew,
                              indexValue: widget.indexValue,
                              i: widget.userList[widget.parrentindex].items.length,
                              isOpenSuperSet: widget.isOpenSuperSet,
                              conResp: w,
                              conWeight: r,
                              elapsedTime: '00:00',
                              startStop: true,
                              timer: timer,
                              userList: widget.userList,
                              workOutData: widget.workOutData,
                              workOutDataIndex: widget.workOutDataIndex,
                              cameFrom: widget.cameFrom,
                              isAddData: false,
                              isFilledBlue: false,
                              onSetAdd: widget.onSetAdd,
                              // isFilledBlue: widget.isFilledBlue,
                            ),
                          );
                        } else {
                          setState(() {
                            (widget.userList[widget.parrentindex].items[widget.i] as DairyWidgetTwo).isFilledBlue = false;
                          });
                          int index =
                              widget.userList[widget.parrentindex].dairy!.indexWhere((element) => (int.parse(element.number!) - 1) == widget.i);
                          if (index != -1) {
                            widget.userList[widget.parrentindex].dairy![index].tick = false;
                            widget.userList[widget.parrentindex].dairy![index].isAddData = false;
                          }
                          widget.conNew.deleteHistoryData(widget.userList[widget.parrentindex].title.toString(),
                              widget.userList[widget.parrentindex].dairy![(widget.i + 1)], widget.i, widget.workOutData?.workDate.toString());
                        }
                      });
                      if (widget.cameFrom && (widget.userList[widget.parrentindex].items[widget.i] as DairyWidgetTwo).isFilledBlue == false) {
                        int index = widget.userList[widget.parrentindex].dairy!.indexWhere((element) => (int.parse(element.number!) - 1) == widget.i);
                        if (index != -1) {
                          widget.userList[widget.parrentindex].dairy![index].tick = false;
                          widget.userList[widget.parrentindex].dairy![index].isAddData = false;
                        }
                        try {
                          widget.workOutData!.workOut![widget.workOutDataIndex!].addedExercise!.clear();
                          widget.workOutData!.workOut![widget.workOutDataIndex!].addedExercise!.addAll(widget.userList);
                          await FirebaseFirestore.instance
                              .collection('Users')
                              .doc(GetStorage().read('user').toString())
                              .collection('Workouts')
                              .doc(widget.workOutData!.workDate.toString())
                              .update(widget.workOutData!.toJson())
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
                      }
                    },
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: ColorResources.COLOR_BLUE,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: SvgPicture.asset(
                          "assets/check.svg",
                          color: Colors.white,
                        ),
                      )),
                    ),
                  )
                : InkWell(
                    onTap: () async {
                      setState(() {
                        if (widget.i == widget.userList[widget.parrentindex].items.length - 1) {
                          if (widget.cameFrom == false && widget.conNew.workout.wDate == null && widget.conNew.workout.wId == null) {
                            showToast('Please complete workout details from settings'.tr);
                            return;
                          }
                          FocusScope.of(context).unfocus();
                          (widget.userList[widget.parrentindex].items[widget.i] as DairyWidgetTwo).isAddData = true;
                          TextEditingController w = TextEditingController(text: widget.conWeight.text);
                          TextEditingController r = TextEditingController(text: widget.conResp.text);
                          Timer timer = Timer(const Duration(milliseconds: 100), () {});
                          List<UserHistoryModel> history = [];
                          Dairy dairy = Dairy(history: history);
                          widget.userList[widget.parrentindex].items.add(
                            DairyWidgetTwo(
                              parrentindex: widget.parrentindex,
                              conNew: widget.conNew,
                              indexValue: widget.indexValue,
                              i: widget.userList[widget.parrentindex].items.length,
                              isOpenSuperSet: widget.isOpenSuperSet,
                              conWeight: w,
                              conResp: r,
                              startStop: true,
                              timer: timer,
                              elapsedTime: '00:00',
                              dairy: dairy,
                              userList: widget.userList,
                              workOutData: widget.workOutData,
                              workOutDataIndex: widget.workOutDataIndex,
                              cameFrom: widget.cameFrom,
                              isAddData: false,
                              isFilledBlue: false,
                              onSetAdd: widget.onSetAdd,
                              // isFilledBlue: widget.isFilledBlue,
                            ),
                          );
                          widget.userList[widget.parrentindex].dairy!.add(UserHistoryModel(
                            time: '00:00',
                            tick: false,
                            reps: r.text,
                            weight: w.text,
                            playBtn: true,
                            number: (widget.userList[widget.parrentindex].items.length).toString(),
                            exeIndexId: widget.parrentindex.toString(),
                            type: widget.userList[widget.parrentindex].title.toString(),
                            workOutId: widget.workOutData != null
                                ? '${widget.workOutData?.workOut![widget.workOutDataIndex!].wId.toString()}${widget.workOutData?.workOut![widget.workOutDataIndex!].wDate.toString()}${(widget.i).toString()}${widget.userList[widget.parrentindex].id}'
                                    .trim()
                                : '${widget.conNew.workout.wId.toString()}${widget.conNew.workout.wDate.toString()}${(widget.i).toString()}${widget.userList[widget.parrentindex].id}'
                                    .trim(),
                            isAddData: true,
                          ));
                          widget.onSetAdd();
                        } else {
                          if (widget.userList[widget.parrentindex].subcategoriesId != '1' &&
                              widget.userList[widget.parrentindex].subcategoriesId != '4') {
                            if (widget.conResp.text.isNotEmpty && widget.conWeight.text.isNotEmpty) {
                              print("Inside this 4");
                              setState(() {
                                (widget.userList[widget.parrentindex].items[widget.i] as DairyWidgetTwo).isFilledBlue = true;
                              });
                              String workDate;
                              if (widget.cameFrom) {
                                if (widget.workOutData!.workOut![widget.workOutDataIndex != null ? widget.workOutDataIndex! : 0].wDate != null) {
                                  workDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(
                                      widget.workOutData!.workOut![widget.workOutDataIndex != null ? widget.workOutDataIndex! : 0].wDate.toString()));
                                } else {
                                  return;
                                }
                              } else {
                                if (widget.conNew.workout.wDate != null && widget.conNew.workout.wId != null) {
                                  workDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.conNew.workout.wDate.toString()));
                                } else {
                                  setState(() {
                                    (widget.userList[widget.parrentindex].items[widget.i] as DairyWidgetTwo).isFilledBlue = false;
                                  });
                                  showToast('Please complete workout details from settings'.tr);
                                  return;
                                }
                              }
                              final date = DateTime.now();
                              String dateFormated = DateFormat("yyyy-MM-dd").format(date);
                              if (DateTime.parse(dateFormated).isAtSameMomentAs(DateTime.parse(workDate))) {
                                widget.dairy.date = dateFormated;
                                widget.dairy.history!.add(UserHistoryModel(
                                  time: widget.elapsedTime,
                                  tick: true,
                                  reps: widget.conResp.text,
                                  weight: widget.conWeight.text,
                                  playBtn: widget.startStop,
                                  number: (widget.i + 1).toString(),
                                  id: (widget.i + 1).toString(),
                                  exeIndexId: widget.parrentindex.toString(),
                                  type: widget.userList[widget.parrentindex].title.toString(),
                                  workOutId: widget.workOutData != null
                                      ? '${widget.workOutData?.workOut![widget.workOutDataIndex!].wId.toString()}${widget.workOutData?.workOut![widget.workOutDataIndex!].wDate.toString()}${(widget.i).toString()}${widget.userList[widget.parrentindex].id}'
                                          .trim()
                                      : '${widget.conNew.workout.wId.toString()}${widget.conNew.workout.wDate.toString()}${(widget.i).toString()}${widget.userList[widget.parrentindex].id}'
                                          .trim(),
                                  isAddData: true, // id: (widget.i + 1).toString(),
                                ));
                                widget.conNew.history.exerciseName = widget.userList[widget.parrentindex].title.toString();
                                widget.conNew.history.date = dateFormated;
                                widget.conNew.history.dairy!.add(widget.dairy);
                                if (widget.userList[widget.parrentindex].dairy!.isNotEmpty) {
                                  int index = widget.userList[widget.parrentindex].dairy!
                                      .indexWhere((element) => (int.parse(element.number!) - 1) == widget.i);

                                  if (index == -1) {
                                    widget.userList[widget.parrentindex].dairy!.add(UserHistoryModel(
                                      time: widget.elapsedTime,
                                      tick: true,
                                      reps: widget.conResp.text,
                                      weight: widget.conWeight.text,
                                      playBtn: widget.startStop,
                                      number: (widget.i + 1).toString(),
                                      id: (widget.i + 1).toString(),
                                      isAddData: true,
                                    ));
                                  } else {
                                    if (kDebugMode) {
                                      print('indexWhere $index');
                                    }

                                    widget.userList[widget.parrentindex].dairy![index].tick = true;
                                    widget.userList[widget.parrentindex].dairy![index].isAddData = true;
                                  }
                                } else {
                                  widget.userList[widget.parrentindex].dairy!.add(UserHistoryModel(
                                    time: widget.elapsedTime,
                                    tick: true,
                                    reps: widget.conResp.text,
                                    weight: widget.conWeight.text,
                                    playBtn: widget.startStop,
                                    number: (widget.i + 1).toString(),
                                    id: (widget.i + 1).toString(),
                                    isAddData: true,
                                  ));
                                }
                                widget.conNew
                                    .uploadHistoryData(widget.userList[widget.parrentindex].title.toString(), widget.conNew.history, widget.dairy)
                                    .then((value) async {
                                  widget.dairy.history!.clear();
                                  widget.conNew.history.dairy!.clear();
                                  if (widget.cameFrom) {
                                    try {
                                      widget.workOutData!.workOut![widget.workOutDataIndex!].addedExercise!.clear();
                                      widget.workOutData!.workOut![widget.workOutDataIndex!].addedExercise!.addAll(widget.userList);
                                      await FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc(GetStorage().read('user').toString())
                                          .collection('Workouts')
                                          .doc(widget.workOutData!.workDate.toString())
                                          .update(widget.workOutData!.toJson())
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
                                          .whenComplete(() => isBtnBlue.value = false);
                                    } on FirebaseException catch (e) {
                                      showToast(e.message.toString());
                                    }
                                  }
                                });
                              } else if (DateTime.parse(dateFormated).isAfter(DateTime.parse(workDate))) {
                                widget.dairy.date = workDate;
                                widget.dairy.history!.add(UserHistoryModel(
                                  time: widget.elapsedTime,
                                  tick: true,
                                  reps: widget.conResp.text,
                                  weight: widget.conWeight.text,
                                  playBtn: widget.startStop,
                                  number: (widget.i + 1).toString(),
                                  id: (widget.i + 1).toString(),
                                  exeIndexId: widget.parrentindex.toString(),
                                  type: widget.userList[widget.parrentindex].title.toString(),
                                  workOutId: widget.workOutData != null
                                      ? '${widget.workOutData?.workOut![widget.workOutDataIndex!].wId.toString()}${widget.workOutData?.workOut![widget.workOutDataIndex!].wDate.toString()}${(widget.i).toString()}${widget.userList[widget.parrentindex].id}'
                                          .trim()
                                      : '${widget.conNew.workout.wId.toString()}${widget.conNew.workout.wDate.toString()}${(widget.i).toString()}${widget.userList[widget.parrentindex].id}'
                                          .trim(),
                                  isAddData: true, // id: (widget.i + 1).toString(),
                                ));
                                widget.conNew.history.exerciseName = widget.userList[widget.parrentindex].title.toString();
                                widget.conNew.history.date = workDate;
                                widget.conNew.history.dairy!.add(widget.dairy);
                                if (widget.userList[widget.parrentindex].dairy!.isNotEmpty) {
                                  int index = widget.userList[widget.parrentindex].dairy!
                                      .indexWhere((element) => (int.parse(element.number!) - 1) == widget.i);

                                  if (index == -1) {
                                    widget.userList[widget.parrentindex].dairy!.add(UserHistoryModel(
                                      time: widget.elapsedTime,
                                      tick: true,
                                      reps: widget.conResp.text,
                                      weight: widget.conWeight.text,
                                      playBtn: widget.startStop,
                                      number: (widget.i + 1).toString(),
                                      id: (widget.i + 1).toString(),
                                      isAddData: true,
                                    ));
                                  } else {
                                    if (kDebugMode) {
                                      print('indexWhere $index');
                                    }

                                    widget.userList[widget.parrentindex].dairy![index].tick = true;
                                    widget.userList[widget.parrentindex].dairy![index].isAddData = true;
                                  }
                                } else {
                                  widget.userList[widget.parrentindex].dairy!.add(UserHistoryModel(
                                    time: widget.elapsedTime,
                                    tick: true,
                                    reps: widget.conResp.text,
                                    weight: widget.conWeight.text,
                                    playBtn: widget.startStop,
                                    number: (widget.i + 1).toString(),
                                    id: (widget.i + 1).toString(),
                                    isAddData: true,
                                  ));
                                }
                                widget.conNew
                                    .uploadHistoryData(widget.userList[widget.parrentindex].title.toString(), widget.conNew.history, widget.dairy)
                                    .then((value) async {
                                  widget.dairy.history!.clear();
                                  widget.conNew.history.dairy!.clear();
                                  if (widget.cameFrom) {
                                    try {
                                      widget.workOutData!.workOut![widget.workOutDataIndex!].addedExercise!.clear();
                                      widget.workOutData!.workOut![widget.workOutDataIndex!].addedExercise!.addAll(widget.userList);
                                      await FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc(GetStorage().read('user').toString())
                                          .collection('Workouts')
                                          .doc(widget.workOutData!.workDate.toString())
                                          .update(widget.workOutData!.toJson())
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
                                          .whenComplete(() => isBtnBlue.value = false);
                                    } on FirebaseException catch (e) {
                                      showToast(e.message.toString());
                                    }
                                  }
                                });
                              } else {
                                setState(() {
                                  (widget.userList[widget.parrentindex].items[widget.i] as DairyWidgetTwo).isFilledBlue = false;
                                });
                                showToast('${'You can use the exercise on this date'.tr} $workDate');
                              }
                            } else {
                              showToast('Please complete the exercise'.tr);
                            }
                          } else if (widget.userList[widget.parrentindex].subcategoriesId == '1') {
                            if (widget.conWeight.text.isNotEmpty) {
                              setState(() {
                                (widget.userList[widget.parrentindex].items[widget.i] as DairyWidgetTwo).isFilledBlue = true;
                              });
                              String workDate;
                              if (widget.cameFrom) {
                                if (widget.workOutData!.workOut![widget.workOutDataIndex != null ? widget.workOutDataIndex! : 0].wDate != null) {
                                  workDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(
                                      widget.workOutData!.workOut![widget.workOutDataIndex != null ? widget.workOutDataIndex! : 0].wDate.toString()));
                                } else {
                                  return;
                                }
                              } else {
                                if (widget.conNew.workout.wDate != null && widget.conNew.workout.wId != null) {
                                  workDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.conNew.workout.wDate.toString()));
                                } else {
                                  setState(() {
                                    (widget.userList[widget.parrentindex].items[widget.i] as DairyWidgetTwo).isFilledBlue = false;
                                  });
                                  showToast('Please complete workout details from settings'.tr);
                                  return;
                                }
                              }
                              final date = DateTime.now();
                              String dateFormated = DateFormat("yyyy-MM-dd").format(date);

                              if (DateTime.parse(dateFormated).isAtSameMomentAs(DateTime.parse(workDate))) {
                                widget.dairy.date = dateFormated;
                                widget.dairy.history!.add(UserHistoryModel(
                                  time: widget.elapsedTime,
                                  tick: true,
                                  reps: widget.conResp.text,
                                  weight: widget.conWeight.text,
                                  playBtn: widget.startStop,
                                  number: (widget.i + 1).toString(),
                                  id: (widget.i + 1).toString(),
                                  exeIndexId: widget.parrentindex.toString(),
                                  type: widget.userList[widget.parrentindex].title.toString(),
                                  workOutId: widget.workOutData != null
                                      ? '${widget.workOutData?.workOut![widget.workOutDataIndex!].wId.toString()}${widget.workOutData?.workOut![widget.workOutDataIndex!].wDate.toString()}${(widget.i).toString()}${widget.userList[widget.parrentindex].id}'
                                          .trim()
                                      : '${widget.conNew.workout.wId.toString()}${widget.conNew.workout.wDate.toString()}${(widget.i).toString()}${widget.userList[widget.parrentindex].id}'
                                          .trim(),
                                  isAddData: true, // id: (widget.i + 1).toString(),
                                ));
                                widget.conNew.history.exerciseName = widget.userList[widget.parrentindex].title.toString();
                                widget.conNew.history.date = dateFormated;
                                widget.conNew.history.dairy!.add(widget.dairy);
                                if (widget.userList[widget.parrentindex].dairy!.isNotEmpty) {
                                  int index = widget.userList[widget.parrentindex].dairy!
                                      .indexWhere((element) => (int.parse(element.number!) - 1) == widget.i);

                                  if (index == -1) {
                                    widget.userList[widget.parrentindex].dairy!.add(UserHistoryModel(
                                      time: widget.elapsedTime,
                                      tick: true,
                                      reps: widget.conResp.text,
                                      weight: widget.conWeight.text,
                                      playBtn: widget.startStop,
                                      number: (widget.i + 1).toString(),
                                      id: (widget.i + 1).toString(),
                                      isAddData: true,
                                    ));
                                  } else {
                                    if (kDebugMode) {
                                      print('indexWhere $index');
                                    }

                                    widget.userList[widget.parrentindex].dairy![index].tick = true;
                                    widget.userList[widget.parrentindex].dairy![index].isAddData = true;
                                  }
                                } else {
                                  widget.userList[widget.parrentindex].dairy!.add(UserHistoryModel(
                                    time: widget.elapsedTime,
                                    tick: true,
                                    reps: widget.conResp.text,
                                    weight: widget.conWeight.text,
                                    playBtn: widget.startStop,
                                    number: (widget.i + 1).toString(),
                                    id: (widget.i + 1).toString(),
                                    isAddData: true,
                                  ));
                                }
                                widget.conNew
                                    .uploadHistoryData(widget.userList[widget.parrentindex].title.toString(), widget.conNew.history, widget.dairy)
                                    .then((value) async {
                                  widget.dairy.history!.clear();
                                  widget.conNew.history.dairy!.clear();
                                  if (widget.cameFrom) {
                                    try {
                                      widget.workOutData!.workOut![widget.workOutDataIndex!].addedExercise!.clear();
                                      widget.workOutData!.workOut![widget.workOutDataIndex!].addedExercise!.addAll(widget.userList);
                                      await FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc(GetStorage().read('user').toString())
                                          .collection('Workouts')
                                          .doc(widget.workOutData!.workDate.toString())
                                          .update(widget.workOutData!.toJson())
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
                                          .whenComplete(() => isBtnBlue.value = false);
                                    } on FirebaseException catch (e) {
                                      showToast(e.message.toString());
                                    }
                                  }
                                });
                              } else if (DateTime.parse(dateFormated).isAfter(DateTime.parse(workDate))) {
                                widget.dairy.date = workDate;
                                widget.dairy.history!.add(UserHistoryModel(
                                  time: widget.elapsedTime,
                                  tick: true,
                                  reps: widget.conResp.text,
                                  weight: widget.conWeight.text,
                                  playBtn: widget.startStop,
                                  number: (widget.i + 1).toString(),
                                  id: (widget.i + 1).toString(),
                                  exeIndexId: widget.parrentindex.toString(),
                                  type: widget.userList[widget.parrentindex].title.toString(),
                                  workOutId: widget.workOutData != null
                                      ? '${widget.workOutData?.workOut![widget.workOutDataIndex!].wId.toString()}${widget.workOutData?.workOut![widget.workOutDataIndex!].wDate.toString()}${(widget.i).toString()}${widget.userList[widget.parrentindex].id}'
                                          .trim()
                                      : '${widget.conNew.workout.wId.toString()}${widget.conNew.workout.wDate.toString()}${(widget.i).toString()}${widget.userList[widget.parrentindex].id}'
                                          .trim(),
                                  isAddData: true, // id: (widget.i + 1).toString(),
                                ));
                                widget.conNew.history.exerciseName = widget.userList[widget.parrentindex].title.toString();
                                widget.conNew.history.date = workDate;
                                widget.conNew.history.dairy!.add(widget.dairy);
                                if (widget.userList[widget.parrentindex].dairy!.isNotEmpty) {
                                  int index = widget.userList[widget.parrentindex].dairy!
                                      .indexWhere((element) => (int.parse(element.number!) - 1) == widget.i);

                                  if (index == -1) {
                                    widget.userList[widget.parrentindex].dairy!.add(UserHistoryModel(
                                      time: widget.elapsedTime,
                                      tick: true,
                                      reps: widget.conResp.text,
                                      weight: widget.conWeight.text,
                                      playBtn: widget.startStop,
                                      number: (widget.i + 1).toString(),
                                      id: (widget.i + 1).toString(),
                                      isAddData: true,
                                    ));
                                  } else {
                                    if (kDebugMode) {
                                      print('indexWhere $index');
                                    }

                                    widget.userList[widget.parrentindex].dairy![index].tick = true;
                                    widget.userList[widget.parrentindex].dairy![index].isAddData = true;
                                  }
                                } else {
                                  widget.userList[widget.parrentindex].dairy!.add(UserHistoryModel(
                                    time: widget.elapsedTime,
                                    tick: true,
                                    reps: widget.conResp.text,
                                    weight: widget.conWeight.text,
                                    playBtn: widget.startStop,
                                    number: (widget.i + 1).toString(),
                                    id: (widget.i + 1).toString(),
                                    isAddData: true,
                                  ));
                                }
                                widget.conNew
                                    .uploadHistoryData(widget.userList[widget.parrentindex].title.toString(), widget.conNew.history, widget.dairy)
                                    .then((value) async {
                                  widget.dairy.history!.clear();
                                  widget.conNew.history.dairy!.clear();
                                  if (widget.cameFrom) {
                                    try {
                                      widget.workOutData!.workOut![widget.workOutDataIndex!].addedExercise!.clear();
                                      widget.workOutData!.workOut![widget.workOutDataIndex!].addedExercise!.addAll(widget.userList);
                                      await FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc(GetStorage().read('user').toString())
                                          .collection('Workouts')
                                          .doc(widget.workOutData!.workDate.toString())
                                          .update(widget.workOutData!.toJson())
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
                                          .whenComplete(() => isBtnBlue.value = false);
                                    } on FirebaseException catch (e) {
                                      showToast(e.message.toString());
                                    }
                                  }
                                });
                              } else {
                                setState(() {
                                  (widget.userList[widget.parrentindex].items[widget.i] as DairyWidgetTwo).isFilledBlue = false;
                                });
                                showToast('${'You can use the exercise on this date'.tr} $workDate');
                              }
                            } else {
                              showToast('Please complete the exercise'.tr);
                            }
                          } else {
                            if (widget.elapsedTime != '00:00') {
                              setState(() {
                                (widget.userList[widget.parrentindex].items[widget.i] as DairyWidgetTwo).isFilledBlue = true;
                              });
                              String workDate;
                              if (widget.cameFrom) {
                                if (widget.workOutData!.workOut![widget.workOutDataIndex != null ? widget.workOutDataIndex! : 0].wDate != null) {
                                  workDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(
                                      widget.workOutData!.workOut![widget.workOutDataIndex != null ? widget.workOutDataIndex! : 0].wDate.toString()));
                                } else {
                                  return;
                                }
                              } else {
                                if (widget.conNew.workout.wDate != null && widget.conNew.workout.wId != null) {
                                  workDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.conNew.workout.wDate.toString()));
                                } else {
                                  setState(() {
                                    (widget.userList[widget.parrentindex].items[widget.i] as DairyWidgetTwo).isFilledBlue = false;
                                  });
                                  showToast('Please complete workout details from settings'.tr);
                                  return;
                                }
                              }
                              final date = DateTime.now();
                              String dateFormated = DateFormat("yyyy-MM-dd").format(date);

                              if (DateTime.parse(dateFormated).isAtSameMomentAs(DateTime.parse(workDate))) {
                                widget.dairy.date = dateFormated;
                                widget.dairy.history!.add(UserHistoryModel(
                                  time: widget.elapsedTime,
                                  tick: true,
                                  reps: widget.conResp.text,
                                  weight: widget.conWeight.text,
                                  playBtn: widget.startStop,
                                  number: (widget.i + 1).toString(),
                                  id: (widget.i + 1).toString(),
                                  exeIndexId: widget.parrentindex.toString(),
                                  type: widget.userList[widget.parrentindex].title.toString(),
                                  workOutId: widget.workOutData != null
                                      ? '${widget.workOutData?.workOut![widget.workOutDataIndex!].wId.toString()}${widget.workOutData?.workOut![widget.workOutDataIndex!].wDate.toString()}${(widget.i).toString()}${widget.userList[widget.parrentindex].id}'
                                          .trim()
                                      : '${widget.conNew.workout.wId.toString()}${widget.conNew.workout.wDate.toString()}${(widget.i).toString()}${widget.userList[widget.parrentindex].id}'
                                          .trim(),
                                  isAddData: true, // id: (widget.i + 1).toString(),
                                ));
                                widget.conNew.history.exerciseName = widget.userList[widget.parrentindex].title.toString();
                                widget.conNew.history.date = dateFormated;
                                widget.conNew.history.dairy!.add(widget.dairy);
                                if (widget.userList[widget.parrentindex].dairy!.isNotEmpty) {
                                  int index = widget.userList[widget.parrentindex].dairy!
                                      .indexWhere((element) => (int.parse(element.number!) - 1) == widget.i);

                                  if (index == -1) {
                                    widget.userList[widget.parrentindex].dairy!.add(UserHistoryModel(
                                      time: widget.elapsedTime,
                                      tick: true,
                                      reps: widget.conResp.text,
                                      weight: widget.conWeight.text,
                                      playBtn: widget.startStop,
                                      number: (widget.i + 1).toString(),
                                      id: (widget.i + 1).toString(),
                                      isAddData: true,
                                    ));
                                  } else {
                                    if (kDebugMode) {
                                      print('indexWhere $index');
                                    }

                                    widget.userList[widget.parrentindex].dairy![index].tick = true;
                                    widget.userList[widget.parrentindex].dairy![index].isAddData = true;
                                  }
                                } else {
                                  widget.userList[widget.parrentindex].dairy!.add(UserHistoryModel(
                                    time: widget.elapsedTime,
                                    tick: true,
                                    reps: widget.conResp.text,
                                    weight: widget.conWeight.text,
                                    playBtn: widget.startStop,
                                    number: (widget.i + 1).toString(),
                                    id: (widget.i + 1).toString(),
                                    isAddData: true,
                                  ));
                                }
                                widget.conNew
                                    .uploadHistoryData(widget.userList[widget.parrentindex].title.toString(), widget.conNew.history, widget.dairy)
                                    .then((value) async {
                                  widget.dairy.history!.clear();
                                  widget.conNew.history.dairy!.clear();
                                  if (widget.cameFrom) {
                                    try {
                                      widget.workOutData!.workOut![widget.workOutDataIndex!].addedExercise!.clear();
                                      widget.workOutData!.workOut![widget.workOutDataIndex!].addedExercise!.addAll(widget.userList);
                                      await FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc(GetStorage().read('user').toString())
                                          .collection('Workouts')
                                          .doc(widget.workOutData!.workDate.toString())
                                          .update(widget.workOutData!.toJson())
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
                                          .whenComplete(() => isBtnBlue.value = false);
                                    } on FirebaseException catch (e) {
                                      showToast(e.message.toString());
                                    }
                                  }
                                });
                              } else if (DateTime.parse(dateFormated).isAfter(DateTime.parse(workDate))) {
                                widget.dairy.date = workDate;
                                widget.dairy.history!.add(UserHistoryModel(
                                  time: widget.elapsedTime,
                                  tick: true,
                                  reps: widget.conResp.text,
                                  weight: widget.conWeight.text,
                                  playBtn: widget.startStop,
                                  number: (widget.i + 1).toString(),
                                  id: (widget.i + 1).toString(),
                                  exeIndexId: widget.parrentindex.toString(),
                                  type: widget.userList[widget.parrentindex].title.toString(),
                                  workOutId: widget.workOutData != null
                                      ? '${widget.workOutData?.workOut![widget.workOutDataIndex!].wId.toString()}${widget.workOutData?.workOut![widget.workOutDataIndex!].wDate.toString()}${(widget.i).toString()}${widget.userList[widget.parrentindex].id}'
                                          .trim()
                                      : '${widget.conNew.workout.wId.toString()}${widget.conNew.workout.wDate.toString()}${(widget.i).toString()}${widget.userList[widget.parrentindex].id}'
                                          .trim(),
                                  isAddData: true, // id: (widget.i + 1).toString(),
                                ));
                                widget.conNew.history.exerciseName = widget.userList[widget.parrentindex].title.toString();
                                widget.conNew.history.date = workDate;
                                widget.conNew.history.dairy!.add(widget.dairy);
                                if (widget.userList[widget.parrentindex].dairy!.isNotEmpty) {
                                  int index = widget.userList[widget.parrentindex].dairy!
                                      .indexWhere((element) => (int.parse(element.number!) - 1) == widget.i);

                                  if (index == -1) {
                                    widget.userList[widget.parrentindex].dairy!.add(UserHistoryModel(
                                      time: widget.elapsedTime,
                                      tick: true,
                                      reps: widget.conResp.text,
                                      weight: widget.conWeight.text,
                                      playBtn: widget.startStop,
                                      number: (widget.i + 1).toString(),
                                      id: (widget.i + 1).toString(),
                                      isAddData: true,
                                    ));
                                  } else {
                                    if (kDebugMode) {
                                      print('indexWhere $index');
                                    }

                                    widget.userList[widget.parrentindex].dairy![index].tick = true;
                                    widget.userList[widget.parrentindex].dairy![index].isAddData = true;
                                  }
                                } else {
                                  widget.userList[widget.parrentindex].dairy!.add(UserHistoryModel(
                                    time: widget.elapsedTime,
                                    tick: true,
                                    reps: widget.conResp.text,
                                    weight: widget.conWeight.text,
                                    playBtn: widget.startStop,
                                    number: (widget.i + 1).toString(),
                                    id: (widget.i + 1).toString(),
                                    isAddData: true,
                                  ));
                                }
                                widget.conNew
                                    .uploadHistoryData(widget.userList[widget.parrentindex].title.toString(), widget.conNew.history, widget.dairy)
                                    .then((value) async {
                                  widget.dairy.history!.clear();
                                  widget.conNew.history.dairy!.clear();
                                  if (widget.cameFrom) {
                                    try {
                                      widget.workOutData!.workOut![widget.workOutDataIndex!].addedExercise!.clear();
                                      widget.workOutData!.workOut![widget.workOutDataIndex!].addedExercise!.addAll(widget.userList);
                                      await FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc(GetStorage().read('user').toString())
                                          .collection('Workouts')
                                          .doc(widget.workOutData!.workDate.toString())
                                          .update(widget.workOutData!.toJson())
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
                                          .whenComplete(() => isBtnBlue.value = false);
                                    } on FirebaseException catch (e) {
                                      showToast(e.message.toString());
                                    }
                                  }
                                });
                              } else {
                                setState(() {
                                  (widget.userList[widget.parrentindex].items[widget.i] as DairyWidgetTwo).isFilledBlue = false;
                                });
                                showToast('${'You can use the exercise on this date'.tr} $workDate'.tr);
                              }
                            } else {
                              showToast('Please complete the exercise'.tr);
                            }
                          }
                        }
                      });
                      if (widget.cameFrom) {
                        try {
                          widget.workOutData!.workOut![widget.workOutDataIndex!].addedExercise!.clear();
                          widget.workOutData!.workOut![widget.workOutDataIndex!].addedExercise!.addAll(widget.userList);
                          await FirebaseFirestore.instance
                              .collection('Users')
                              .doc(GetStorage().read('user').toString())
                              .collection('Workouts')
                              .doc(widget.workOutData!.workDate.toString())
                              .update(widget.workOutData!.toJson())
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
                              .whenComplete(() => isBtnBlue.value = false);
                        } on FirebaseException catch (e) {
                          showToast(e.message.toString());
                        }
                      }
                    },
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: widget.i != widget.userList[widget.parrentindex].items.length - 1
                              ? ColorResources.LIGHT_TITLE_TEXT
                              : Colors.transparent,
                        ),
                        color: (widget.userList[widget.parrentindex].items[widget.i] as DairyWidgetTwo).isAddData == true
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                          child: widget.i == widget.userList[widget.parrentindex].items.length - 1
                              ? SvgPicture.asset(

                                  // ? "assets/check.svg"
                                  //        :
                                  "assets/add.svg",
                                  color: widget.userList[widget.parrentindex].isAddData == true
                                      ? ColorResources.LIGHT_TITLE_TEXT
                                      : ColorResources.COLOR_NORMAL_BLACK)
                              : Container()),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  int getValue() {
    if (widget.parrentindex == widget.userList.length - 1) {
      if (widget.i == widget.userList[widget.parrentindex].items.length - 1 && widget.userList[widget.parrentindex].isItemSelect == true) {
        return CustomContainer.BOTTOM;
      } else {
        return CustomContainer.MID;
      }
    } else {
      if (widget.i == widget.userList[widget.parrentindex].items.length - 1 &&
          widget.userList[widget.parrentindex].isItemSelect == true &&
          widget.userList[widget.parrentindex].selectedIndex == widget.indexValue - 1) {
        return CustomContainer.BOTTOM;
      } else {
        return CustomContainer.MID;
      }
    }
  }

  @override
  void dispose() {
    widget.timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
}
