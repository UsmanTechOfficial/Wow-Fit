// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wowfit/BottomSheet/editBottomSheet.dart';
import 'package:wowfit/Home/BottomNavigation/bottomNavigationScreen.dart';
import 'package:wowfit/Home/Screens/proScreen/buyProScreen.dart';
import 'package:wowfit/Home/Screens/settingScreen.dart';
import 'package:wowfit/Models/WorkOutModel.dart';
import 'package:wowfit/Models/singletons_data.dart';
import 'package:wowfit/Utils/color_resources.dart';
import 'package:wowfit/Utils/styles.dart';
import 'package:wowfit/Widgets/floatingActionButton.dart';
import 'package:wowfit/WorkoutScreen/newWorkOutScreen.dart';
import 'package:wowfit/WorkoutScreen/viewWorkOutScreen.dart';
import 'package:wowfit/controller/newWorkoutController.dart';
import 'package:wowfit/controller/registerController.dart';

import '../../DialougBox/buyProDialogBox.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  NewWorkOutController con = Get.put(NewWorkOutController());
  @override
  void initState() {
    // TODO: implement initState
    con.readUserWorkOutsForCalender();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
              onPressed: () {
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
                      context: context,
                      builder: (_) => const BuyProDialogBox());
                  // }
                }
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: const FloatingActionButtonWidget()),
          body: Padding(
            padding: EdgeInsets.only(
                top: 10, left: width * 0.03, right: width * 0.03),
            child: SizedBox(
              // color: Colors.red,
              height: height,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Image.asset('assets/good.png'),
                          // backgroundImage: image,

                          radius: width * 0.1),
                      SizedBox(
                        width: width * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentUser.email!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: height * 0.025),
                            ),
                            const Text(
                              "5 ot of 1available",
                              style:
                                  TextStyle(color: ColorResources.COLOR_BLUE),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => const SettingScreen());
                        },
                        child: const Icon(Icons.settings,
                            color: ColorResources.INPUT_HINT_COLOR),
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Text(
                    "My Programs",
                    style: TextStyle(
                        fontSize: width * 0.08, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  StreamBuilder(
                    stream: con.readUserWorkOutsall(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasError) {
                        return Expanded(
                            child:
                                Center(child: Text('Something went wrong'.tr)));
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
                              WorkOutData workout = WorkOutData.fromJson(
                                  snapshot.data.docs[i].data());
                              String formattedDate = DateFormat('d MMMM EEEE')
                                  .format(DateTime.parse(
                                      workout.workDate.toString()));
                              workout.workOut!.sort((a, b) =>
                                  a.startTime!.compareTo(b.startTime!));
                              return Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   formattedDate,
                                    //   style: sFProDisplayRegular.copyWith(
                                    //       fontSize: 18,
                                    //       color: ColorResources
                                    //           .COLOR_NORMAL_BLACK),
                                    // ),
                                    // const SizedBox(
                                    //   height: 10,
                                    // ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: workout.workOut!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         ViewWorkOutScreen(
                                            //       workout: workout.workOut!,
                                            //       index: index,
                                            //       workOutData: workout,
                                            //     ),
                                            //   ),
                                            // );
                                          },
                                          child: Container(
                                            height: height * 0.13,
                                            width: width,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(18)),
                                                border: Border.all(
                                                    color: ColorResources
                                                        .INPUT_HINT_COLOR)),
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  CircleAvatar(
                                                      child: SvgPicture.asset(
                                                          workout
                                                              .workOut![index]
                                                              .img
                                                              .toString()),
                                                      backgroundColor:
                                                          Colors.white,
                                                      radius: width * 0.09),
                                                  SizedBox(
                                                    height: height * 0.08,
                                                    width: width * 0.5,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          workout
                                                              .workOut![index]
                                                              .workOutTitleName
                                                              .toString(),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15),
                                                        ),
                                                        const Text(
                                                          "Matt Damon",
                                                          style: TextStyle(
                                                              color: ColorResources
                                                                  .INPUT_HINT_COLOR),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              height * 0.001,
                                                        ),
                                                        Text(
                                                          formattedDate,
                                                          style: const TextStyle(
                                                              color: ColorResources
                                                                  .COLOR_BLUE),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const Icon(Icons
                                                      .arrow_forward_ios_outlined)
                                                ],
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
          ),
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
    required this.image,
  }) : super(key: key);

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Stack(children: [
      CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: image,
          radius: width * 0.10),
      Positioned(
          bottom: height * 0.005,
          right: width * 0.02,
          child: SvgPicture.asset("assets/icons/ic_pic_edit.svg",
              width: width * 0.06, fit: BoxFit.scaleDown))
    ]);
  }
}
