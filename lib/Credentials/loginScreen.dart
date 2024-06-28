import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:wowfit/Credentials/forgotPassword.dart';
import 'package:wowfit/DialougBox/errorDefaultDialoug.dart';
import 'package:wowfit/Home/BottomNavigation/bottomNavigationScreen.dart';
import 'package:wowfit/Models/userModel.dart';
import 'package:wowfit/Pages/select_gender_page.dart';
import 'package:wowfit/Utils/color_resources.dart';
import 'package:wowfit/Utils/styles.dart';
import 'package:wowfit/Widgets/buttonWidget.dart';
import 'package:wowfit/Widgets/inputField.dart';
import 'package:wowfit/Widgets/passwordfield.dart';
import 'package:wowfit/controller/registerController.dart';

import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final _auth = FirebaseAuth.instance;

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  bool? isFilled = false;
  bool showSpinner = false;
  bool checkBoxValue = false;
  late TextEditingController _emailController;
  late TextEditingController _passController;
  final formGlobalKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController = TextEditingController();
    _passController = TextEditingController();
    _emailController.addListener(() {
      if (_emailController.text.isNotEmpty) {
        if (_passController.text.isEmpty) {
          _passController.addListener(() {
            if (_passController.text.isNotEmpty) {
              if (_emailController.text.isNotEmpty) {
                setState(() {
                  isFilled = true;
                });
              } else {
                setState(() {
                  isFilled = false;
                });
              }
            } else {
              setState(() {
                isFilled = false;
              });
            }
          });
        } else {
          setState(() {
            isFilled = true;
          });
        }
      } else {
        setState(() {
          isFilled = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Login".tr,
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
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Form(
              key: formGlobalKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 55,
                    child: InputFields(
                      "Your Email".tr,
                      "your email".tr,
                      isEmail: true,
                      controller: _emailController,
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
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => const ForgotPassword());
                    },
                    child: Text(
                      "Forgot password".tr,
                      style: sFProDisplayMedium.copyWith(
                          fontSize: 16, color: ColorResources.COLOR_BLUE),
                    ),
                  ),
                  const Spacer(),
                  isFilled == true
                      ? InkWell(
                          onTap: () async {
                            if (_emailController.text.isNotEmpty ||
                                _passController.text.isNotEmpty) {
                              if (_emailController.text.contains('@')) {
                                if (_passController.text.length > 5) {
                                  // remove firebase
                                  setState(() {
                                    showSpinner = true;
                                  });

                                  try {
                                    final user =
                                        await _auth.signInWithEmailAndPassword(
                                            email: _emailController.text.trim(),
                                            password:
                                                _passController.text.trim());
                                    if (!user.user!.isAnonymous) {
                                      GetStorage().write(
                                          'user', user.user!.uid.toString());
                                      userId = user.user!.uid.toString();
                                      var firebaseUser = await FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc(GetStorage()
                                          .read('user')
                                          .toString()).get();
                                      currentUser = UserModel.fromJson(firebaseUser.data()!);
                                      GetStorage().write('userModel',
                                          jsonEncode(currentUser.toJson()));
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) {
                                                if(currentUser.gender!=null){
                                                  return BottomNavigationScreen(
                                                    index: 0,
                                                  );
                                                }else{
                                                  return SelectGenderPage();
                                                }
                                              }),
                                          (route) => false);
                                    }
                                  } on FirebaseAuthException catch (e) {
                                    if (Platform.isIOS) {
                                      showCupertinoDialog(
                                        context: context,
                                        builder: (_) => DefaultDialog(
                                          context: context,
                                          message: e.message,
                                        ),
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (_) => DefaultDialog(
                                          context: context,
                                          message: e.message,
                                        ),
                                      );
                                    }

                                    print(e);
                                  }
                                  setState(() {
                                    showSpinner = false;
                                  });
                                } else {
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
                          child: ButtonWidget(
                            onTap: null,
                            color: Colors.white,
                            containerColor: ColorResources.COLOR_BLUE,
                            text: "Login".tr,
                            height: 45,
                          ),
                        )
                      : ButtonWidget(
                          text: "Log in".tr,
                          height: 45,
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
