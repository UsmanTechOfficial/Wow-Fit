import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wowfit/Utils/color_resources.dart';

import '../Models/userAddedExcercise.dart';
import '../Utils/styles.dart';

// ignore: must_be_immutable
class TimeInputFields extends StatefulWidget {
  String _hint;
  String _error;
  int? index;
  String? one;
  String? two;
  bool _isPassword, _isEmail, _isPhone, _deco;
  UserList? workOut;
  Function(String) callback;
  FocusNode? focusNode;
  TextInputAction? textInputAction;
  TextEditingController? controller;
  List<TextInputFormatter>? inputFormator;
  TextInputType? keyboardType;

  TimeInputFields(String hint, String error,
      {Key? key,
      bool isPassword = false,
      bool isEmail = false,
      bool isPhone = false,
      bool deco = false,
      int? indexs,
      String? once,
      String? twos,
      Widget? suffixIcon,
      Widget? prefixIcon,
      UserList? workOuts,
      this.inputFormator,
      this.keyboardType,
      this.focusNode,
      required this.callback,
      this.textInputAction,
      this.controller})
      : _hint = hint,
        _error = error,
        _isPassword = isPassword,
        _isEmail = isEmail,
        _isPhone = isPhone,
        _deco = deco,
        one = once,
        two = twos,
        workOut = workOuts,
        index = indexs,
        super(key: key);

  @override
  State<TimeInputFields> createState() => _TimeInputFieldsState();
}

class _TimeInputFieldsState extends State<TimeInputFields> {
  inputDecorationTextField(context, hint) {
    return InputDecoration(
        fillColor: const Color(0xFF767680).withOpacity(0.08),
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        hintText: hint,
        errorStyle: const TextStyle(fontSize: 10),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.transparent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.transparent, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.transparent, width: 2),
        ),
        //When the TextFormField is ON focus
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.transparent, width: 2),
        ),
        hintStyle: sFProDisplayRegular.copyWith(
          color: const Color(0xFF737373),
          fontSize: 16,
        ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      child: TextFormField(
        showCursor: true,
        autofocus: false,
        focusNode: widget.focusNode,
        inputFormatters: widget.inputFormator,
        //[LengthLimitingTextInputFormatter(4)]
        cursorColor: ColorResources.COLOR_NORMAL_BLACK,
        style: sFProDisplayRegular.copyWith(
          fontSize: 18,
          color: ColorResources.COLOR_NORMAL_BLACK,
        ),
        controller: widget.controller,
        textInputAction: widget.textInputAction,
        keyboardType: widget.keyboardType ?? TextInputType.number,
        // initialValue: widget.controller != null ? widget.controller!.text : null,
        onChanged: (val) {
          widget.callback(val);
        },
        validator: widget._isEmail == true
            ? (value) {
                return validateEmail(value!);
              }
            : widget._isPhone == true
                ? (value) {
                    return validateMobile(value!);
                  }
                : (value) {
                    return null;
                  },
        decoration: inputDecorationTextField(context, widget._hint),
      ),
    );
  }

  String? validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    } else if (value.length > 15) {
      return 'length cant be greater than 15';
    }
    return null;
  }

  String? validateEmail(String value) {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return null;
    } else {
      return 'Please Enter valid Email'.tr;
    }
  }
}
