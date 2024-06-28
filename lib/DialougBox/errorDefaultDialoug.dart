import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/color_resources.dart';

class DefaultDialog extends StatefulWidget {
  BuildContext? context;
  String? title;
  String? message;
  DefaultDialog({Key? key, this.title,this.message, this.context})
      : super(key: key);

  @override
  State<DefaultDialog> createState() => _DefaultDialogState();
}

class _DefaultDialogState extends State<DefaultDialog> {
  @override
  Widget build(BuildContext context) {
    Widget continueButton = TextButton(
      child: Text("Ok".tr,style: const TextStyle(color: ColorResources.COLOR_BLUE),),
      onPressed: () {
        Navigator.of(widget.context!, rootNavigator: true).pop();
      },
    );
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(widget.title??'Something wrong'.tr),
        content: Text(
          widget.message.toString(),
        ),
        actions: <Widget>[
          CupertinoDialogAction(child: continueButton),
        ],
      );
    }
    return AlertDialog(
      title: Text(widget.title??'Something wrong'.tr),
      content: Text(
        widget.message.toString(),
      ),
      actions: <Widget>[
        continueButton,
      ],
    );
  }
}
