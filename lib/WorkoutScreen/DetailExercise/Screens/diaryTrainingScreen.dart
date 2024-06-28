import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wowfit/Models/userHistoryModel.dart';
import 'package:wowfit/Utils/color_resources.dart';
import 'package:wowfit/Utils/styles.dart';
import 'package:wowfit/controller/newWorkoutController.dart';

class DiaryTrainingScreen extends StatefulWidget {
  String id;
  String categoryId;
  DiaryTrainingScreen({Key? key, required this.id, required this.categoryId})
      : super(key: key);

  @override
  State<DiaryTrainingScreen> createState() => _DiaryTrainingScreenState();
}

class _DiaryTrainingScreenState extends State<DiaryTrainingScreen> {
  NewWorkOutController con = Get.put(NewWorkOutController());
  HistoryData? data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: data != null
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: data!.dairy!.length,
              itemBuilder: (context, i) {
                String formattedDate = DateFormat('d MMMM, y')
                    .format(DateTime.parse(data!.dairy![i].date.toString()));
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Text(
                        formattedDate,
                        style: sFProDisplayRegular.copyWith(
                            fontSize: 16,
                            color: ColorResources.COLOR_NORMAL_BLACK),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        /*mainAxisAlignment: (widget.categoryId != '4' &&
                                widget.categoryId != '1')
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.start,*/
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              "Sets".tr,
                              style: sFProDisplayRegular.copyWith(
                                  fontSize: 16,
                                  color: ColorResources.COLOR_NORMAL_BLACK),
                            ),
                          ),
                          /*if (widget.categoryId == '1')
                            SizedBox(
                              width: Get.width * 0.2,
                            ),*/
                          if (widget.categoryId != '4')
                            Expanded(
                              child: Text(
                                widget.categoryId == '1'
                                    ? "Distance".tr
                                    : "Weight".tr,
                                style: sFProDisplayRegular.copyWith(
                                    fontSize: 16,
                                    color: ColorResources.COLOR_NORMAL_BLACK),
                              ),
                            ),
                          if (widget.categoryId != '4' &&
                              widget.categoryId != '1')
                            Expanded(
                              child: Text(
                                "Reps".tr,
                                style: sFProDisplayRegular.copyWith(
                                    fontSize: 16,
                                    color: ColorResources.COLOR_NORMAL_BLACK),
                              ),
                            ),
                          /*if (widget.categoryId == '4')
                            SizedBox(
                              width: Get.width * 0.2,
                            ),*/
                          if (widget.categoryId != '1')
                            (widget.categoryId != '4')
                                ? Container(
                                    margin: const EdgeInsets.only(right: 11),
                                    child: Text(
                                      "Time".tr,
                                      style: sFProDisplayRegular.copyWith(
                                          fontSize: 16,
                                          color: ColorResources
                                              .COLOR_NORMAL_BLACK),
                                    ),
                                  )
                                : Expanded(
                                    child: Text(
                                      "Time".tr,
                                      style: sFProDisplayRegular.copyWith(
                                          fontSize: 16,
                                          color: ColorResources
                                              .COLOR_NORMAL_BLACK),
                                    ),
                                  ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: data!.dairy![i].history!.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              /*mainAxisAlignment: (widget.categoryId != '4' &&
                                      widget.categoryId != '1')
                                  ? MainAxisAlignment.spaceBetween
                                  : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,*/
                              children: [
                                Expanded(
                                  child: Text(
                                    "${index + 1}",
                                    style: sFProDisplayRegular.copyWith(
                                        fontSize: 16,
                                        color:
                                            ColorResources.COLOR_NORMAL_BLACK),
                                  ),
                                ),
                                /*if (widget.categoryId == '1')
                                  SizedBox(
                                    width: Get.width * 0.4,
                                  ),*/
                                if (widget.categoryId != '4')
                                  Expanded(
                                    child: Text(
                                      "${data!.dairy![i].history![index].weight}",
                                      style: sFProDisplayRegular.copyWith(
                                          fontSize: 16,
                                          color: ColorResources
                                              .COLOR_NORMAL_BLACK),
                                    ),
                                  ),
                                if (widget.categoryId != '4' &&
                                    widget.categoryId != '1')
                                  Expanded(
                                    child: Text(
                                      "${data!.dairy![i].history![index].reps}",
                                      style: sFProDisplayRegular.copyWith(
                                          fontSize: 16,
                                          color: ColorResources
                                              .COLOR_NORMAL_BLACK),
                                    ),
                                  ),
                                /*if (widget.categoryId == '4')
                                  SizedBox(
                                    width: Get.width * 0.34,
                                  ),*/
                                if (widget.categoryId != '1')
                                  (widget.categoryId != '4')
                                      ? Text(
                                          "${data!.dairy![i].history![index].time}",
                                          style: sFProDisplayRegular.copyWith(
                                              fontSize: 16,
                                              color: ColorResources
                                                  .COLOR_NORMAL_BLACK),
                                        )
                                      : Expanded(
                                          child: Text(
                                            "${data!.dairy![i].history![index].time}",
                                            style: sFProDisplayRegular.copyWith(
                                                fontSize: 16,
                                                color: ColorResources
                                                    .COLOR_NORMAL_BLACK),
                                          ),
                                        ),
                              ],
                            ),
                          );
                        }),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      thickness: 1,
                    )
                  ],
                );
              },
            )
          : Center(
              child: Text('there is no exercise history'.tr),
            ),
    );
  }

  @override
  void initState() {
    con.readHistoryData(widget.id).then((value) {
      if (value != null) {
        setState(() {
          data = value;
        });
        data!.dairy!.sort((a, b) {
          return b.date!.compareTo(a.date.toString());
        });
      } else {
        data = HistoryData('', [], '');
      }
    });
    super.initState();
  }
}
