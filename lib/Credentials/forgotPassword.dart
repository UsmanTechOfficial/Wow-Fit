import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wowfit/Credentials/loginScreen.dart';
import 'package:wowfit/DialougBox/errorDefaultDialoug.dart';
import 'package:wowfit/Utils/color_resources.dart';
import 'package:wowfit/Utils/styles.dart';
import 'package:wowfit/Widgets/buttonWidget.dart';
import 'package:wowfit/Widgets/inputField.dart';
import 'package:wowfit/controller/registerController.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool showBlue = false;
  final TextEditingController _emailController = TextEditingController();
  UserController con = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Create account".tr,
            style: sFProDisplayRegular.copyWith(fontSize: 18, color: ColorResources.COLOR_NORMAL_BLACK),
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
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            children: [
              SizedBox(
                height: 55,
                child: InputFields(
                  "Your Email".tr,
                  "your email".tr,
                  isEmail: true,
                  controller: _emailController,
                  callback: (val) {
                    if (val.isNotEmpty) {
                      setState(() {
                        showBlue = true;
                      });
                    } else {
                      showBlue = false;
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "key.spam.desc".tr,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                height: 45,
                child: ButtonWidget(
                  onTap: () {
                    if (_emailController.text.contains('@')) {
                      con.resetPassword(context, _emailController.text);
                    } else {
                      if (Platform.isIOS) {
                        showCupertinoDialog(
                          context: context,
                          builder: (_) => DefaultDialog(
                            context: context,
                            message: "Email is in valid".tr,
                          ),
                        );
                      } else {
                        if (Platform.isIOS) {
                          showCupertinoDialog(
                            context: context,
                            builder: (_) => DefaultDialog(
                              context: context,
                              message: "Email is in valid".tr,
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) => DefaultDialog(
                              context: context,
                              message: "Email is in valid".tr,
                            ),
                          );
                        }
                      }
                    }
                  },
                  color: showBlue ? Colors.white : null,
                  containerColor: showBlue ? ColorResources.COLOR_BLUE : null,
                  text: "Reset password".tr,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
