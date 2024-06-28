import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:get/get.dart';

import '../Utils/color_resources.dart';
get defaultProgressDialog => CustomProgressDialog(Get.context!,
    blur: 10,
    dismissable: false,
    loadingWidget: Container(
      padding: const EdgeInsets.all(25.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Platform.isAndroid
          ? const CircularProgressIndicator(
        color: ColorResources.COLOR_BLUE,
      )
          : const CupertinoActivityIndicator(
        color: ColorResources.COLOR_BLUE,
      ),
    ));