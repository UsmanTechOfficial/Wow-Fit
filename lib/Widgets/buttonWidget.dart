import 'package:flutter/material.dart';
import 'package:wowfit/Utils/color_resources.dart';
import 'package:wowfit/Utils/styles.dart';

// ignore: must_be_immutable
class ButtonWidget extends StatelessWidget {
  String? _text;
  TextStyle? _style;
  double? _radius;
  Color? _color, _containerColor, _widthColor;
  void Function()? _onTap;
  Color? _borderColor;
  double? _width;
  double? _height;
  EdgeInsets? _padding;
  bool _isLoading = false;

  ButtonWidget(
      {String? text,
      TextStyle? style,
      double? radius,
      Function()? onTap,
      Color? color,
      containerColor,
      widthColor,
      Color? borderColor,
      double? width,
      double? height,
      EdgeInsets? padding,
      bool? isLoading})
      : _text = text,
        _style = style,
        _radius = radius,
        _color = color,
        _containerColor = containerColor,
        _widthColor = widthColor,
        _borderColor = borderColor,
        _width = width,
        _height = height,
        _onTap = onTap,
        _padding = padding,
        _isLoading = isLoading ?? false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        width: _width ?? MediaQuery.of(context).size.width,
        height: _height ?? 60,
        padding: _padding ?? EdgeInsets.all(0.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          border: Border.all(
              color: _widthColor ?? ColorResources.COLOR_BLUE, width: 1),
          color: _containerColor ?? Colors.white,
        ),
        child: Center(
          child: _isLoading
              ? Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircularProgressIndicator(color: _color ?? ColorResources.COLOR_BLUE,),
              )
              : Text(
                  _text ?? "",
                  textAlign: TextAlign.center,
                  style: sFProDisplayMedium.copyWith(
                      fontSize: 16, color: _color ?? ColorResources.COLOR_BLUE),
                ),
        ),
      ),
    );
  }
}
