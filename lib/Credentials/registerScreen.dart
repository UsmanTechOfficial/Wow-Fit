import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wowfit/DialougBox/errorDefaultDialoug.dart';
import 'package:wowfit/Utils/color_resources.dart';
import 'package:wowfit/Utils/styles.dart';
import 'package:wowfit/Widgets/buttonWidget.dart';
import 'package:wowfit/Widgets/inputField.dart';
import 'package:wowfit/Widgets/passwordfield.dart';
import 'package:wowfit/controller/registerController.dart';
import 'package:wowfit/main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  UserController con = Get.put(UserController());
  bool checkBoxValue = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Create account".tr,
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
          ),
        ),
        body: Obx(() => ModalProgressHUD(
              inAsyncCall: con.showSpinner.value,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 55,
                        child: InputFields(
                          "Your email".tr,
                          "your email".tr,
                          isEmail: true,
                          controller: _emailController,
                          callback: (val) {},
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 55,
                        child: PassInputFields(
                          "Password".tr,
                          "your Password".tr,
                          isPassword: true,
                          controller: _passController,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Transform.scale(
                            scale: 1.4,
                            child: Checkbox(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                value: checkBoxValue,
                                activeColor: ColorResources.COLOR_BLUE,
                                onChanged: (newValue) {
                                  setState(() {
                                    checkBoxValue = newValue!;
                                  });
                                }),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'By continuing, you agree to our'.tr,
                                  style: sFProDisplayRegular.copyWith(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 12,
                                      color: ColorResources.COLOR_NORMAL_BLACK),
                                ),
                                language == 'ru_RU'
                                    ? const TextSpan(text: '\n')
                                    : const TextSpan(text: ''),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      _launchUrl(Uri.parse(
                                          'https://wowfit.app/terms-conditions'));
                                    },
                                  text: ' Terms of Service\n'.tr,
                                  style: sFProDisplayRegular.copyWith(
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                      color: ColorResources.COLOR_BLUE),
                                ),
                                TextSpan(
                                  text: ' and'.tr,
                                  style: sFProDisplayRegular.copyWith(
                                      fontSize: 12,
                                      color: ColorResources.COLOR_NORMAL_BLACK),
                                ),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      _launchUrl(Uri.parse(
                                          'https://wowfit.app/privacy-policy'));
                                    },
                                  text: ' Privacy Policy'.tr,
                                  style: sFProDisplayRegular.copyWith(
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                      color: ColorResources.COLOR_BLUE),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _emailController.text.isNotEmpty &&
                              _passController.text.isNotEmpty &&
                              checkBoxValue == true
                          ? SizedBox(
                              height: 45,
                              child: ButtonWidget(
                                onTap: () async {
                                  if (_emailController.text.isNotEmpty ||
                                      _passController.text.isNotEmpty) {
                                    if (_emailController.text.contains('@')) {
                                      if (_passController.text.length > 5) {
                                        /*Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BottomNavigationScreen(
                                            index: 0,
                                          )),
                                  (route) => false);*/
                                        // remove firebase

                                        con.showSpinner.value = true;

                                        try {
                                          final newUser = await _auth
                                              .createUserWithEmailAndPassword(
                                                  email: _emailController.text
                                                      .trim(),
                                                  password: _passController.text
                                                      .trim());
                                          if (newUser.user != null) {
                                            con.registerUser(newUser);
                                          }
                                        } on FirebaseAuthException catch (e) {
                                          if (Platform.isIOS) {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (_) =>
                                                  DefaultDialog(
                                                context: context,
                                                message: e.message,
                                              ),
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  DefaultDialog(
                                                context: context,
                                                message: e.message,
                                              ),
                                            );
                                          }
                                          print(e.message);
                                        }
                                        con.showSpinner.value = false;
                                      } else {
                                        con.showSpinner.value = false;

                                        if (Platform.isIOS) {
                                          showCupertinoDialog(
                                            context: context,
                                            builder: (_) => DefaultDialog(
                                              context: context,
                                              message:
                                                  "Password length must be greater than 6."
                                                      .tr,
                                            ),
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (_) => DefaultDialog(
                                              context: context,
                                              message:
                                                  "Password length must be greater than 6."
                                                      .tr,
                                            ),
                                          );
                                        }
                                      }
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
                                  } else {
                                    if (Platform.isIOS) {
                                      showCupertinoDialog(
                                        context: context,
                                        builder: (_) => DefaultDialog(
                                          context: context,
                                          message: "Field is Required.".tr,
                                        ),
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (_) => DefaultDialog(
                                          context: context,
                                          message: "Field is Required.".tr,
                                        ),
                                      );
                                    }
                                  }
                                },
                                color: Colors.white,
                                containerColor: ColorResources.COLOR_BLUE,
                                text: "Register".tr,
                              ),
                            )
                          : SizedBox(
                              height: 45,
                              child: ButtonWidget(
                                onTap: () {},
                                text: "Register".tr,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
