import 'package:flutter/material.dart';
import 'package:wowfit/Utils/color_resources.dart';

class CustomColorPickerWidget<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final double width;
  final Color color;
  final double height;

  CustomColorPickerWidget(
      {required this.value,
      required this.groupValue,
      required this.onChanged,
      required this.color,
      this.width = 40,
      this.height = 40});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          onChanged(value);
        },
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            border: Border.all(
              color: value == groupValue
                  ? ColorResources.COLOR_NORMAL_BLACK
                  : color,
              width: value == groupValue ? 2.5 : 0,
            ),
            shape: BoxShape.circle,
            color:
                color /*value == groupValue ? Color(0xFF1B5DEC) : Color(0xFFB4B6B8)*/,
          ),
          child: Center(
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: value == groupValue ? Colors.white : color,
                  width: value == groupValue ? 1.5 : 0,
                ),
                shape: BoxShape.circle,
                color:
                    color /*value == groupValue ? Color(0xFF1B5DEC) : Color(0xFFB4B6B8)*/,
              ),
              /* child: Container(
                height: 1,
                width: 1,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40)),
              ),*/
            ),
          ),
        ),
      ),
    );
  }
}
