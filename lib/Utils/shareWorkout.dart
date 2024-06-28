import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../controller/sharedController.dart';

class DynamicLinksApi {
  static final dynamicLink = FirebaseDynamicLinks.instance;

  static void handleDynamicLink() async {
    final PendingDynamicLinkData? data = await dynamicLink.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null && deepLink.queryParameters != null) {
      handleSuccessLinking(data!);
    }
    dynamicLink.onLink.listen((dynamicLinkData) {
      handleSuccessLinking(dynamicLinkData);
    }).onError((error) {
      if (kDebugMode) {
        print('onLink error');
        print(error.message);
      }
    });
  }

  static Future<String> createReferralLink(
      String userId, String workoutId, String workoutIndex) async {
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: 'https://wowfit.page.link',
      link: Uri.parse(
          'https://wowfit.app/share?userid=$userId&workoutid=$workoutId&workoutindex=$workoutIndex'),
      androidParameters: const AndroidParameters(
        packageName: 'com.wowfit.app',
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.wowfit.app',
        appStoreId: "6443658549"
      ),
    );

    final ShortDynamicLink shortLink =
        await dynamicLink.buildShortLink(dynamicLinkParameters);
    final Uri dynamicUrl = shortLink.shortUrl;
    return dynamicUrl.toString();
  }

  static void handleSuccessLinking(PendingDynamicLinkData data) {
    SharedController con = Get.put(SharedController());
    final Uri deepLink = data.link;

    var isRefer = deepLink.pathSegments.contains('share');
    if (isRefer) {
      var userid = deepLink.queryParameters['userid'];
      var workoutId = deepLink.queryParameters['workoutid'];
      var workoutindex = deepLink.queryParameters['workoutindex'];
      con.readAnotherUserWorkOuts(
          userid.toString(), workoutId.toString(), workoutindex.toString());
      // Get.snackbar('Data', 'data $userid : $workoutId : $workoutindex');

      print(userid.toString());
      if (userid != null) {
      } else {
        if (kDebugMode) {
          print(userid);
        }
      }
    }
  }

  /*_successC(String error) {
    ShowToast().displayToast("You got 20 points $error");
  }

  backerror(String error) {
    print('SetCODE error $error');
  }*/
}
