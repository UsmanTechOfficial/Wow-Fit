import 'dart:convert';
import 'dart:io';

import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:package_info/package_info.dart';
import 'package:wowfit/Credentials/loginScreen.dart';
import 'package:wowfit/Credentials/registerScreen.dart';
import 'package:wowfit/Home/Screens/proScreen/store_config.dart';
import 'package:wowfit/Pages/select_gender_page.dart';

import 'DialougBox/progressDialog.dart';
import 'Home/BottomNavigation/bottomNavigationScreen.dart';
import 'Home/Screens/proScreen/constant.dart';
import 'Models/userModel.dart';
import 'Utils/color_resources.dart';
import 'Utils/internetconnectionchecker.dart';
import 'Utils/notificationService.dart';
import 'Utils/shareWorkout.dart';
import 'Utils/styles.dart';
import 'controller/proController.dart';
import 'controller/registerController.dart';
import 'languages/languageLocaleString.dart';

String userId = '';
String language = 'en_US';
PackageInfo? packageInfo;
String supportID = DateTime.now().millisecondsSinceEpoch.toString();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyBuB36Lo3yxk_5DbmhYXXWkRW1AwX0BkNw',
    appId: '1:995877349439:android:18633f6899c5c13b81708a',
    messagingSenderId: '995877349439',
    projectId: 'wowfit-app',
    storageBucket: 'wowfit-app.appspot.com',
  ));
  await GetStorage.init();
  NotificationService().initNotification();
  DynamicLinksApi.handleDynamicLink();
  userId = GetStorage().read('user') ?? '';
  if (GetStorage().read('userModel') != null) {
    currentUser =
        UserModel.fromJson(jsonDecode(GetStorage().read('userModel')));
  }
  if (Platform.isIOS) {
    language = GetStorage().read('language') ?? Platform.localeName;
  } else {
    String? locale = await Devicelocale.currentLocale;
    language = GetStorage().read('language') ?? locale ?? "en_US";
  }
  if (language.contains("ru")) {
    language = "ru_RU";
  } else {
    language = "en_US";
  }
  Intl.defaultLocale = language == "en_US" ? "en_US" : "ru";
  CheckInternet().listener;
  if (Platform.isIOS || Platform.isMacOS) {
    StoreConfig(
      store: Store.appleStore,
      apiKey: appleApiKey,
    );
  } else if (Platform.isAndroid) {
    // Run the app passing --dart-define=AMAZON=true
    const useAmazon = bool.fromEnvironment("amazon");
    StoreConfig(
      store: useAmazon ? Store.amazonAppstore : Store.googlePlay,
      apiKey: useAmazon ? amazonApiKey : googleApiKey,
    );
  }
  Get.put(ProScreenController());
  packageInfo = await PackageInfo.fromPlatform();
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: LocaleString(),
      locale: Locale(language),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: userId.isNotEmpty
          ? currentUser.gender != null
              ? BottomNavigationScreen(
                  index: 0,
                )
              : SelectGenderPage()
          : const CreateAccountScreen(),
    );
  }
}

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Text(
                        "WellnessPlan",
                        style: sFProDisplayRegular.copyWith(
                            fontSize: 24,
                            color: ColorResources.COLOR_NORMAL_BLACK),
                      ),
                    ),
                    Image.asset(
                      'assets/logo.png',
                      width: 125,
                      height: 130,
                      fit: BoxFit.fill,
                    ),
                    Text(
                      "Plan your first workout!".tr,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                      style: sFProDisplayRegular.copyWith(
                          fontSize: 24,
                          color: ColorResources.COLOR_NORMAL_BLACK),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: MaterialButton(
                            color: ColorResources.COLOR_BLUE,
                            padding: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(48)),
                            onPressed: () async {
                              CustomProgressDialog progressDialog =
                                  defaultProgressDialog;
                              // progressDialog.show();
                              await userController.signInWithApple();
                              progressDialog.dismiss();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset("assets/apple_logo.png",
                                    height: 24),
                                Text(
                                  "apple_continue".tr,
                                  style: sFProDisplayMedium.copyWith(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: MaterialButton(
                            padding: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(48),
                                side: const BorderSide(
                                    color: ColorResources.COLOR_BLUE)),
                            onPressed: () async {
                              CustomProgressDialog progressDialog =
                                  defaultProgressDialog;
                              // progressDialog.show();
                              await userController.signInWithGoogle();
                              progressDialog.dismiss();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset("assets/google_logo.png",
                                    height: 24),
                                Text(
                                  "google_continue".tr,
                                  style: sFProDisplayMedium.copyWith(
                                      fontSize: 18,
                                      color: ColorResources.COLOR_BLUE),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Have an account?".tr,
                                style: sFProDisplayRegular.copyWith(
                                    fontSize: 16,
                                    color: ColorResources.COLOR_LIGHT_BLACk),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => const LoginScreen());
                                },
                                child: Text(
                                  " Log in".tr,
                                  style: sFProDisplayRegular.copyWith(
                                      fontSize: 16,
                                      color: ColorResources.COLOR_BLUE),
                                ),
                              )
                            ]),
                      ],
                    ),
                  ]),
            ),
          ),
        )));
  }

  @override
  void initState() {
    CheckInternet().listener.cancel();
    super.initState();
  }
}
