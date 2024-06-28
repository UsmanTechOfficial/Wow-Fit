import 'package:get/get.dart';

class AppData {
  static final AppData _appData = AppData._internal();

  var entitlementIsActive = false.obs;
  String appUserID = '';

  factory AppData() {
    return _appData;
  }
  AppData._internal();
}

final appData = AppData();
