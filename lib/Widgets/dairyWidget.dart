import 'package:flutter/material.dart';
import 'package:wowfit/WorkoutScreen/newWorkOutScreen.dart';

import '../Models/userAddedExcercise.dart';
import '../controller/newWorkoutController.dart';

class DairyWidget extends StatefulWidget {
  List<UserList> userList;
  bool isOpenSuperSet;
  int i;
  int indexValue;
  NewWorkOutController con;
  DairyWidget(
      {Key? key,
      required this.userList,
      required this.isOpenSuperSet,
      required this.i,
      required this.indexValue,
      required this.con})
      : super(key: key);

  @override
  State<DairyWidget> createState() => _DairyWidgetState();
}

class _DairyWidgetState extends State<DairyWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.isOpenSuperSet == true
          ? const EdgeInsets.only(
              left: 40,
              //right: 4,
              top: 0,
              bottom: 0)
          : const EdgeInsets.only(left: 0, right: 4, top: 0, bottom: 0),
      child: widget.userList[widget.i].isItemSelect == true
          ? Column(
              children: [
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: userList[widget.i].items.isEmpty
                      ? [const SizedBox()]
                      : widget.userList[widget.i].items,
                ),
                /*widget.userList[widget.i].isAddData == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomContainer(
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Container(
                                margin: const EdgeInsets.only(
                                    bottom: 5, left: 4, right: 4),
                                height: 36,
                                width: 35,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1.0,
                                    color: const Color(0xFF767680)
                                        .withOpacity(0.12),
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Text(
                                    "2",
                                    style: sFProDisplayMedium.copyWith(
                                        fontSize: 22,
                                        color:
                                            ColorResources.COLOR_NORMAL_BLACK),
                                  ),
                                ),
                              ),
                            ),
                            value: widget.userList[widget.i].selectedIndex ==
                                    widget.indexValue - 1
                                ? CustomContainer.BOTTOM
                                : CustomContainer.MID,
                            height: 45,
                          ),
                          // const SizedBox(
                          //   width: 10,
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: ColorResources.INPUT_BORDER,
                                  border: Border.all(
                                      color: ColorResources.INPUT_BORDER),
                                  borderRadius: BorderRadius.circular(5)),
                              height: 35,
                              width: 65,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: TimeInputFields(
                                    "weight",
                                    "your email",
                                    isEmail: true,
                                    controller: null,
                                    callback: (value) {
                                      print('2');
                                      */ /*userList[i]
                                                                          .dairy!
                                                                          .history2!
                                                                          .id =
                                                                      2.toString();
                                                                  userList[i]
                                                                      .dairy!
                                                                      .history2!
                                                                      .weight = value;
                                                                  userList[i]
                                                                      .dairy!
                                                                      .history2!
                                                                      .playBtn = false;
                                                                  userList[i]
                                                                      .dairy!
                                                                      .history2!
                                                                      .time = "00:00";*/ /*
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          */ /*const SizedBox(
                                                            width: 10,
                                                          ),*/ /*
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: ColorResources.INPUT_BORDER,
                                  border: Border.all(
                                      color: ColorResources.INPUT_BORDER),
                                  borderRadius: BorderRadius.circular(5)),
                              height: 35,
                              width: 65,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: TimeInputFields(
                                    "reps",
                                    "your email",
                                    isEmail: true,
                                    controller: null,
                                    callback: (value) {
                                      */ /*userList[i]
                                                                      .dairy!
                                                                      .history2!
                                                                      .reps = value;*/ /*
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // const SizedBox(
                          //   width: 10,
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: ColorResources.INPUT_BORDER,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(5)),
                              height: 35,
                              width: 65,
                              child: Center(
                                child: Text(
                                  "00:00",
                                  style: sFProDisplayRegular.copyWith(
                                      fontSize: 20,
                                      color: ColorResources.LIGHT_TITLE_TEXT),
                                ),
                              ),
                            ),
                          ),
                          */ /*const SizedBox(
                                                            width: 10,
                                                          ),*/ /*
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              height: 24,
                              width: 24,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: ColorResources.LIGHT_TITLE_TEXT,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Image.asset(
                                  "assets/play.png",
                                  color: ColorResources.LIGHT_TITLE_TEXT,
                                  height: 18,
                                  width: 18,
                                ),
                              ),
                            ),
                          ),
                          */ /*const Spacer(),*/ /*
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.transparent,
                                        spreadRadius: 2)
                                  ],
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.add,
                                    color: ColorResources.COLOR_NORMAL_BLACK,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),*/
              ],
            )
          : Column(
              children: [
                /*  Padding(
                  padding: const EdgeInsets.only(left: 2, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
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
                            "1",
                            style: sFProDisplayMedium.copyWith(
                                fontSize: 22,
                                color: ColorResources.COLOR_NORMAL_BLACK),
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   width: 5,
                      // ),
                      Container(
                        decoration: BoxDecoration(
                            color: ColorResources.INPUT_BORDER,
                            border:
                                Border.all(color: ColorResources.INPUT_BORDER),
                            borderRadius: BorderRadius.circular(5)),
                        height: 35,
                        width: 65,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: TimeInputFields(
                              "weight",
                              "your email",
                              isEmail: true,
                              controller: null,
                              callback: (value) {
                                print("1 $value");
                                setState(() {
                                  */ /*userList[i]
                                                                  .weight1Controller!
                                                                  .text = value;*/ /*
                                  final date = DateTime.now();
                                  String dateFormated =
                                      DateFormat("yyyy-MM-dd").format(date);
                                  widget.con.history.date = dateFormated;
                                  widget.con.history.exerciseName = widget
                                      .userList[widget.i].title
                                      .toString();
                                  widget.con.history.dairy!.add(Dairy(
                                    date: dateFormated,
                                    history: UserHistoryModel(
                                      id: '',
                                      number: '1',
                                      playBtn: false,
                                      weight: value,
                                      reps: '',
                                      tick: false,
                                      time: '00:00',
                                    ),
                                    history2: UserHistoryModel(),
                                  ));
                                });

                                widget.con.uploadHistoryData(
                                    widget.con.history.exerciseName.toString(),
                                    widget.con.history);
                              },
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   width: 5,
                      // ),
                      Container(
                        decoration: BoxDecoration(
                            color: ColorResources.INPUT_BORDER,
                            border:
                                Border.all(color: ColorResources.INPUT_BORDER),
                            borderRadius: BorderRadius.circular(5)),
                        height: 35,
                        width: 65,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: TimeInputFields(
                              "reps",
                              "your email",
                              isEmail: true,
                              controller: null,
                              callback: (value) {
                                */ /*userList[i]
                                                                .dairy!
                                                                .history!
                                                                .reps = value;*/ /*
                              },
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   width: 5,
                      // ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: ColorResources.INPUT_BORDER, width: 1),
                            borderRadius: BorderRadius.circular(5)),
                        height: 35,
                        width: 65,
                        child: Center(
                          child: Text(
                            "10:32",
                            style: sFProDisplayRegular.copyWith(
                                fontSize: 20,
                                color: ColorResources.LIGHT_TITLE_TEXT),
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   width: 5,
                      // ),
                      Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.0,
                            color: ColorResources.LIGHT_TITLE_TEXT,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/pause.png",
                            color: ColorResources.LIGHT_TITLE_TEXT,
                            height: 18,
                            width: 18,
                          ),
                        ),
                      ),
                      */ /*const Spacer(),*/ /*
                      widget.userList[widget.i].isFilledBlue == true
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  widget.userList[widget.i].isFilledBlue =
                                      false;
                                });
                              },
                              child: Container(
                                height: 24,
                                width: 24,
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
                              onTap: () {
                                if (widget.userList[widget.i].isAddData ==
                                    false) {
                                  setState(() {
                                    widget.userList[widget.i].isAddData = true;
                                    widget.userList[widget.i].isDownData = true;
                                    */ /*if (widget
                                        .userList[widget.i].items.isEmpty) {
                                      widget.userList[widget.i].items = [];
                                    }*/ /*
                                    widget.userList[widget.i].items
                                        .add(DairyWidgetTwo(
                                      items: widget.userList[widget.i].items,
                                      con: widget.con,
                                      userList: widget.userList,
                                      indexValue: widget.indexValue,
                                      i: widget.i,
                                      isOpenSuperSet: widget.isOpenSuperSet,
                                    ));
                                    */ /*userList[i]
                                                                        .dairy!
                                                                        .history!
                                                                        .tick =
                                                                    false;*/ /*
                                  });
                                } else {
                                  setState(() {
                                    widget.userList[widget.i].isFilledBlue =
                                        true;
                                    */ /*userList[i]
                                                                    .dairy!
                                                                    .history!
                                                                    .tick = true;*/ /*
                                  });
                                }
                              },
                              child: Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1.0,
                                    color:
                                        widget.userList[widget.i].isAddData ==
                                                true
                                            ? ColorResources.LIGHT_TITLE_TEXT
                                            : Colors.transparent,
                                  ),
                                  color: widget.userList[widget.i].isAddData ==
                                          true
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                    child: SvgPicture.asset(
                                        widget.userList[widget.i].isAddData ==
                                                true
                                            ? "assets/check.svg"
                                            : "assets/add.svg",
                                        color: widget.userList[widget.i]
                                                    .isAddData ==
                                                true
                                            ? ColorResources.LIGHT_TITLE_TEXT
                                            : ColorResources
                                                .COLOR_NORMAL_BLACK)),
                              ),
                            ),
                    ],
                  ),
                ),*/
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  //  itemCount: userList[widget.i].items!.length,
                  // itemBuilder: (BuildContext context, int index) {
                  //   return userList[widget.i].items![index];
                  // },
                  children: userList[widget.i].items.isEmpty
                      ? [const SizedBox()]
                      : userList[widget.i].items,
                ),
                /*userList[i].isAddData == true
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 2, bottom: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          child: Container(
                                                            height: 36,
                                                            width: 35,
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                width: 1.0,
                                                                color: const Color(
                                                                        0xFF767680)
                                                                    .withOpacity(
                                                                        0.12),
                                                              ),
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                "2",
                                                                style: sFProDisplayMedium
                                                                    .copyWith(
                                                                        fontSize:
                                                                            22,
                                                                        color: ColorResources
                                                                            .COLOR_NORMAL_BLACK),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        // const SizedBox(
                                                        //   width: 5,
                                                        // ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                color: ColorResources
                                                                    .INPUT_BORDER,
                                                                border: Border.all(
                                                                    color: ColorResources
                                                                        .INPUT_BORDER),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            height: 35,
                                                            width: 65,
                                                            child: Center(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            5),
                                                                child:
                                                                    TimeInputFields(
                                                                  "weight",
                                                                  "your email",
                                                                  isEmail: true,
                                                                  controller:
                                                                      null,
                                                                  callback:
                                                                      (value) {
                                                                    print(
                                                                        '2 weight');
                                                                    */
                /*userList[i]
                                                                        .dairy!
                                                                        .history2!
                                                                        .id = 2.toString();
                                                                    userList[i]
                                                                        .dairy!
                                                                        .history2!
                                                                        .weight = value;
                                                                    userList[i]
                                                                        .dairy!
                                                                        .history2!
                                                                        .playBtn = false;
                                                                    userList[i]
                                                                        .dairy!
                                                                        .history2!
                                                                        .time = "00:00";*/
                /*
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        // const SizedBox(
                                                        //   width: 5,
                                                        // ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                color: ColorResources
                                                                    .INPUT_BORDER,
                                                                border: Border.all(
                                                                    color: ColorResources
                                                                        .INPUT_BORDER),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            height: 35,
                                                            width: 65,
                                                            child: Center(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            5),
                                                                child:
                                                                    TimeInputFields(
                                                                  "reps",
                                                                  "your email",
                                                                  isEmail: true,
                                                                  controller:
                                                                      null,
                                                                  callback:
                                                                      (value) {
                                                                    */
                /*userList[i]
                                                                        .dairy!
                                                                        .history2!
                                                                        .reps = value;*/
                /*
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        // const SizedBox(
                                                        //   width: 5,
                                                        // ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                border: Border.all(
                                                                    color: ColorResources
                                                                        .INPUT_BORDER,
                                                                    width: 1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            height: 35,
                                                            width: 65,
                                                            child: Center(
                                                              child: Text(
                                                                "00:00",
                                                                style: sFProDisplayRegular
                                                                    .copyWith(
                                                                        fontSize:
                                                                            20,
                                                                        color: ColorResources
                                                                            .LIGHT_TITLE_TEXT),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        // const SizedBox(
                                                        //   width: 5,
                                                        // ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          child: Container(
                                                            height: 24,
                                                            width: 24,
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                width: 1.0,
                                                                color: ColorResources
                                                                    .LIGHT_TITLE_TEXT,
                                                              ),
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                            ),
                                                            child: Center(
                                                              child:
                                                                  Image.asset(
                                                                "assets/play.png",
                                                                color: ColorResources
                                                                    .LIGHT_TITLE_TEXT,
                                                                height: 18,
                                                                width: 18,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        // const Spacer(),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          child: InkWell(
                                                            onTap: () {},
                                                            child: Container(
                                                              height: 25,
                                                              width: 25,
                                                              decoration:
                                                                  BoxDecoration(
                                                                boxShadow: const [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .transparent,
                                                                      spreadRadius:
                                                                          2)
                                                                ],
                                                                color: Colors
                                                                    .transparent,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              child:
                                                                  const Center(
                                                                      child:
                                                                          Icon(
                                                                Icons.add,
                                                                color: ColorResources
                                                                    .COLOR_NORMAL_BLACK,
                                                              )),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(),*/
              ],
            ),
    );
  }

  /*@override
  void initState() {

  }*/
}
