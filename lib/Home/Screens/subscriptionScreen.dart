import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:wowfit/Home/BottomNavigation/bottomNavigationScreen.dart';
import 'package:wowfit/Home/Screens/proScreen/constant.dart';
import 'package:wowfit/Utils/color_resources.dart';
import 'package:wowfit/Utils/styles.dart';
import 'package:wowfit/Widgets/buttonWidget.dart';
import 'package:wowfit/Widgets/customRadioButton.dart';
import 'package:wowfit/main.dart';

import '../../../Models/singletons_data.dart';
import '../../../Utils/showtoaist.dart';
import '../../../controller/proController.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  ProScreenController con = Get.find<ProScreenController>();
  Package? monthly, annual, current;
  bool loader = false;

  @override
  Widget build(BuildContext context) {
    /*Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: Platform.);*/
    if (con.getOffers != null) {
      final offering = con.getOffers?.current;
      if (offering != null) {
        monthly = offering.monthly!;
        annual = offering.annual;
        current = con.activeEntitlement!.productIdentifier == "product_month" ? monthly : annual;
      }
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Subscription".tr,
          style: sFProDisplayRegular.copyWith(fontSize: 18, color: ColorResources.COLOR_NORMAL_BLACK),
        ),
        leading: InkWell(
          onTap: () {
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => BottomNavigationScreen(
            //               index: 1,
            //             )),
            //     (route) => false);
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
          inAsyncCall: loader,
          progressIndicator: Center(
              child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(10)),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Please Wait',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(height: 120, width: 120, child: Center(child: Image.asset('assets/wooFitImage.png'))),
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "key.subscription.info".tr.replaceAll("%1X",
                    "${current!.storeProduct.price.toStringAsFixed(0)} ${getCurrencySymbol(current!.storeProduct.priceString)} / ${con.activeEntitlement!.productIdentifier == "product_month" ? 'Month'.tr : 'Year'.tr}"),
                maxLines: 3,
                style: sFProDisplayRegular.copyWith(fontSize: 18, color: ColorResources.COLOR_NORMAL_BLACK),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "key.subscription.ending".tr.replaceAll("%1X", DateFormat("dd/MM/yy").format(DateTime.parse(con.activeEntitlement!.expirationDate!))),
                maxLines: 3,
                style: sFProDisplayRegular.copyWith(fontSize: 18, color: ColorResources.COLOR_NORMAL_BLACK),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              if (con.activeEntitlement!.productIdentifier == "product_month")
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    // height: 120,
                    color: Colors.transparent,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, right: 0, left: 0),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: ColorResources.INPUT_BORDER, width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  // const SizedBox(
                                  //   width: 10,
                                  // ),
                                  SizedBox(
                                      width: 40,
                                      height: 50,
                                      child: CustomRadioWidget(
                                        groupValue: 1,
                                        value: 1,
                                        onChanged: (int value) {},
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Center(
                                    child: RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: '${'7-days FREE Trial'.tr}${language == 'ru_RU' ? "\n" : ''}',
                                            style: sFProDisplayMedium.copyWith(
                                                fontSize: 16, overflow: TextOverflow.visible, color: ColorResources.COLOR_NORMAL_BLACK),
                                          ),
                                          TextSpan(
                                            text: '${' After trial ends'.tr}\n',
                                            style: sFProDisplayRegular.copyWith(
                                                fontSize: 14, overflow: TextOverflow.visible, color: ColorResources.INPUT_HINT_COLOR),
                                          ),

                                          TextSpan(
                                            text:
                                                '${'YEARLY'.tr}: ${annual != null ? annual!.storeProduct.price.toStringAsFixed(0) : "0"} ${annual != null ? getCurrencySymbol(annual!.storeProduct.priceString) : ''} / ${'Year'.tr}\n',
                                            style: sFProDisplayMedium.copyWith(
                                                fontSize: 16, overflow: TextOverflow.visible, color: ColorResources.COLOR_NORMAL_BLACK),
                                          ),
                                          //${format.currencySymbol}
                                          //${annual?.storeProduct.priceString.split(" ")[0] ?? ""}
                                          TextSpan(
                                            text:
                                                '${'Only'.tr} ${annual != null ? (annual!.storeProduct.price / 12).toStringAsFixed(0) : "0"} ${annual != null ? getCurrencySymbol(annual?.storeProduct.priceString) : ''} / ${'Mo'.tr}'
                                                    .tr,
                                            style: sFProDisplayRegular.copyWith(
                                                fontSize: 14, overflow: TextOverflow.visible, color: ColorResources.INPUT_HINT_COLOR),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(right: 0, child: Container(height: 25, width: 27, child: Image.asset("assets/star.png"))),
                      ],
                    ),
                  ),
                ),
              const Spacer(),
              if (con.activeEntitlement!.productIdentifier == "product_month")
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        loader = true;
                      });
                      try {
                        final customerInfo = await Purchases.purchasePackage(annual!);
                        log('entitlements : ${customerInfo.entitlements.all} AND :${customerInfo.entitlements.active}');
                        (customerInfo.entitlements.active.containsKey(entitlementID))
                            ? appData.entitlementIsActive.value = true
                            : appData.entitlementIsActive.value = false;
                        con.activeEntitlement = customerInfo.entitlements.active[entitlementID]!;
                        if (appData.entitlementIsActive.value) {
                          Get.to(() => BottomNavigationScreen(
                                index: 0,
                              ));
                        }
                        setState(() {
                          loader = false;
                        });
                      } on PlatformException catch (e) {
                        setState(() {
                          loader = false;
                        });
                        final errorCode = PurchasesErrorHelper.getErrorCode(e);
                        if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
                          print('User cancelled');
                        } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
                          print('User not allowed to purchase');
                        } else if (errorCode == PurchasesErrorCode.paymentPendingError) {
                          print('Payment is pending');
                        }
                      }
                    },
                    child: ButtonWidget(
                      containerColor: ColorResources.COLOR_BLUE,
                      color: Colors.white,
                      height: 50,
                      text: "key.upgrade.now".tr,
                    ),
                  ),
                ),
              const SizedBox(
                height: 30,
              ),
            ],
          )),
    );
  }

  String getCurrencySymbol(String? value) {
    if (value != null) {
      return value.replaceAll(RegExp(r'[-.,0-9 ]'), '');
    } else {
      return '';
    }
  }

  @override
  void initState() {
    con.fetchData().whenComplete(() => setState(() {}));
    super.initState();
  }
}
