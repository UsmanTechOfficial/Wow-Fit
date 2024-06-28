import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wowfit/Home/BottomNavigation/bottomNavigationScreen.dart';
import 'package:wowfit/Home/Screens/proScreen/buyProScreen.dart';
import 'package:wowfit/Home/Screens/subscriptionScreen.dart';
import 'package:wowfit/Models/singletons_data.dart';
import 'package:wowfit/Models/userModel.dart';
import 'package:wowfit/Pages/support_screen.dart';
import 'package:wowfit/Utils/color_resources.dart';
import 'package:wowfit/Utils/showtoaist.dart';
import 'package:wowfit/Utils/styles.dart';
import 'package:wowfit/Widgets/buttonWidget.dart';
import 'package:wowfit/main.dart';

import '../../DialougBox/deleteDefaultDialoug.dart';
import '../../DialougBox/progressDialog.dart';
import '../../Pages/change_password/change_password.dart';
import '../../controller/registerController.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String dropdownValue = language == 'en_US' ? 'English' : 'Russian';
  String genderValue =
      currentUser.gender == Gender.male ? 'Male'.tr : 'Female'.tr;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => BottomNavigationScreen(
                      index: 1,
                    )),
            (route) => false);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back_sharp)),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "Settings".tr,
            style: sFProDisplayRegular.copyWith(
                fontSize: 18, color: ColorResources.COLOR_NORMAL_BLACK),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Text(
                      "Language".tr,
                      style: sFProDisplayRegular.copyWith(
                          fontSize: 16,
                          color: ColorResources.COLOR_NORMAL_BLACK),
                    ),
                    const Spacer(),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.keyboard_arrow_down_outlined,
                          color: ColorResources.COLOR_NORMAL_BLACK),
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                        if (newValue == 'English') {
                          var locale = const Locale('en_US');
                          language = 'en_US';
                          GetStorage().write('language', 'en_US');
                          Get.updateLocale(locale);
                          setState(() {
                            genderValue = currentUser.gender == Gender.male
                                ? 'Male'.tr
                                : 'Female'.tr;
                          });
                        } else {
                          var locale = const Locale('ru_RU');
                          language = 'ru_RU';
                          GetStorage().write('language', 'ru_RU');
                          Get.updateLocale(locale);
                          setState(() {
                            genderValue = currentUser.gender == Gender.male
                                ? 'Male'.tr
                                : 'Female'.tr;
                          });
                        }
                        Intl.defaultLocale =
                            language == "en_US" ? "en_US" : "ru";
                      },
                      items: <String>['English', 'Russian']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Text(
                      "Gender".tr,
                      style: sFProDisplayRegular.copyWith(
                          fontSize: 16,
                          color: ColorResources.COLOR_NORMAL_BLACK),
                    ),
                    const Spacer(),
                    DropdownButton<String>(
                      value: genderValue,
                      icon: const Icon(Icons.keyboard_arrow_down_outlined,
                          color: ColorResources.COLOR_NORMAL_BLACK),
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(),
                      onChanged: (String? newValue) async {
                        setState(() {
                          genderValue = newValue!;
                        });
                        currentUser.gender =
                            newValue == 'Male'.tr ? Gender.male : Gender.female;
                        await FirebaseFirestore.instance
                            .collection("Users")
                            .doc(currentUser.uid)
                            .set(currentUser.toJson())
                            .whenComplete(() async {
                              GetStorage().write('userModel',
                                  jsonEncode(currentUser.toJson()));
                            })
                            .timeout(const Duration(seconds: 5))
                            .catchError((e) {
                              if (kDebugMode) {
                                print(e);
                              }
                              showToast(e.message.toString());
                            });
                      },
                      items: <String>['Male'.tr, 'Female'.tr]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: InkWell(
                onTap: () {
                  showModalBottomSheet<void>(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 280,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 60,
                                height: 5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color:
                                      const Color(0xFF979797).withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Text(
                                    currentUser.email ?? "",
                                    style: sFProDisplayRegular.copyWith(
                                        fontSize: 16,
                                        color:
                                            ColorResources.COLOR_NORMAL_BLACK),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              // InkWell(
                              //   onTap: () {
                              //     Get.to(ChangePasswordPage());
                              //   },
                              //   child: Container(
                              //     height: 40,
                              //     width: MediaQuery.of(context).size.width,
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(8),
                              //       color: ColorResources.LOGOUT_BUTTON,
                              //     ),
                              //     child: Center(
                              //       child: Text(
                              //         "Change password".tr,
                              //         style: sFProDisplayRegular.copyWith(fontSize: 16, color: ColorResources.COLOR_NORMAL_BLACK),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              InkWell(
                                onTap: () async {
                                  GetStorage().remove('user');
                                  GetStorage().remove('userModel');
                                  GetStorage().erase();
                                  userId = '';
                                  currentUser = UserModel();
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CreateAccountScreen()),
                                      (route) => false);
                                },
                                child: Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: ColorResources.LOGOUT_BUTTON,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Log out".tr,
                                      style: sFProDisplayRegular.copyWith(
                                          fontSize: 16,
                                          color: ColorResources
                                              .COLOR_NORMAL_BLACK),
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
                                        errorText:
                                            "Do you want to delete account?".tr,
                                        callback: () {
                                          var mdl = UserModel.fromJson(
                                              jsonDecode(GetStorage()
                                                  .read('userModel')));
                                          deleteUser(mdl.email.toString())
                                              .then((value) async {
                                            if (value) {
                                              try {
                                                await FirebaseFirestore.instance
                                                    .collection('Users')
                                                    .doc(userId)
                                                    .delete()
                                                    .then((value) {
                                                  if (kDebugMode) {
                                                    print('User Deleted');
                                                  }
                                                  userId = '';
                                                  GetStorage().erase();
                                                  currentUser = UserModel();
                                                  Get.offAll(() =>
                                                      const CreateAccountScreen());
                                                }).catchError((error) =>
                                                        print(error));
                                              } on FirebaseException catch (e) {
                                                if (kDebugMode) {
                                                  print(e);
                                                }
                                                showToast(e.message.toString());
                                              }
                                            } else {
                                              showToast(
                                                  'User Not Deleted please try again');
                                            }
                                          });
                                        },
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (_) => DeleteDefaultDialog(
                                        context: context,
                                        errorText:
                                            "Do you want to delete account?".tr,
                                        callback: () {
                                          var mdl = UserModel.fromJson(
                                              jsonDecode(GetStorage()
                                                  .read('userModel')));
                                          deleteUser(mdl.email.toString())
                                              .then((value) async {
                                            if (value) {
                                              try {
                                                await FirebaseFirestore.instance
                                                    .collection('Users')
                                                    .doc(userId)
                                                    .delete()
                                                    .then((value) {
                                                  if (kDebugMode) {
                                                    print('User Deleted');
                                                  }
                                                  userId = '';
                                                  GetStorage().erase();
                                                  currentUser = UserModel();
                                                  Get.offAll(() =>
                                                      const CreateAccountScreen());
                                                }).catchError((error) =>
                                                        print(error));
                                              } on FirebaseException catch (e) {
                                                if (kDebugMode) {
                                                  print(e);
                                                }
                                                showToast(e.message.toString());
                                              }
                                            } else {
                                              showToast(
                                                  'User Not Deleted please try again');
                                            }
                                          });
                                        },
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: ColorResources.LOGOUT_BUTTON,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Delete account".tr,
                                      style: sFProDisplayRegular.copyWith(
                                          fontSize: 16,
                                          color: ColorResources
                                              .COLOR_NORMAL_BLACK),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: ButtonWidget(
                                  widthColor: Colors.black,
                                  containerColor: Colors.black,
                                  color: Colors.white,
                                  height: 50,
                                  text: "Back".tr,
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
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
                child: SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Text(
                        "Account".tr,
                        style: sFProDisplayRegular.copyWith(
                          fontSize: 16,
                          color: ColorResources.COLOR_NORMAL_BLACK,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: ColorResources.COLOR_NORMAL_BLACK,
                        size: 14,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: InkWell(
                onTap: () {
                  Get.to(const SupportScreen());
                },
                child: SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Text(
                        "Support".tr,
                        style: sFProDisplayRegular.copyWith(
                          fontSize: 16,
                          color: ColorResources.COLOR_NORMAL_BLACK,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: ColorResources.COLOR_NORMAL_BLACK,
                        size: 14,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: InkWell(
                onTap: () {
                  if (Platform.isAndroid) {
                    launchUrl(
                        Uri.parse(
                            "https://play.google.com/store/apps/details?id=com.wowfit.app"),
                        mode: LaunchMode.externalApplication);
                  } else {
                    launchUrl(
                        Uri.parse(
                            "https://apps.apple.com/us/app/wowfit-fitness-training-log/id6443658549"),
                        mode: LaunchMode.externalApplication);
                  }
                },
                child: SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Text(
                        "Rate & Review".tr,
                        style: sFProDisplayRegular.copyWith(
                          fontSize: 16,
                          color: ColorResources.COLOR_NORMAL_BLACK,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: ColorResources.COLOR_NORMAL_BLACK,
                        size: 14,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: InkWell(
                onTap: () async {
                  CustomProgressDialog progressDialog = defaultProgressDialog;
                  progressDialog.show();
                  var linkObject = await FirebaseFirestore.instance
                      .collection("CustomAppLinks")
                      .where("name", isEqualTo: "website")
                      .get();
                  progressDialog.dismiss();
                  launchUrl(Uri.parse(linkObject.docs.first.data()["link"]),
                      mode: LaunchMode.externalApplication);
                },
                child: SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Text(
                        "Our website".tr,
                        style: sFProDisplayRegular.copyWith(
                          fontSize: 16,
                          color: ColorResources.COLOR_NORMAL_BLACK,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: ColorResources.COLOR_NORMAL_BLACK,
                        size: 14,
                      )
                    ],
                  ),
                ),
              ),
            ),
            if (appData.entitlementIsActive.value == true)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: InkWell(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SubscriptionScreen()));
                  },
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Text(
                          "Subscription".tr,
                          style: sFProDisplayRegular.copyWith(
                            fontSize: 16,
                            color: ColorResources.COLOR_NORMAL_BLACK,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: ColorResources.COLOR_NORMAL_BLACK,
                          size: 14,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            if (appData.entitlementIsActive.value == false)
              const Divider(
                thickness: 1,
              ),
            if (appData.entitlementIsActive.value == false)
              InkWell(
                onTap: () {
                  // Get.to(() => TestPro());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BuyProScreen()));
                },
                child: SizedBox(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: Get.width / 2 + 60,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            "Buy a PRO — create workouts without a limit".tr,
                            softWrap: true,
                            maxLines: 3,
                            overflow: TextOverflow.visible,
                            style: sFProDisplayRegular.copyWith(
                              fontSize: 14,
                              color: ColorResources.COLOR_BLUE,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          color: ColorResources.COLOR_BLUE,
                          size: 24,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            if (appData.entitlementIsActive.value == false)
              const Divider(
                thickness: 1,
              ),
            const SizedBox(
              height: 50,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Version:${packageInfo!.version}'),
                Text('BuildNumber:${packageInfo!.buildNumber}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> deleteUser(String email) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.currentUser?.delete();
    } catch (e) {
      debugPrint(e.toString());
    }
    return true;
  }
}
