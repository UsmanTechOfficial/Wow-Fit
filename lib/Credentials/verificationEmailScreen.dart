import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wowfit/Credentials/loginScreen.dart';
import 'package:wowfit/Utils/color_resources.dart';
import 'package:wowfit/Utils/styles.dart';
import 'package:wowfit/Widgets/buttonWidget.dart';

class VerificationEmailScreen extends StatefulWidget {
  const VerificationEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerificationEmailScreen> createState() =>
      _VerificationEmailScreenState();
}

class _VerificationEmailScreenState extends State<VerificationEmailScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
        return true;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Successfully".tr,
                      style: sFProDisplayBold.copyWith(
                          fontSize: 30,
                          color: ColorResources.COLOR_NORMAL_BLACK),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "sent an email to reset your password".tr,
                      style: sFProDisplayMedium.copyWith(
                          fontSize: 16,
                          color: ColorResources.COLOR_NORMAL_BLACK),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (route) => false);
                },
                child: ButtonWidget(
                  height: 50,
                  text: 'Continue'.tr,
                  color: Colors.white,
                  containerColor: ColorResources.COLOR_BLUE,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
