import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../Home/Screens/proScreen/constant.dart';
import '../Home/Screens/proScreen/store_config.dart';
import '../Models/singletons_data.dart';

class ProScreenController extends GetxController {
  Offerings? _offerings;
  late CustomerInfo _customerInfo;
  CustomerInfo get getCustomerInfo => _customerInfo;
  Offerings? get getOffers => _offerings;
  EntitlementInfo? activeEntitlement;
  set setCustomerInfo(CustomerInfo customerInfo) {
    _customerInfo = customerInfo;
  }

  @override
  void onInit() {
    super.onInit();
    initPlatformState().whenComplete(() => fetchData());
  }

  Future<void> initPlatformState() async {
    //  await Purchases.setDebugLogsEnabled(true);
    if (Platform.isIOS || Platform.isMacOS) {
      await Purchases.setSimulatesAskToBuyInSandbox(false);
    }

    PurchasesConfiguration configuration;
    if (StoreConfig.isForAmazonAppstore()) {
      configuration = AmazonConfiguration(StoreConfig.instance.apiKey);
    } else {
      configuration = PurchasesConfiguration(StoreConfig.instance.apiKey);
    }
    await Purchases.configure(configuration);

    await Purchases.enableAdServicesAttributionTokenCollection();

    final customerInfo = await Purchases.getCustomerInfo();
    Purchases.addReadyForPromotedProductPurchaseListener(
        (productID, startPurchase) async {
      debugPrint('Received readyForPromotedProductPurchase event for '
          'productID: $productID');

      try {
        final purchaseResult = await startPurchase.call();
        debugPrint('Promoted purchase for productID '
            '${purchaseResult.productIdentifier} completed, or product was'
            'already purchased. customerInfo returned is:'
            ' ${purchaseResult.customerInfo}');
        log(purchaseResult.customerInfo.entitlements.active.toString());
        debugPrint(
            "entitlements :${purchaseResult.customerInfo.entitlements.all[entitlementID]!.isActive}");
        (customerInfo.entitlements.active.containsKey(entitlementID))
            ? appData.entitlementIsActive.value = true
            : appData.entitlementIsActive.value = false;
      } on PlatformException catch (e) {
        debugPrint('Error purchasing promoted product: ${e.message}');
      }
    });
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      (customerInfo.entitlements.active.containsKey(entitlementID))
          ? appData.entitlementIsActive.value = true
          : appData.entitlementIsActive.value = false;
    });
    (customerInfo.entitlements.active.containsKey(entitlementID))
        ? appData.entitlementIsActive.value = true
        : appData.entitlementIsActive.value = false;

    activeEntitlement = customerInfo.entitlements.active[entitlementID];
    /*Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      appData.appUserID = await Purchases.appUserID;
      log('entitlements : ${customerInfo.entitlements.all} AND :${customerInfo.entitlements.active}');
      print(
          'entitlements : ${customerInfo.entitlements.all} AND :${customerInfo.entitlements.active}');
      (customerInfo.entitlements.active.containsKey(entitlementID))
          ? appData.entitlementIsActive.value = true
          : appData.entitlementIsActive.value = false;
      print('pro is active ${appData.entitlementIsActive.toString()}');
    });*/

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    _customerInfo = customerInfo;
    //setCustomerInfo(customerInfo);
  }

  Future<void> fetchData() async {
    Offerings? offerings;
    try {
      offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        log(offerings.current.toString());
        print(offerings.current.toString());
      }
    } on PlatformException catch (e) {
      print(e);
    }

    _offerings = offerings;
  }
}
