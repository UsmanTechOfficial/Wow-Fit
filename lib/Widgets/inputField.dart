import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wowfit/Utils/color_resources.dart';
import 'package:wowfit/Utils/styles.dart';

// ignore: must_be_immutable
class InputFields extends StatefulWidget {
  String _hint;
  String _error;
  bool _isPassword, _isEmail, _isPhone, _deco, _exTitle;
  final TextEditingController? _controller;
  Function(String)? callback;

  InputFields(String hint, String error,
      {Key? key,
      bool isPassword = false,
      bool isEmail = false,
      bool isPhone = false,
      bool deco = false,
      this.callback,
      bool exTitle = false,
      Widget? suffixIcon,
      Widget? prefixIcon,
      TextEditingController? controller})
      : _hint = hint,
        _error = error,
        _isPassword = isPassword,
        _isEmail = isEmail,
        _isPhone = isPhone,
        _deco = deco,
        _exTitle = exTitle,
        _controller = controller,
        super(key: key);

  @override
  State<InputFields> createState() => _InputFieldsState();
}

class _InputFieldsState extends State<InputFields> {
  inputDecorationTextField(context, String hint) {
    return InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        hintText: hint.tr,
        errorStyle: const TextStyle(
          fontSize: 12,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: ColorResources.INPUT_BORDER, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: ColorResources.INPUT_BORDER, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: ColorResources.INPUT_BORDER, width: 1),
        ),
        //When the TextFormField is ON focus
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: ColorResources.INPUT_BORDER, width: 1),
        ),
        hintStyle: sFProDisplayRegular.copyWith(
          color: ColorResources.INPUT_HINT_COLOR,
          fontSize: 16,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      child: TextFormField(
        onChanged: (text) {
          if (widget.callback != null) {
            widget.callback!(text);
          }
        },
        cursorColor: ColorResources.COLOR_NORMAL_BLACK,
        style: sFProDisplayRegular.copyWith(
          fontSize: 16,
          color: ColorResources.COLOR_NORMAL_BLACK,
        ),
        controller: widget._controller,
        keyboardType: TextInputType.emailAddress,
        validator: widget._isEmail == true
            ? (value) {
                return validateEmail(value!);
              }
            : widget._isPhone == true
                ? (value) {
                    return validateMobile(value!);
                  }
                : widget._exTitle == true
                    ? (value) {
                        if (value!.isEmpty) {
                          return 'Please enter exercise title'.tr;
                        }
                        return null;
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
      return 'Please Enter valid Email';
    }
  }
}
