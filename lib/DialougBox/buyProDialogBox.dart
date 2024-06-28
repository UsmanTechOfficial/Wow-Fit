import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wowfit/Home/Screens/proScreen/buyProScreen.dart';

class BuyProDialogBox extends StatelessWidget {
  const BuyProDialogBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget yesButton = TextButton(
      child: Text(
        "Buy Pro".tr,
        style: const TextStyle(
            color: Color(0xFF1B5DEC),
            fontWeight: FontWeight.bold,
            fontSize: 18),
      ),
      onPressed: () {
        Get.back();
        Get.to(() => const BuyProScreen());
      },
    );
    Widget noButton = TextButton(
      child: Text(
        "Cancel".tr,
        style: const TextStyle(
            color: Color(0xFF99B5F2),
            fontWeight: FontWeight.normal,
            fontSize: 18),
      ),
      onPressed: () {
        Get.back();
      },
    );
    // if (Platform.isIOS) {
    //   return CupertinoAlertDialog(
    //     title: Align(alignment: Alignment.center, child: Text('Oops'.tr)),
    //     content: Text(
    //       'In the free version, you can create only one workout in the schedule. To create more workouts, buy a subscription'
    //           .tr,
    //       textAlign: TextAlign.center,
    //     ),
    //     actions: <Widget>[
    //       CupertinoDialogAction(child: noButton),
    //       CupertinoDialogAction(child: yesButton),
    //     ],
    //   );
    // }
    return AlertDialog(
      title: Align(alignment: Alignment.center, child: Text('Oops'.tr)),
      content: Text(
        'In the free version, you can create only one workout in the schedule. To create more workouts, buy a subscription'
            .tr,
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        noButton,
        yesButton,
      ],
    );
  }
}
