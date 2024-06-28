
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wowfit/Pages/change_password/change_password_controller.dart';

import '../../Utils/color_resources.dart';
import '../../Utils/styles.dart';
import '../../Widgets/buttonWidget.dart';
import '../../Widgets/passwordfield.dart';
class ChangePasswordPage extends StatelessWidget {

  ChangePasswordPage({Key? key}) : super(key: key);
  final controller = Get.put(ChangePasswordPageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Change password".tr,
          style: sFProDisplayRegular.copyWith(
              fontSize: 18, color: ColorResources.COLOR_NORMAL_BLACK),
        ),
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: ColorResources.COLOR_NORMAL_BLACK,
            ),
          )
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 55,
                    child: PassInputFields(
                      "Current password".tr,
                      "your current password".tr,
                      isPassword: true,
                      controller: controller.currentPassController,
                    ),
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    height: 55,
                    child: PassInputFields(
                      "New password".tr,
                      "your new password".tr,
                      isPassword: true,
                      controller: controller.passController,
                    ),
                  )
                ],
              ),
              Obx(
                ()=> ButtonWidget(
                  onTap: () async {
                    controller.changePassword();
                  },
                  color: controller.allowSave.isTrue?Colors.white:ColorResources.COLOR_BLUE,
                  containerColor: controller.allowSave.isTrue?ColorResources.COLOR_BLUE:Colors.white,
                  text: "Save".tr,
                  isLoading: controller.isLoading.value,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
