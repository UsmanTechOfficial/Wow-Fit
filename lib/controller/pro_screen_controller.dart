// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_android/billing_client_wrappers.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';
// import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
// import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
//
// import '../Home/Screens/proScreen/consumable_store.dart';
//
// final bool kAutoConsume = Platform.isIOS || true;
// const String kConsumableId = 'consumable';
// const String kUpgradeId = 'upgrade';
// const String kSilverSubscriptionId = 'subscription_silver';
// const String kGoldSubscriptionId = 'subscription_gold';
// const List<String> kProductIds = <String>[
//   kConsumableId,
//   kUpgradeId,
//   kSilverSubscriptionId,
//   kGoldSubscriptionId,
// ];
//
// class ProScreenController extends GetxController {
//   final InAppPurchase _inAppPurchase = InAppPurchase.instance;
//   late StreamSubscription<List<PurchaseDetails>> _subscription;
//   List<String> notFoundIds = <String>[].obs;
//   List<ProductDetails> _products = <ProductDetails>[].obs;
//   List<PurchaseDetails> _purchases = <PurchaseDetails>[].obs;
//   List<String> _consumables = <String>[].obs;
//   final isAvailable = false.obs;
//   final purchasePending = false.obs;
//   final loading = true.obs;
//   String? queryProductError;
//   List<ProductDetails> get getProducts => _products;
//   InAppPurchase get getAppPurchase => _inAppPurchase;
//   List<PurchaseDetails> get getPurchase => _purchases;
//   List<String> get getConsumables => _consumables;
//   @override
//   void onInit() {
//     final Stream<List<PurchaseDetails>> purchaseUpdated =
//         _inAppPurchase.purchaseStream;
//     _subscription =
//         purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
//       _listenToPurchaseUpdated(purchaseDetailsList);
//     }, onDone: () {
//       _subscription.cancel();
//     }, onError: (Object error) {
//       // handle error here.
//     });
//     initStoreInfo();
//     super.onInit();
//   }
//
//   Future<void> initStoreInfo() async {
//     final bool _isAvailable = await _inAppPurchase.isAvailable();
//     if (!_isAvailable) {
//       isAvailable.value = _isAvailable;
//       _products = <ProductDetails>[];
//       _purchases = <PurchaseDetails>[];
//       notFoundIds = <String>[];
//       _consumables = <String>[];
//       purchasePending.value = false;
//       loading.value = false;
//
//       return;
//     }
//
//     if (Platform.isIOS) {
//       final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
//           _inAppPurchase
//               .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//       await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
//     }
//
//     final ProductDetailsResponse productDetailResponse =
//         await _inAppPurchase.queryProductDetails(kProductIds.toSet());
//     if (productDetailResponse.error != null) {
//       queryProductError = productDetailResponse.error!.message;
//       isAvailable.value = _isAvailable;
//       _products = productDetailResponse.productDetails;
//       _purchases = <PurchaseDetails>[];
//       notFoundIds = productDetailResponse.notFoundIDs;
//       _consumables = <String>[];
//       purchasePending.value = false;
//       loading.value = false;
//       return;
//     }
//
//     if (productDetailResponse.productDetails.isEmpty) {
//       queryProductError = null;
//       isAvailable.value = _isAvailable;
//       _products = productDetailResponse.productDetails;
//       _purchases = <PurchaseDetails>[];
//       notFoundIds = productDetailResponse.notFoundIDs;
//       _consumables = <String>[];
//       purchasePending.value = false;
//       loading.value = false;
//
//       return;
//     }
//
//     final List<String> consumables = await ConsumableStore.load();
//
//     isAvailable.value = _isAvailable;
//     _products = productDetailResponse.productDetails;
//     notFoundIds = productDetailResponse.notFoundIDs;
//     _consumables = consumables;
//     purchasePending.value = false;
//     loading.value = false;
//   }
//
//   Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
//     // IMPORTANT!! Always verify a purchase before delivering the product.
//     // For the purpose of an example, we directly return true.
//     return Future<bool>.value(true);
//   }
//
//   void showPendingUI() {
//     purchasePending.value = true;
//   }
//
//   Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
//     // IMPORTANT!! Always verify purchase details before delivering the product.
//     if (purchaseDetails.productID == kConsumableId) {
//       await ConsumableStore.save(purchaseDetails.purchaseID!);
//       final List<String> consumables = await ConsumableStore.load();
//
//       purchasePending.value = false;
//       _consumables = consumables;
//     } else {
//       _purchases.add(purchaseDetails);
//       purchasePending.value = false;
//     }
//   }
//
//   Future<void> consume(String id) async {
//     await ConsumableStore.consume(id);
//     final List<String> consumables = await ConsumableStore.load();
//
//     _consumables = consumables;
//   }
//
//   void handleError(IAPError error) {
//     purchasePending.value = false;
//   }
//
//   void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
//     // handle invalid purchase here if  _verifyPurchase` failed.
//   }
//
//   GooglePlayPurchaseDetails? getOldSubscription(
//       ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
//     // This is just to demonstrate a subscription upgrade or downgrade.
//     // This method assumes that you have only 2 subscriptions under a group, 'subscription_silver' & 'subscription_gold'.
//     // The 'subscription_silver' subscription can be upgraded to 'subscription_gold' and
//     // the 'subscription_gold' subscription can be downgraded to 'subscription_silver'.
//     // Please remember to replace the logic of finding the old subscription Id as per your app.
//     // The old subscription is only required on Android since Apple handles this internally
//     // by using the subscription group feature in iTunesConnect.
//     GooglePlayPurchaseDetails? oldSubscription;
//     if (productDetails.id == kSilverSubscriptionId &&
//         purchases[kGoldSubscriptionId] != null) {
//       oldSubscription =
//           purchases[kGoldSubscriptionId]! as GooglePlayPurchaseDetails;
//     } else if (productDetails.id == kGoldSubscriptionId &&
//         purchases[kSilverSubscriptionId] != null) {
//       oldSubscription =
//           purchases[kSilverSubscriptionId]! as GooglePlayPurchaseDetails;
//     }
//     return oldSubscription;
//   }
//
//   Future<void> confirmPriceChange(BuildContext context) async {
//     if (Platform.isAndroid) {
//       final InAppPurchaseAndroidPlatformAddition androidAddition =
//           _inAppPurchase
//               .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
//       final BillingResultWrapper priceChangeConfirmationResult =
//           await androidAddition.launchPriceChangeConfirmationFlow(
//         sku: 'purchaseId',
//       );
//       if (priceChangeConfirmationResult.responseCode == BillingResponse.ok) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('Price change accepted'),
//         ));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text(
//             priceChangeConfirmationResult.debugMessage ??
//                 'Price change failed with code ${priceChangeConfirmationResult.responseCode}',
//           ),
//         ));
//       }
//     }
//     if (Platform.isIOS) {
//       final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
//           _inAppPurchase
//               .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//       await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
//     }
//   }
//
//   Future<void> _listenToPurchaseUpdated(
//       List<PurchaseDetails> purchaseDetailsList) async {
//     for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         showPendingUI();
//       } else {
//         if (purchaseDetails.status == PurchaseStatus.error) {
//           handleError(purchaseDetails.error!);
//         } else if (purchaseDetails.status == PurchaseStatus.purchased ||
//             purchaseDetails.status == PurchaseStatus.restored) {
//           final bool valid = await _verifyPurchase(purchaseDetails);
//           if (valid) {
//             deliverProduct(purchaseDetails);
//           } else {
//             _handleInvalidPurchase(purchaseDetails);
//             return;
//           }
//         }
//         if (Platform.isAndroid) {
//           if (!kAutoConsume && purchaseDetails.productID == kConsumableId) {
//             final InAppPurchaseAndroidPlatformAddition androidAddition =
//                 _inAppPurchase.getPlatformAddition<
//                     InAppPurchaseAndroidPlatformAddition>();
//             await androidAddition.consumePurchase(purchaseDetails);
//           }
//         }
//         if (purchaseDetails.pendingCompletePurchase) {
//           await _inAppPurchase.completePurchase(purchaseDetails);
//         }
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     if (Platform.isIOS) {
//       final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
//           _inAppPurchase
//               .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//       iosPlatformAddition.setDelegate(null);
//     }
//     _subscription.cancel();
//     super.dispose();
//   }
// }
//
// class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
//   @override
//   bool shouldContinueTransaction(
//       SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
//     return true;
//   }
//
//   @override
//   bool shouldShowPriceConsent() {
//     return false;
//   }
// }
