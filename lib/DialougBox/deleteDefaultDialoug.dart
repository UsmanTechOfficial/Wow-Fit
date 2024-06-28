import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteDefaultDialog extends StatefulWidget {
  BuildContext? context;
  String? errorText;
  Function() callback;
  DeleteDefaultDialog(
      {Key? key, this.errorText, this.context, required this.callback})
      : super(key: key);

  @override
  State<DeleteDefaultDialog> createState() => _DeleteDefaultDialogState();
}

class _DeleteDefaultDialogState extends State<DeleteDefaultDialog> {
  @override
  Widget build(BuildContext context) {
    Widget yesButton = TextButton(
      child: Text("Yes".tr),
      onPressed: () {
        widget.callback();
        Navigator.of(widget.context!, rootNavigator: true).pop();
      },
    );
    Widget noButton = TextButton(
      child: Text("No".tr),
      onPressed: () {
        Navigator.of(widget.context!, rootNavigator: true).pop();
      },
    );
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title:
            Align(alignment: Alignment.center, child: Text('Are you sure?'.tr)),
        content: Text(
          widget.errorText.toString().tr,
        ),
        actions: <Widget>[
          CupertinoDialogAction(child: noButton),
          CupertinoDialogAction(child: yesButton),
        ],
      );
    }
    return AlertDialog(
      title:
          Align(alignment: Alignment.center, child: Text('Are you sure?'.tr)),
      content: Text(
        widget.errorText.toString().tr,
      ),
      actions: <Widget>[
        yesButton,
        noButton,
      ],
    );
  }
}
