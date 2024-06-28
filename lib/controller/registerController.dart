import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wowfit/Credentials/verificationEmailScreen.dart';
import 'package:wowfit/Models/userModel.dart';
import 'package:wowfit/Utils/showtoaist.dart';
import 'package:wowfit/main.dart';

import '../DialougBox/errorDefaultDialoug.dart';
import '../Home/BottomNavigation/bottomNavigationScreen.dart';
import '../Models/ExceriseCategories.dart';
import '../Models/listofExercise.dart';
import '../Pages/select_gender_page.dart';

UserModel currentUser = UserModel();

class UserController extends GetxController {
  var showSpinner = false.obs;

  Future<void> registerUser(UserCredential auth) async {
    currentUser.uid = auth.user!.uid;
    currentUser.email = auth.user!.email;
    userId = auth.user!.uid.toString();
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(auth.user!.uid)
        .set(currentUser.toJson())
        .whenComplete(() async {
          GetStorage().remove('user');
          GetStorage().erase();
          GetStorage().write('user', auth.user!.uid.toString());
          GetStorage().write('userModel', jsonEncode(currentUser.toJson()));
          BuiltinCategories builtinCate = BuiltinCategories();
          builtinCate.id = auth.user!.uid.toString();
          builtinCate.subCategories = [];
          builtinCate.subCategories!.addAll(builtinCategories);
          try {
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(auth.user!.uid.toString())
                .collection('SubCategories')
                .doc('subCate')
                .set(builtinCate.toJson())
                .timeout(const Duration(seconds: 5))
                .catchError((e) {
              showToast(e.message.toString());
            });
          } on FirebaseException catch (e) {
            if (kDebugMode) {
              print(e.message);
            }
            showToast(e.message.toString());
          }
          showSpinner.value = false;
          Get.offAll(() => SelectGenderPage());
        })
        .timeout(const Duration(seconds: 5))
        .catchError((e) {
          if (kDebugMode) {
            print(e);
          }
          showToast(e.message.toString());
        });
  }

  Future<void> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      if(googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final userCredentials = await FirebaseAuth.instance.signInWithCredential(credential);
        await loginWithCredentials(userCredentials);
      }else{
        throw FirebaseAuthException(code: "0",message: "Failed to sign in");
      }
    } on FirebaseAuthException catch (e) {
        // showDialog(
        //   context: Get.context!,
        //   builder: (_) => DefaultDialog(
        //     context: Get.context!,
        //     message: e.message,
        //   ),
        // );
    }
    return;
  }

  Future<void> signInWithApple() async {
    try {
      final appleProvider = AppleAuthProvider();
      final userCredentials =await FirebaseAuth.instance.signInWithProvider(appleProvider);
      await loginWithCredentials(userCredentials);
    } on FirebaseAuthException catch (e) {
      // if (Platform.isIOS) {
      //   showCupertinoDialog(
      //     context: Get.context!,
      //     builder: (_) => DefaultDialog(
      //       context: Get.context!,
      //       message: e.message,
      //     ),
      //   );
      // } else {
      //   showDialog(
      //     context: Get.context!,
      //     builder: (_) => DefaultDialog(
      //       context: Get.context!,
      //       message: e.message,
      //     ),
      //   );
      // }
    }
    return;
  }

  loginWithCredentials(UserCredential userCredentials) async {
    // Once signed in, return the UserCredential
    var firebaseUser = await FirebaseFirestore.instance.collection('Users').doc(userCredentials.user!.uid.toString()).get();
    if (firebaseUser.exists) {
      loginUser(userCredentials);
    } else {
      registerUser(userCredentials);
    }
  }

  loginUser(UserCredential userCredentials) async {
    if (!userCredentials.user!.isAnonymous) {
      GetStorage().write('user', userCredentials.user!.uid.toString());
      userId = userCredentials.user!.uid.toString();
      var firebaseUser = await FirebaseFirestore.instance.collection('Users').doc(GetStorage().read('user').toString()).get();
      currentUser = UserModel.fromJson(firebaseUser.data()!);
      GetStorage().write('userModel', jsonEncode(currentUser.toJson()));
      Navigator.pushAndRemoveUntil(Get.context!, MaterialPageRoute(builder: (context) {
        if (currentUser.gender != null) {
          return BottomNavigationScreen(
            index: 0,
          );
        } else {
          return SelectGenderPage();
        }
      }), (route) => false);
    }
  }

  Future signOut(var _auth) async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> resetPassword(var context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password Reset Email Sent!".tr)));
      Get.to(() => const VerificationEmailScreen());
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.toString())));
      Navigator.pop(context);
    }
  }
}
