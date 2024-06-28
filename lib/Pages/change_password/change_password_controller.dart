
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../DialougBox/errorDefaultDialoug.dart';

class ChangePasswordPageController extends GetxController {
  final TextEditingController passController = TextEditingController();
  final TextEditingController currentPassController = TextEditingController();
  final RxBool allowSave = RxBool(false);
  final RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    passController.addListener(() {
      checkFields();
    });
    currentPassController.addListener(() {
      checkFields();
    });
    super.onInit();
  }

  checkFields() {
    allowSave(passController.text.isNotEmpty &&
        currentPassController.text.isNotEmpty);
  }

  changePassword() async {
    if(allowSave.isTrue) {
      isLoading(true);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: FirebaseAuth.instance.currentUser!.email!,
            password: currentPassController.text);
        try {
          await FirebaseAuth.instance.currentUser
              ?.updatePassword(passController.text);
          currentPassController.clear();
          passController.clear();
          Get.dialog(DefaultDialog(
            title: "Password change successful".tr,
            message: "Your password was changed successfully!",
            context: Get.context,
          ));
        } on FirebaseAuthException catch (e) {
          Get.dialog(DefaultDialog(
            title: "Error changing password".tr,
            context: Get.context,
            message: e.message,
          ));
        }
      } on FirebaseAuthException catch (e) {
        Get.dialog(DefaultDialog(
          title: "Wrong current password".tr,
          context: Get.context,
          message: e.message,
        ));
      }
      isLoading(false);
    }
  }
}
