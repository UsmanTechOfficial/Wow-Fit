import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:wowfit/CustomCalendar/calendar.dart';
import 'package:wowfit/CustomCalendar/customCalendar.dart';
import 'package:wowfit/Models/WorkOutModel.dart';
import 'package:wowfit/Utils/color_resources.dart';
import 'package:wowfit/Utils/styles.dart';
import 'package:wowfit/Widgets/buttonWidget.dart';
import 'package:wowfit/Widgets/customColorPickerWidget.dart';
import 'package:wowfit/Widgets/customRadioButton.dart';
import 'package:wowfit/Widgets/timeInputField.dart';
import 'package:wowfit/main.dart';

import '../controller/addExcerciseController.dart';

enum StartWeekDay { sunday, monday }

enum CalendarViews { dates, months, year }

CalendarViews _currentView = CalendarViews.dates;

List<Color> colorList = [
  const Color(0xFFEB5757),
  const Color(0xFFF2994A),
  const Color(0xFFF2C94C),
  const Color(0xFF219653),
  const Color(0xFF2F80ED),
  const Color(0xFF2D9CDB),
  const Color(0xFF56CCF2),
  const Color(0xFF9B51E0),
  const Color(0xFF7879F1),
  const Color(0xFF828282),
];

class EditBottomSheet extends StatefulWidget {
  BuildContext? context;
  WorkOutModel? workout;
  int? index;
  bool cameForm;
  var bottomSheetState;
  Function(bool)? callback;
  WorkOutData? workOutData;

  ///use for update screen
  bool isWorkOut;
  EditBottomSheet(
      {Key? key,
      this.context,
      required this.isWorkOut,
      this.workout,
      this.cameForm = false,
      this.callback,
      this.workOutData,
      this.bottomSheetState,
      this.index})
      : super(key: key);

  @override
  State<EditBottomSheet> createState() => _EditBottomSheetState();
}

