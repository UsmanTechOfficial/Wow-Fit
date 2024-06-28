import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wowfit/Models/userModel.dart';
import 'package:wowfit/controller/registerController.dart';
import '../Home/BottomNavigation/bottomNavigationScreen.dart';
import '../Utils/color_resources.dart';
import '../Utils/showtoaist.dart';
import '../Utils/styles.dart';
import '../Widgets/buttonWidget.dart';

class SelectGenderPage extends StatelessWidget {
  SelectGenderPage({Key? key}) : super(key: key);
  RxBool isMale = RxBool(true);
  RxBool loading = RxBool(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "To give you correct exercises we need to know your gender".tr,
          style: sFProDisplayRegular.copyWith(
              fontSize: 18, color: ColorResources.COLOR_NORMAL_BLACK),
          maxLines: 3,
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => RawMaterialButton(
                    onPressed: () {
                      isMale(true);
                    },
                    elevation: 0,
                    fillColor: isMale.isFalse
                        ? ColorResources.COLOR_LIGHT_BLACk
                        : ColorResources.COLOR_BLUE,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.male_rounded,
                          size: 100.0,
                          color: Colors.white,
                        ),
                        Text(
                          "Male".tr,
                          style: sFProDisplayMedium.copyWith(
                              fontSize: 16, color: Colors.white),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(30.0),
                    shape: const CircleBorder(),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Obx(
                  () => RawMaterialButton(
                    onPressed: () {
                      isMale(false);
                    },
                    elevation: 0,
                    fillColor: isMale.isTrue
                        ? ColorResources.COLOR_LIGHT_BLACk
                        : ColorResources.COLOR_BLUE,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.female_rounded,
                          size: 100.0,
                          color: Colors.white,
                        ),
                        Text(
                          "Female".tr,
                          style: sFProDisplayMedium.copyWith(
                              fontSize: 16, color: Colors.white),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(30.0),
                    shape: const CircleBorder(),
                  ),
                )
              ],
            )),
            SizedBox(
              height: 45,
              child: Obx(
                ()=> ButtonWidget(
                  onTap: () async {
                    currentUser.gender =
                        isMale.isTrue ? Gender.male : Gender.female;
                    loading(true);
                    await FirebaseFirestore.instance
                        .collection("Users")
                        .doc(currentUser.uid)
                        .set(currentUser.toJson())
                        .whenComplete(() async {
                          GetStorage().write(
                              'userModel', jsonEncode(currentUser.toJson()));
                          Get.offAll(() => BottomNavigationScreen(
                                index: 0,
                              ));
                        })
                        .timeout(const Duration(seconds: 5))
                        .catchError((e) {
                          if (kDebugMode) {
                            print(e);
                          }
                          showToast(e.message.toString());
                        });
                    loading(false);
                    Get.off(() => BottomNavigationScreen(
                          index: 0,
                        ));
                  },
                  color: Colors.white,
                  containerColor: ColorResources.COLOR_BLUE,
                  text: "Next".tr,
                  isLoading: loading.value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
