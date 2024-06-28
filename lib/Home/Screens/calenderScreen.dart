import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wowfit/Home/Screens/proScreen/buyProScreen.dart';
import 'package:wowfit/Models/WorkOutModel.dart';
import 'package:wowfit/Utils/color_resources.dart';
import 'package:wowfit/Utils/styles.dart';
import 'package:wowfit/Widgets/floatingActionButton.dart';
import 'package:wowfit/WorkoutScreen/viewWorkOutScreen.dart';

import '../../BottomSheet/editBottomSheet.dart';
import '../../DialougBox/buyProDialogBox.dart';
import '../../Models/singletons_data.dart';
import '../../WorkoutScreen/newWorkOutScreen.dart';
import '../../controller/newWorkoutController.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({Key? key}) : super(key: key);

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  NewWorkOutController con = Get.put(NewWorkOutController());
  int workoutLength = 0;
  final _calendarControllerToday = AdvancedCalendarController.today();

  /*ProScreenController proCon = Get.put(ProScreenController());*/
  String selectedCalender = '';

  @override
  void initState() {
    con.readUserWorkOutsForCalender();
    super.initState();
  }

  int i = 18;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (con.events.isEmpty) {
              Get.to(() => const WorkOutScreen(
                    controller: null,
                    openFromShare: false,
                  ));
            } else if (appData.entitlementIsActive.value) {
              Get.to(() => const WorkOutScreen(
                    controller: null,
                    openFromShare: false,
                  ));
            } else {
              /*Get.to(() => const WorkOutScreen(
                    controller: null,
                    openFromShare: false,
                  ));*/
              // if (Platform.isIOS) {
              //   showCupertinoDialog(context: context, builder: (_) => const BuyProDialogBox());
              // } else {
              showDialog(
                  context: context, builder: (_) => const BuyProDialogBox());
              // }
            }
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const FloatingActionButtonWidget()),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 3, right: 3),
              child: Obx(
                () => AdvancedCalendar(
                  weekLineHeight: 55,
                  innerDot: false,
                  dateStyle: sFProDisplayRegular.copyWith(
                      fontSize: 18, color: ColorResources.COLOR_NORMAL_BLACK),
                  controller: _calendarControllerToday,
                  events: con.events.obs,
                  preloadMonthViewAmount: 1000,
                  preloadWeekViewAmount: 1000,
                  startWeekDay: 1,
                  callback: (date, value) {
                    if (value == true) {
                      setState(() {
                        selectedCalender =
                            DateFormat("yyyy-MM-dd").format(date!);
                      });
                    } else {
                      setState(() {
                        selectedCalender = '';
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: con.readUserWorkOuts(selectedCalender),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasError) {
                  return Expanded(
                      child: Center(child: Text('Something went wrong'.tr)));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                      child: Center(
                          child: CircularProgressIndicator(
                    color: ColorResources.COLOR_BLUE,
                  )));
                }

                if (snapshot.data?.size == 0) {
                  return Expanded(
                      child: Center(
                          child: Text(
                    "There are no workouts".tr,
                    textAlign: TextAlign.center,
                  )));
                }
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, i) {
                        WorkOutData workout =
                            WorkOutData.fromJson(snapshot.data.docs[i].data());
                        String formattedDate = DateFormat('d MMMM EEEE').format(
                            DateTime.parse(workout.workDate.toString()));
                        workout.workOut!.sort(
                            (a, b) => a.startTime!.compareTo(b.startTime!));
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formattedDate,
                                style: sFProDisplayRegular.copyWith(
                                    fontSize: 18,
                                    color: ColorResources.COLOR_NORMAL_BLACK),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: workout.workOut!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ViewWorkOutScreen(
                                            workout: workout.workOut!,
                                            index: index,
                                            workOutData: workout,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: colorList[int.parse(
                                                    workout
                                                        .workOut![index].color
                                                        .toString())],
                                                spreadRadius: 1)
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 15),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                height: 45,
                                                width: 45,
                                                child: SvgPicture.asset(workout
                                                    .workOut![index].img
                                                    .toString()),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      workout.workOut![index]
                                                          .workOutTitleName
                                                          .toString(),
                                                      style: sFProDisplayMedium
                                                          .copyWith(
                                                              fontSize: 16,
                                                              color: ColorResources
                                                                  .COLOR_NORMAL_BLACK),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      workout.workOut![index]
                                                                      .wDate !=
                                                                  null &&
                                                              workout
                                                                      .workOut![
                                                                          index]
                                                                      .startTime !=
                                                                  null &&
                                                              workout
                                                                      .workOut![
                                                                          index]
                                                                      .duration !=
                                                                  "00:00" &&
                                                              workout
                                                                      .workOut![
                                                                          index]
                                                                      .duration !=
                                                                  ":"
                                                          ? "${workout.workOut![index].startTime} - ${workout.workOut![index].endTime}"
                                                          : "${workout.workOut![index].startTime}",
                                                      style: sFProDisplayRegular
                                                          .copyWith(
                                                              fontSize: 14,
                                                              color: ColorResources
                                                                  .INPUT_HINT_COLOR),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    if (appData
                                                        .entitlementIsActive
                                                        .value) {
                                                      showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        enableDrag: true,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return StatefulBuilder(
                                                              builder: (context,
                                                                  bottomSheetState) {
                                                            return EditBottomSheet(
                                                              context: context,
                                                              isWorkOut: true,
                                                              bottomSheetState:
                                                                  bottomSheetState,
                                                              index: index,
                                                              workOutData:
                                                                  workout,
                                                              cameForm: true,
                                                            );
                                                          });
                                                        },
                                                      );
                                                    } else {
                                                      Get.back();
                                                      Get.to(() =>
                                                          const BuyProScreen());
                                                    }
                                                  },
                                                  child: const Icon(
                                                    Icons.content_copy_rounded,
                                                    color: ColorResources
                                                        .INPUT_HINT_COLOR,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