class _EditBottomSheetState extends State<EditBottomSheet> {
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  final TextEditingController _startTimeHoursController =
      TextEditingController();
  final TextEditingController _startTimeMinutesController =
      TextEditingController();
  final TextEditingController _startDurationHoursController =
      TextEditingController();
  final TextEditingController _startDurationMinutesController =
      TextEditingController();
  AddExerciseController con = Get.put(AddExerciseController());
  bool isTime = false;
  String error = '';
  bool showError = false;
  int _groupValue = 0;
  int _colorValue = 0;
  DateTime? _currentDateTime;
  DateTime? _selectedDateTime;
  List<Calendar>? _sequentialDates;
  bool isShowCalender = false;
  DateTime? date;
  String? endingHour;
  String? endingMinutes;
  int? pickedColor = 0;
  int? pickedNotify = 0;
  int? midYear;
  /*final List<String> _weekDays = [
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN'
  ];*/
  final List<String> _notification = [
    'Do not notify',
    'In 30 minutes',
    'In 1 hour',
    'In 12 hours',
  ];
  /*final List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];*/
  @override
  void initState() {
    super.initState();
    final date = DateTime.parse(widget.workOutData?.workDate??DateTime.now().toString());
    _currentDateTime = DateTime(date.year, date.month);
    _selectedDateTime = DateTime(date.year, date.month, date.day);
    updateWorkoutDataByModel();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _getCalendar();
        if (widget.isWorkOut) {
          updateWorkoutDate();
        }
      });
    });
    setTime();
  }

  changeTime() {
    setState(() {
      if (_startTimeHoursController.text.isNotEmpty &&
          _startTimeMinutesController.text.isNotEmpty &&
          _startDurationHoursController.text.isEmpty &&
          _startDurationMinutesController.text.isEmpty) {
        isTime = false;
        var endTime = formatIn24hr(_startTimeHoursController.text,
            _startTimeMinutesController.text, '00', '00');
        if (kDebugMode) {
          print(endTime);
        }
        List<String> tempTime = endTime.split(':');
        if (kDebugMode) {
          print(tempTime);
        }
        endingHour = '';
        endingMinutes = '';
      }
      if (_startTimeHoursController.text.isNotEmpty &&
          _startDurationHoursController.text.isNotEmpty &&
          _startTimeMinutesController.text.isNotEmpty &&
          _startDurationMinutesController.text.isNotEmpty &&
          _startDurationMinutesController.text.length > 1) {
        isTime = true;
        var endTime = formatIn24hr(
            _startTimeHoursController.text,
            _startTimeMinutesController.text,
            _startDurationHoursController.text,
            _startDurationMinutesController.text);
        if (kDebugMode) {
          print(endTime);
        }
        List<String> tempTime = endTime.split(':');
        if (kDebugMode) {
          print(tempTime);
        }
        endingHour = tempTime[0];
        endingMinutes = tempTime[1];
      } else {
        if (endingHour == null) {
          isTime = false;
        }
      }
    });
  }

  String formatIn24hr(String startHours, String startMinutes, String endHours,
      String endMinutes) {
    String startTime = '$startHours:$startMinutes'; // or if '24:00'
    String endTime = '$endHours:$endMinutes'; // or if '12:00

    var format = DateFormat("HH:mm");
    var start = format.parse(startTime);
    var end = format.parse(endTime);
    var checktime = DateFormat("HH:mm").format(start.add(
        Duration(hours: int.parse(endHours), minutes: int.parse(endMinutes))));

    return checktime.toString();
    /*if (star0t.isAfter(end)) {
      if (kDebugMode) {
        print('start is big');
        print('difference = ${start.difference(end)}');
      }
      return start.difference(end).toString();
    } else if (start.isBefore(end)) {
      if (kDebugMode) {
        print('end is big');
        print('difference = ${end.difference(start)}');
      }
      return end.difference(start).toString();
    } else {
      if (kDebugMode) {
        print('difference = ${end.difference(start)}');
      }
      return end.difference(start).toString();
    }*/
  }

  MaskTextInputFormatter shourMaskFormatter =
      MaskTextInputFormatter(mask: 'a#', filter: {
    "#": RegExp(r'[0-9]'),
    "a": RegExp(r'[0-2]'),
  });
  MaskTextInputFormatter dhourMaskFormatter =
      MaskTextInputFormatter(mask: 'a#', filter: {
    "#": RegExp(r'[0-9]'),
    "a": RegExp(r'[0-2]'),
  });
  MaskTextInputFormatter sminuteMaskFormatter =
      MaskTextInputFormatter(mask: 'a#', filter: {
    "#": RegExp(r'[0-9]'),
    "a": RegExp(r'[0-5]'),
  });
  MaskTextInputFormatter dminuteMaskFormatter =
      MaskTextInputFormatter(mask: 'a#', filter: {
    "#": RegExp(r'[0-9]'),
    "a": RegExp(r'[0-5]'),
  });

  setTime() {
    _startTimeHoursController.addListener(() {
      var s = _startTimeHoursController.value.text.toString();
      if (s.isNotEmpty && s.length == 1) {
        if (s[0] == "2") {
          _startTimeHoursController.value = shourMaskFormatter.updateMask(
              mask: 'a#',
              filter: {"#": RegExp(r'[0-4]'), "a": RegExp(r'[0-2]')});
        } else if (s[0] == "1" || (s[0] == "0")) {
          _startTimeHoursController.value = shourMaskFormatter.updateMask(
              mask: 'a#',
              filter: {"#": RegExp(r'[0-9]'), "a": RegExp(r'[0-2]')});
        }
      } else if (s == "24") {
        _startTimeMinutesController.value = sminuteMaskFormatter.updateMask(
            mask: 'a#', filter: {"#": RegExp(r'[0]'), "a": RegExp(r'[0]')});
      } else if (s == "23") {
        _startTimeMinutesController.value = sminuteMaskFormatter.updateMask(
            mask: 'a#', filter: {"#": RegExp(r'[0-9]'), "a": RegExp(r'[0-5]')});
      }
      changeTime();
    });
    _startTimeMinutesController.addListener(() {
      var s = _startTimeMinutesController.value.text.toString();
      if (s.isNotEmpty && s.length == 1) {
        if (s[0] == "6") {
          _startTimeMinutesController.value = sminuteMaskFormatter.updateMask(
              mask: 'a#', filter: {"#": RegExp(r'[0]'), "a": RegExp(r'[0]')});
        } else {
          _startTimeMinutesController.value = sminuteMaskFormatter.updateMask(
              mask: 'a#',
              filter: {"#": RegExp(r'[0-9]'), "a": RegExp(r'[0-5]')});
        }
      }
      changeTime();
    });
    _startDurationHoursController.addListener(() {
      var s = _startDurationHoursController.value.text.toString();
      if (s.isNotEmpty && s.length == 1) {
        if (s[0] == "2") {
          _startDurationHoursController.value = dhourMaskFormatter.updateMask(
              mask: 'a#',
              filter: {"#": RegExp(r'[0-4]'), "a": RegExp(r'[0-2]')});
        } else if (s[0] == "1" || (s[0] == "0")) {
          _startDurationHoursController.value = dhourMaskFormatter.updateMask(
              mask: 'a#',
              filter: {"#": RegExp(r'[0-9]'), "a": RegExp(r'[0-2]')});
        }
      } else if (s == "24") {
        _startDurationMinutesController.value = dminuteMaskFormatter.updateMask(
            mask: 'a#', filter: {"#": RegExp(r'[0]'), "a": RegExp(r'[0]')});
      } else {
        _startDurationMinutesController.value = dminuteMaskFormatter.updateMask(
            mask: 'a#', filter: {"#": RegExp(r'[0-9]'), "a": RegExp(r'[0-5]')});
      }
      changeTime();
    });
    _startDurationMinutesController.addListener(() {
      var s = _startDurationMinutesController.value.text.toString();
      if (s.isNotEmpty && s.length == 1) {
        if (s[0] == "6") {
          _startDurationMinutesController.value = dminuteMaskFormatter
              .updateMask(
                  mask: 'a#',
                  filter: {"#": RegExp(r'[0]'), "a": RegExp(r'[0]')});
        } else {
          _startDurationMinutesController.value = dminuteMaskFormatter
              .updateMask(
                  mask: 'a#',
                  filter: {"#": RegExp(r'[0-9]'), "a": RegExp(r'[0-5]')});
        }
      }
      changeTime();
    });
  }

  void _getNextMonth() {
    if (_currentDateTime!.month == 12) {
      _currentDateTime = DateTime(_currentDateTime!.year + 1, 1);
    } else {
      _currentDateTime =
          DateTime(_currentDateTime!.year, _currentDateTime!.month + 1);
    }
    _getCalendar();
  }

