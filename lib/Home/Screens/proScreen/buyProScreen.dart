import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:wowfit/Home/BottomNavigation/bottomNavigationScreen.dart';
import 'package:wowfit/Utils/color_resources.dart';
import 'package:wowfit/Utils/styles.dart';
import 'package:wowfit/Widgets/buttonWidget.dart';
import 'package:wowfit/Widgets/customRadioButton.dart';
import 'package:wowfit/main.dart';

import '../../../Models/singletons_data.dart';
import '../../../Utils/showtoaist.dart';
import '../../../controller/proController.dart';
import 'constant.dart';

class BuyProScreen extends StatefulWidget {
  const BuyProScreen({Key? key}) : super(key: key);

  @override
  State<BuyProScreen> createState() => _BuyProScreenState();
}

class _BuyProScreenState extends State<BuyProScreen> {
  ProScreenController con = Get.find<ProScreenController>();
  Package? monthly, annual;
  int _groupValue = 0;
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
      }
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Buy a PRO".tr,
          style: sFProDisplayRegular.copyWith(fontSize: 18, color: ColorResources.COLOR_NORMAL_BLACK),
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
        inAsyncCall: loader,
        progressIndicator: Center(
            child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
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
        child: (con.getOffers != null)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(height: 120, width: 120, child: Center(child: Image.asset('assets/wooFitImage.png'))),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  Text(
                    "When you subscribe, you’ll get\n instant unlimited access.".tr,
                    maxLines: 3,
                    style: sFProDisplayRegular.copyWith(fontSize: 18, color: ColorResources.COLOR_NORMAL_BLACK),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // con.getOffers?.current != null
                  //     ?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: ColorResources.INPUT_BORDER, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _groupValue = 0;
                            });
                          },
                          child: Row(
                            children: [
                              // const SizedBox(
                              //   width: 10,
                              // ),
                              Flexible(
                                child: SizedBox(
                                  width: 40,
                                  height: 50,
                                  child: CustomRadioWidget(
                                    onChanged: (int? newValue) {
                                      setState(() => _groupValue = newValue!);
                                    },
                                    groupValue: _groupValue,
                                    value: 0,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  "${monthly != null ? monthly!.storeProduct.price.toStringAsFixed(0) : "0"} ${monthly != null ? getCurrencySymbol(monthly!.storeProduct.priceString) : ''} / ${'Month'.tr}"
                                      .tr,
                                  style: sFProDisplayMedium.copyWith(fontSize: 16, color: ColorResources.COLOR_NORMAL_BLACK),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  //: Container(),
                  /*con.getOffers?.current != null
                ? */
                  const SizedBox(
                    height: 5,
                  ),
                  //  : Container(),
                  // con.getOffers?.current != null
                  //     ?
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
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _groupValue = 1;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      // const SizedBox(
                                      //   width: 10,
                                      // ),
                                      SizedBox(
                                          width: 40,
                                          height: 50,
                                          child: CustomRadioWidget(
                                            onChanged: (int? newValue) {
                                              setState(() => _groupValue = newValue!);
                                            },
                                            groupValue: _groupValue,
                                            value: 1,
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
                          ),
                          Positioned(right: 0, child: Container(height: 25, width: 27, child: Image.asset("assets/star.png"))),
                        ],
                      ),
                    ),
                  ),
                  //  : Container(),
                  // con.getOffers != null ?
                  const Spacer(),
                  //: Container(),
                  Container(
                    decoration: const BoxDecoration(border: Border.fromBorderSide(BorderSide(color: ColorResources.INPUT_BORDER))),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              try {
                                setState(() {
                                  loader = true;
                                });
                                final customerInfo = await Purchases.restorePurchases();
                                if (customerInfo.entitlements.active.containsKey(entitlementID)) {
                                  showToast('Purchases Restored'.tr);
                                } else {
                                  showToast('Purchases Not Restored'.tr);
                                }
                                (customerInfo.entitlements.active.containsKey(entitlementID))
                                    ? appData.entitlementIsActive.value = true
                                    : appData.entitlementIsActive.value = false;
                              } on PlatformException catch (e) {
                                throw 'Restore Error ${e.message.toString()}';
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/wallet.png",width: 30,),
                                  const SizedBox(width: 24,),
                                  Flexible(
                                    child: Text(
                                      "key.purchase.restore".tr,
                                      style: sFProDisplayRegular.copyWith(fontSize: 16, color: ColorResources.INPUT_HINT_ICON,fontWeight: FontWeight.w500),
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (Platform.isIOS)...[
                          Container(width: 2,height:40,color: ColorResources.INPUT_BORDER),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                try {
                                  setState(() {
                                    loader = true;
                                  });
                                  await Purchases.presentCodeRedemptionSheet();
                                  setState(() {
                                    loader = false;
                                  });
                                  showToast('Your code will be processed soon'.tr);
                                } on PlatformException catch (e) {
                                  throw 'Code redeem error ${e.message.toString()}';
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("assets/ticket.png",width: 30,),
                                    const SizedBox(width: 24,),
                                    Flexible(
                                      child: Text(
                                        "key.redeem.code".tr,
                                        style: sFProDisplayRegular.copyWith(fontSize: 16, color: ColorResources.INPUT_HINT_ICON,fontWeight: FontWeight.w500),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          loader = true;
                        });
                        try {
                          final customerInfo = await Purchases.purchasePackage(_groupValue == 0 ? monthly! : annual!);
                          log('entitlements : ${customerInfo.entitlements.all} AND :${customerInfo.entitlements.active}');
                          print('entitlements : ${customerInfo.entitlements.all} AND :${customerInfo.entitlements.active}');
                          con.activeEntitlement = customerInfo.entitlements.active[entitlementID]!;
                          (customerInfo.entitlements.active.containsKey(entitlementID))
                              ? appData.entitlementIsActive.value = true
                              : appData.entitlementIsActive.value = false;
                          if (appData.entitlementIsActive.value) {
                            setState(() {
                              loader = false;
                            });
                            Get.to(BottomNavigationScreen(
                              index: 0,
                            ));
                          } else {
                            setState(() {
                              loader = false;
                            });
                          }
                        } on PlatformException catch (e) {
                          setState(() {
                            loader = false;
                          });
                          final errorCode = PurchasesErrorHelper.getErrorCode(e);
                          if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
                            showToast('User cancelled'.tr);
                            print('User cancelled');
                          } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
                            showToast('User not allowed to purchase'.tr);
                            print('User not allowed to purchase');
                          } else if (errorCode == PurchasesErrorCode.paymentPendingError) {
                            showToast('Payment is pending'.tr);
                            print('Payment is pending');
                          }
                        }
                      },
                      child: ButtonWidget(
                        containerColor: ColorResources.COLOR_BLUE,
                        color: Colors.white,
                        height: 50,
                        text: "Try WellnessPlan now".tr,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Data Not Found',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          loader = true;
                        });
                        con.initPlatformState().whenComplete(() => con.fetchData().whenComplete(() => setState(() {
                              loader = false;
                            })));
                      },
                      child: ButtonWidget(
                        containerColor: ColorResources.COLOR_BLUE,
                        color: Colors.white,
                        width: Get.width * 0.3,
                        height: 40,
                        text: "Retry".tr,
                      ),
                    ),
                  ],
                ),
              ),
      ),
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
    appData.entitlementIsActive.listen((p0) {});
    super.initState();
  }
}
