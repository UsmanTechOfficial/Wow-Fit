import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:wowfit/Home/BottomNavigation/bottomNavigationScreen.dart';
import 'package:wowfit/Utils/color_resources.dart';
import 'package:wowfit/Utils/styles.dart';
import 'package:wowfit/Widgets/buttonWidget.dart';
import 'package:wowfit/Widgets/customRadioButton.dart';

import '../Models/WorkOutModel.dart';

class RateBottomSheet extends StatefulWidget {
  WorkOutData workOutData;
  int index;
  RateBottomSheet({Key? key, required this.workOutData, required this.index})
      : super(key: key);

  @override
  State<RateBottomSheet> createState() => _RateBottomSheetState();
}

class _RateBottomSheetState extends State<RateBottomSheet> {
  int _groupValue = -1;
  List<String> emojis = [
    'assets/happy.svg',
    'assets/cool.svg',
    'assets/good.svg',
    'assets/calm.svg',
    'assets/sad.svg',
    'assets/hard.svg',
    'assets/strength.svg',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 490,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _groupValue = 0;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/happy.svg'),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "I’m happy!".tr,
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
                                  setState(() => _groupValue = newValue!);
                                },
                                groupValue: _groupValue,
                                value: 0,
                              )),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _groupValue = 1;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/cool.svg'),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "I’m cool!".tr,
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
                                  setState(() => _groupValue = newValue!);
                                },
                                groupValue: _groupValue,
                                value: 1,
                              )),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _groupValue = 2;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/good.svg'),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "I’m good!".tr,
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
                                  setState(() => _groupValue = newValue!);
                                },
                                groupValue: _groupValue,
                                value: 2,
                              )),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _groupValue = 3;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/calm.svg'),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Calm mood".tr,
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
                                  setState(() => _groupValue = newValue!);
                                },
                                groupValue: _groupValue,
                                value: 3,
                              )),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _groupValue = 4;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/sad.svg'),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "It\'s kind of sad".tr,
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
                                  setState(() => _groupValue = newValue!);
                                },
                                groupValue: _groupValue,
                                value: 4,
                              )),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _groupValue = 5;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/hard.svg'),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "It\'s really hard".tr,
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
                                  setState(() => _groupValue = newValue!);
                                },
                                groupValue: _groupValue,
                                value: 5,
                              )),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _groupValue = 6;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/strength.svg'),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Complete collapse of strength".tr,
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
                                  setState(() => _groupValue = newValue!);
                                },
                                groupValue: _groupValue,
                                value: 6,
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ButtonWidget(
                height: 50,
                text: "Done".tr,
                color: Colors.white,
                containerColor: ColorResources.COLOR_NORMAL_BLACK,
                widthColor: ColorResources.COLOR_NORMAL_BLACK,
                onTap: () {
                  widget.workOutData.workOut![widget.index].img =
                      emojis[_groupValue];
                  String dateFormated = DateFormat("yyyy-MM-dd").format(
                      DateTime.parse(widget
                          .workOutData.workOut![widget.index].wDate
                          .toString()));
                  updateWorkList(dateFormated, widget.workOutData);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateWorkList(String id, WorkOutData workOutData) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(GetStorage().read('user').toString())
        .collection('Workouts')
        .doc(id)
        .update(workOutData.toJson())
        .then((value) {
      print("User work Updated");
      Get.offAll(() => BottomNavigationScreen(
            index: 0,
          ));
    }).catchError((error) => print("Failed to update user: $error"));
  }
}