// get previous month calendar
  void _getPrevMonth() {
    if (_currentDateTime!.month == 1) {
      _currentDateTime = DateTime(_currentDateTime!.year - 1, 12);
    } else {
      _currentDateTime =
          DateTime(_currentDateTime!.year, _currentDateTime!.month - 1);
    }
    _getCalendar();
  }

  // get calendar for current month
  void _getCalendar() {
    _sequentialDates = CustomCalendar().getMonthCalendar(
        _currentDateTime!.month, _currentDateTime!.year,
        startWeekDay: StartWeekDay.monday);
    /*if (widget.startWeekDay != null && widget.startWeekDay! < 7) {
      final time = _controller.value.subtract(
        Duration(days: _controller.value.weekday - widget.startWeekDay!),
      );
      final list = List<DateTime>.generate(
        8,
            (index) => time.add(Duration(days: index * 1)),
      ).toList();
      print(list);
      _weekNames = List<String>.generate(7, (index) {
        return DateFormat("EEEE").format(list[index]).split('').first;
      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          alignment: Alignment.bottomCenter,
          height: widget.isWorkOut == true ? 505 : 490,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            color: Colors.white,
          ),
          child: ModalProgressHUD(
            inAsyncCall: con.loader.value,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 60,
                        height: 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: const Color(0xFF979797).withOpacity(0.5),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    widget.isWorkOut == true && widget.cameForm == true
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Text(
                              "Choose date to copy workout".tr,
                              style: sFProDisplayBold.copyWith(
                                  fontSize: 20,
                                  color: ColorResources.COLOR_NORMAL_BLACK),
                            ),
                          )
                        : Container(),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            8,
                          ),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                                color: ColorResources.INPUT_BORDER,
                                spreadRadius: 1),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (isShowCalender == false) {
                                    setState(() {
                                      FocusScope.of(context).unfocus();
                                      isShowCalender = true;
                                      date = getCurrentDate();
                                    });
                                  } else {
                                    setState(() {
                                      isShowCalender = false;
                                    });
                                  }
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      getCurrentDate() != null
                                          ? DateFormat('dd.MM.yyyy EEEEE')
                                              .format(getCurrentDate()!)
                                          : "Date".tr,
                                      style: TextStyle(
                                        color: date != null
                                            ? ColorResources.COLOR_NORMAL_BLACK
                                            : ColorResources.INPUT_HINT_COLOR,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        if (isShowCalender == false) {
                                          setState(() {
                                            FocusScope.of(context).unfocus();
                                            isShowCalender = true;
                                            date = getCurrentDate();
                                          });
                                        } else {
                                          setState(() {
                                            isShowCalender = false;
                                          });
                                        }
                                      },
                                      child: SvgPicture.asset(
                                        'assets/calendar.svg',
                                        color: ColorResources.INPUT_HINT_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              isShowCalender == false
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      child: _datesView(),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Starts at".tr,
                                style: sFProDisplayRegular.copyWith(
                                    fontSize: 16,
                                    color: ColorResources.COLOR_NORMAL_BLACK),
                              ),
                              const SizedBox(
                                height: 9,
                              ),
                              Container(
                                height: 35,
                                width: 85,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: ColorResources.INPUT_BORDER,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    SizedBox(
                                      height: 40,
                                      width: 32,
                                      child: Center(
                                        child: TimeInputFields(
                                          "00",
                                          "your email".tr,
                                          isEmail: true,
                                          inputFormator: <TextInputFormatter>[
                                            shourMaskFormatter
                                          ],
                                          keyboardType: const TextInputType
                                              .numberWithOptions(
                                            signed: true,
                                            decimal: false,
                                          ),
                                          controller: _startTimeHoursController,
                                          focusNode: focusNode1,
                                          callback: (value) {
                                            if (value.length == 2) {
                                              focusNode2.requestFocus();
                                            }
                                            //  _startTimeHoursController.text = value;
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Text(
                                        ":",
                                        style: sFProDisplayRegular.copyWith(
                                          fontSize: 18,
                                          color:
                                              ColorResources.COLOR_NORMAL_BLACK,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    SizedBox(
                                      height: 40,
                                      width: 32,
                                      child: Center(
                                        child: TimeInputFields(
                                          "00",
                                          "your email".tr,
                                          isEmail: true,
                                          focusNode: focusNode2,
                                          inputFormator: <TextInputFormatter>[
                                            sminuteMaskFormatter
                                          ],
                                          keyboardType: const TextInputType
                                              .numberWithOptions(
                                            signed: true,
                                            decimal: false,
                                          ),
                                          controller:
                                              _startTimeMinutesController,
                                          callback: (value) {
                                            if (value.length == 2) {
                                              focusNode3.requestFocus();
                                            }

                                            if (value.isEmpty) {
                                              focusNode2.previousFocus();
                                            }
                                            // _startTimeMinutesController.text = value;
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Duration".tr,
                                style: sFProDisplayRegular.copyWith(
                                    fontSize: 16,
                                    color: ColorResources.COLOR_NORMAL_BLACK),
                              ),
                              const SizedBox(
                                height: 9,
                              ),
                              Container(
                                height: 35,
                                width: 85,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: ColorResources.INPUT_BORDER,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                      height: 40,
                                      width: 32,
                                      child: Center(
                                        child: TimeInputFields(
                                          "00",
                                          "your email".tr,
                                          isEmail: true,
                                          focusNode: focusNode3,
                                          inputFormator: <TextInputFormatter>[
                                            dhourMaskFormatter
                                          ],
                                          keyboardType: const TextInputType
                                              .numberWithOptions(
                                            signed: true,
                                            decimal: false,
                                          ),
                                          controller:
                                              _startDurationHoursController,
                                          callback: (value) {
                                            if (value.length == 2) {
                                              focusNode4.requestFocus();
                                            }
                                            if (value.isEmpty) {
                                              focusNode3.previousFocus();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 6),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              ColorResources.COLOR_NORMAL_BLACK,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    SizedBox(
                                      height: 40,
                                      width: 32,
                                      child: Center(
                                        child: TimeInputFields(
                                          "00",
                                          "your email".tr,
                                          isEmail: true,
                                          inputFormator: <TextInputFormatter>[
                                            dminuteMaskFormatter
                                          ],
                                          keyboardType: const TextInputType
                                              .numberWithOptions(
                                            signed: true,
                                            decimal: false,
                                          ),
                                          focusNode: focusNode4,
                                          controller:
                                              _startDurationMinutesController,
                                          callback: (value) {
                                            if (value.isEmpty) {
                                              focusNode4.previousFocus();
                                            }
                                            //  _startDurationMinutesController.text =
                                            //    value;
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ending".tr,
                                style: sFProDisplayRegular.copyWith(
                                    fontSize: 16,
                                    color: ColorResources.COLOR_NORMAL_BLACK),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 32,
                                width: 85,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                        color: ColorResources.INPUT_BORDER,
                                        spreadRadius: 1),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                      height: 40,
                                      width: 32,
                                      child: Center(
                                        child: Text(
                                          isTime == true && endingHour != null
                                              ? endingHour.toString()
                                              : "00",
                                          style: sFProDisplayRegular.copyWith(
                                            fontSize: 18,
                                            color: ColorResources
                                                .COLOR_NORMAL_BLACK,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 6),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color:
                                              ColorResources.COLOR_NORMAL_BLACK,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                      height: 40,
                                      width: 32,
                                      child: Center(
                                        child: SizedBox(
                                          height: 40,
                                          width: 30,
                                          child: Center(
                                            child: Text(
                                              isTime == true &&
                                                      endingMinutes != null
                                                  ? endingMinutes.toString()
                                                  : "00",
                                              style:
                                                  sFProDisplayRegular.copyWith(
                                                fontSize: 18,
                                                color: ColorResources
                                                    .COLOR_NORMAL_BLACK,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            itemCount: colorList.length,
                            itemBuilder: (context, i) {
                              return SizedBox(
                                height: 40,
                                width: 40,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: CustomColorPickerWidget(
                                      onChanged: (int? newValue) {
                                        setState(() => _colorValue = newValue!);
                                        pickedColor = newValue;
                                      },
                                      groupValue: _colorValue,
                                      value: i,
                                      color: colorList[i],
                                    )),
                              );
                            }),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _groupValue = 0;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Do not notify".tr,
                                  style: sFProDisplayRegular.copyWith(
                                      fontSize: 16,
                                      color: ColorResources.COLOR_NORMAL_BLACK),
                                ),
                                const Spacer(),
                                Center(
                                  child: SizedBox(
                                      width: 40,
                                      height: 50,
                                      child: CustomRadioWidget(
                                        onChanged: (int? newValue) {
                                          setState(
                                              () => _groupValue = newValue!);
                                          pickedNotify = newValue;
                                        },
                                        groupValue: _groupValue,
                                        value: 0,
                                      ) /* RadioListTile(
                                value: 0,
                                groupValue: _groupValue,
                                onChanged: (int? newValue) =>
                                    setState(() => _groupValue = newValue!),
                              ),*/
                                      ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _groupValue = 1;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "In 30 minutes".tr,
                                  style: sFProDisplayRegular.copyWith(
                                      fontSize: 16,
                                      color: ColorResources.COLOR_NORMAL_BLACK),
                                ),
                                const Spacer(),
                                Center(
                                  child: SizedBox(
                                      width: 40,
                                      height: 50,
                                      child: CustomRadioWidget(
                                        onChanged: (int? newValue) {
                                          setState(
                                              () => _groupValue = newValue!);
                                          pickedNotify = newValue;
                                        },
                                        groupValue: _groupValue,
                                        value: 1,
                                      )),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _groupValue = 2;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "In 1 hour".tr,
                                  style: sFProDisplayRegular.copyWith(
                                      fontSize: 16,
                                      color: ColorResources.COLOR_NORMAL_BLACK),
                                ),
                                const Spacer(),
                                Center(
                                  child: SizedBox(
                                      width: 40,
                                      height: 50,
                                      child: CustomRadioWidget(
                                        onChanged: (int? newValue) {
                                          setState(
                                              () => _groupValue = newValue!);
                                          pickedNotify = newValue;
                                        },
                                        groupValue: _groupValue,
                                        value: 2,
                                      )),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _groupValue = 3;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "In 12 hours".tr,
                                  style: sFProDisplayRegular.copyWith(
                                      fontSize: 16,
                                      color: ColorResources.COLOR_NORMAL_BLACK),
                                ),
                                const Spacer(),
                                Center(
                                  child: SizedBox(
                                      width: 40,
                                      height: 50,
                                      child: CustomRadioWidget(
                                        onChanged: (int? newValue) {
                                          setState(
                                              () => _groupValue = newValue!);
                                          pickedNotify = newValue;
                                        },
                                        groupValue: _groupValue,
                                        value: 3,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    /*if (showError)
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Error : $error".tr,
                            style: sFProDisplayRegular.copyWith(
                                fontSize: 16, color: Colors.red),
                          )),*/
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: ButtonWidget(
                        height: 45,
                        text: "Save".tr,
                        color: Colors.white,
                        containerColor: ColorResources.COLOR_NORMAL_BLACK,
                        widthColor: ColorResources.COLOR_NORMAL_BLACK,
                        onTap: () {
                          if (!widget.isWorkOut) {
                            saveWorkoutDate();
                          } else {
                            con.loader.value = true;
                            updateDataOnFirestore();
                          }

                          if (kDebugMode) {
                            print('hello');
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
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

  saveWorkoutDate() {
    if (date == null) {
      Get.snackbar(
        'Error'.tr,
        'Please enter Start at in hours and minutes'.tr,
        borderRadius: 1,
        margin: EdgeInsets.zero,
        colorText: const Color(0xffFAFAFA),
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF333333),
        barBlur: 50,
      );
    } else if (_startTimeHoursController.text.isEmpty ||
        _startTimeMinutesController.text.isEmpty) {
      /*ScaffoldMessenger.of(widget.context!).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.fixed,
          content: Text('Please enter Start at in hours and minutes')));*/
      Get.snackbar(
        'Error'.tr,
        'Please enter Start at in hours and minutes'.tr,
        borderRadius: 1,
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(16),
        colorText: const Color(0xffFAFAFA),
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF333333),
        barBlur: 50,
      );
    }
    // else if (_startDurationHoursController.text.isEmpty ||
    //     _startDurationMinutesController.text.isEmpty) {
    //   widget.bottomSheetState(() {
    //     error = 'Please enter Duration in hours and minutes';
    //     showError = true;
    //   });
    // }
    else {
      widget.bottomSheetState(() {
        error = '';
        showError = false;
      });
      widget.workout?.wId = getRandomGeneratedId();
      widget.workout?.wDate = date.toString();
      widget.workout?.startTime = _startTimeHoursController.text +
          ":" +
          _startTimeMinutesController.text;
      widget.workout?.duration = _startDurationHoursController.text +
          ":" +
          _startDurationMinutesController.text;
      widget.workout?.endTime =
          endingHour.toString() + ":" + endingMinutes.toString();
      widget.workout?.color = pickedColor.toString();
      widget.workout?.notify = pickedNotify.toString();
      widget.workout?.img = "assets/bydeef.svg";
      widget.callback!(true);
      Get.back();
    }
  }

  updateDataOnFirestore() {
    widget.workOutData!.workOut![widget.index!].wDate =
        DateFormat("yyyy-MM-dd").format(date!);
    widget.workOutData!.workOut![widget.index!].startTime =
        _startTimeHoursController.text + ":" + _startTimeMinutesController.text;
    widget.workOutData!.workOut![widget.index!].duration =
        _startDurationHoursController.text +
            ":" +
            _startDurationMinutesController.text;
    widget.workOutData!.workOut![widget.index!].endTime =
        endingHour.toString() + ":" + endingMinutes.toString();
    widget.workOutData!.workOut![widget.index!].color = _colorValue.toString();
    widget.workOutData!.workOut![widget.index!].notify = _groupValue.toString();

    //widget.workOutData!.workOut![widget.index!].img = "assets/bydefaultimg.svg";
    if (widget.cameForm) {
      widget.workOutData!.workOut![widget.index!].img = "assets/bydeef.svg";
      con.copyWorkout(widget.workOutData!, date!.toString(), widget.index!);
    } else {
      con.loader.value = true;
      con
          .updateWorkout(widget.workOutData!,
              widget.workOutData!.workDate.toString(), widget.index!)
          .then((value) => widget.callback!(true));
      // .then((value) {
      /*if (int.parse(widget.workOutData!.workOut![widget.index!].notify
                .toString()) !=
            0) {
          NotificationService().setNotification(
              widget.workOutData!.workOut![widget.index!].startTime.toString(),
              widget.index!,
              widget.workOutData!.workOut![widget.index!].workOutTitleName
                  .toString(),
              int.parse(widget.workOutData!.workOut![widget.index!].notify
                  .toString()),
              DateTime.parse(widget.workOutData!.workDate!));
        }*/

      // widget.callback!(false);
      //  });
    }
  }

  updateWorkoutDate() {
    date = DateTime.parse(widget.workOutData!.workOut![widget.index!].wDate!);
    List<String> result =
        widget.workOutData!.workOut![widget.index!].startTime!.split(':');
    _startTimeHoursController.text = result[0].isNotEmpty ? result[0] : "00";
    _startTimeMinutesController.text = result[1].isNotEmpty ? result[1] : '00';
    List<String> result1 =
        widget.workOutData!.workOut![widget.index!].duration!.split(':');
    _startDurationHoursController.text =
        result1[0].isNotEmpty ? result1[0] : '';
    _startDurationMinutesController.text =
        result1[1].isNotEmpty ? result1[1] : '';
    if (result1[0].isEmpty && result1[1].isEmpty) {
      endingHour = '';
      endingMinutes = '';
    } else {
      var endTime = formatIn24hr(
          _startTimeHoursController.text,
          _startTimeMinutesController.text,
          _startDurationHoursController.text,
          _startDurationMinutesController.text);
      List<String> tempTime = endTime.split(':');
      endingHour = tempTime[0];
      endingMinutes = tempTime[1];
    }
    _colorValue =
        int.parse(widget.workOutData!.workOut![widget.index!].color.toString());
    _groupValue =
        int.parse(widget.workOutData!.workOut![widget.index!].notify!);
    if (widget.workOutData!.workOut![widget.index!].img == null ||
        widget.workOutData!.workOut![widget.index!].img!.isEmpty) {
      widget.workOutData!.workOut![widget.index!].img = "assets/bydeef.svg";
    }
  }

  updateWorkoutDataByModel() {
    if (widget.workout != null) {
      if (widget.workout!.wDate != null && widget.workout!.wDate!.isNotEmpty) {
        date = DateTime.parse(widget.workout!.wDate!);
      }
      if (widget.workout!.startTime != null &&
          widget.workout!.startTime!.isNotEmpty) {
        List<String> result = widget.workout!.startTime!.split(':');
        _startTimeHoursController.text =
            result[0].isNotEmpty ? result[0] : '00';
        _startTimeMinutesController.text =
            result[1].isNotEmpty ? result[1] : '00';
      }
      if (widget.workout!.duration != null &&
          widget.workout!.duration!.isNotEmpty) {
        List<String> result = widget.workout!.duration!.split(':');
        _startDurationHoursController.text =
            result[0].isNotEmpty ? result[0] : '00';
        _startDurationMinutesController.text =
            result[1].isNotEmpty ? result[1] : '00';
      }
      if (widget.workout!.color != null && widget.workout!.color!.isNotEmpty) {
        _colorValue = int.parse(widget.workout!.color.toString());
      }
      if (widget.workout!.notify != null &&
          widget.workout!.notify!.isNotEmpty) {
        _groupValue = int.parse(widget.workout!.notify!);
      }
      if (_startTimeHoursController.text.isNotEmpty &&
          _startDurationHoursController.text.isNotEmpty) {
        setState(() {
          isTime = true;
          var endTime = formatIn24hr(
              _startTimeHoursController.text,
              _startTimeMinutesController.text,
              _startDurationHoursController.text,
              _startDurationMinutesController.text);
          if (kDebugMode) {
            print(endTime);
          }
          List<String> tempTime = endTime.split(':');
          if (kDebugMode) {
            print(tempTime);
          }
          endingHour = tempTime[0];
          endingMinutes = tempTime[1];
        });
      }
    }
  }

  Widget _datesView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // header
        Row(
          children: <Widget>[
            Center(
              child: Row(
                children: [
                  //${_monthNames[_currentDateTime!.month - 1]} ${_currentDateTime!.year}
                  Text(
                    "${DateFormat('MMMM').format(_currentDateTime!)} ${DateFormat('yyyy').format(_currentDateTime!)}",
                    style: const TextStyle(
                        color: ColorResources.COLOR_BLUE,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const Spacer(),
            _toggleBtn(false),
            // next month button
            const SizedBox(
              width: 15,
            ),
            _toggleBtn(true),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Flexible(child: _calendarBody()),
      ],
    );
  }

  Widget _toggleBtn(bool next) {
    return InkWell(
      onTap: () {
        if (_currentView == CalendarViews.dates) {
          setState(() => (next) ? _getNextMonth() : _getPrevMonth());
        } else if (_currentView == CalendarViews.year) {
          if (next) {
            midYear =
                (midYear == null) ? _currentDateTime!.year + 9 : midYear! + 9;
          } else {
            midYear =
                (midYear == null) ? _currentDateTime!.year - 9 : midYear! - 9;
          }
          setState(() {});
        }
      },
      child: Icon(
        (next) ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
        color: ColorResources.COLOR_BLUE,
      ),
    );
  }

// calendar body
  Widget _calendarBody() {
    if (_sequentialDates == null) return Container();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _sequentialDates!.length + 7,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 10,
        crossAxisCount: 7,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {

        if (index < 7) return _weekDayTitle(_sequentialDates![index]);
        if (_sequentialDates![index - 7].date == _selectedDateTime) {
          date = _selectedDateTime!;
          return _selector(_sequentialDates![index - 7]);
        }
        return _calendarDates(_sequentialDates![index - 7]);
      },
    );
  }

  DateTime? getCurrentDate() {
    return date = _selectedDateTime;
  }

  Widget _weekDayTitle(Calendar index) {
    return Text(
      DateFormat('EEE').format(index.date!),
      style:
          const TextStyle(color: ColorResources.INPUT_HINT_COLOR, fontSize: 12),
    );
  }

  Widget _calendarDates(Calendar calendarDate) {
    return InkWell(
      onTap: () {
        if (_selectedDateTime != calendarDate.date) {
          if (calendarDate.nextMonth) {
            _getNextMonth();
          } else if (calendarDate.prevMonth) {
            _getPrevMonth();
          }
          setState(() => _selectedDateTime = calendarDate.date);
        }
      },
      child: Center(
          child: Text(
        '${calendarDate.date!.day}',
        style: sFProDisplayMedium.copyWith(
          fontSize: 18,
          color: (calendarDate.thisMonth)
              ? (calendarDate.date!.weekday == DateTime.sunday)
                  ? Colors.black54
                  : Colors.black
              : (calendarDate.date!.weekday == DateTime.sunday)
                  ? Colors.black54
                  : Colors.black,
        ),
      )),
    );
  }

  Widget _selector(Calendar calendarDate) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: ColorResources.COLOR_BLUE,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: ColorResources.COLOR_BLUE, width: 4),
        gradient: const LinearGradient(
          colors: [ColorResources.COLOR_BLUE, ColorResources.COLOR_BLUE],
          stops: [0.1, 1],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: ColorResources.COLOR_BLUE,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            '${calendarDate.date!.day}',
            style: sFProDisplayMedium.copyWith(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
