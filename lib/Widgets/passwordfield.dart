import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wowfit/Utils/color_resources.dart';
import 'package:wowfit/Utils/styles.dart';

// ignore: must_be_immutable
class PassInputFields extends StatefulWidget {
  String _hint;
  String _error;
  bool _isPassword, _isEmail, _isPhone;
  Function? validateFunction;
  TextEditingController? _controller = new TextEditingController();

  PassInputFields(String hint, String error,
      {Key? key,
      bool isPassword = false,
      bool isEmail = false,
      bool isFilled = false,
      bool isPhone = false,
      bool deco = false,
      Widget? suffixIcon,
      Widget? prefixIcon,
      TextEditingController? controller})
      : _hint = hint,
        _error = error,
        _isPassword = isPassword,
        _isEmail = isEmail,
        _isPhone = isPhone,
        _controller = controller,
        super(key: key);

  @override
  _InputFieldsState createState() => _InputFieldsState();
}

class _InputFieldsState extends State<PassInputFields> {
  bool _obscureText = true;

  inputDecorationTextField(context, String hint) {
    return InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        hintText: hint.tr,
        suffixIcon: widget._isPassword == true
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: ColorResources.INPUT_HINT_ICON,
                  size: 20,
                ),
              )
            : const SizedBox(
                width: 0,
                height: 0,
              ),
        errorStyle: const TextStyle(fontSize: 10),
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
        cursorColor: ColorResources.COLOR_NORMAL_BLACK,
        style: sFProDisplayRegular.copyWith(
          fontSize: 16,
          color: ColorResources.COLOR_NORMAL_BLACK,
        ),
        controller: widget._controller,
        keyboardType: widget._isPhone == false
            ? TextInputType.text
            : TextInputType.number,
        obscureText: widget._isPassword == true ? _obscureText : false,
        validator: widget._isEmail == true
            ? (value) {
                if (value!.isEmpty) {
                  return "Please enter ${widget._error}";
                } else if (value.length > 25) {
                  return "Can't be greater than 25 character ";
                }
                return null;
              }
            : (value) {
                if (value!.isEmpty) {
                  return "Please enter ${widget._error}";
                } else if (value.length > 25) {
                  return "Can't be greater than 25 character ";
                }
                return null;
              },
        decoration: inputDecorationTextField(context, widget._hint),
      ),
    );
  }
}
