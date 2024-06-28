import 'package:flutter/material.dart';

class CustomRadioWidget<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final double width;
  final double height;

  CustomRadioWidget(
      {required this.value,
      required this.groupValue,
      required this.onChanged,
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
          decoration: const ShapeDecoration(
            shape: CircleBorder(),
            gradient: LinearGradient(
              colors: [
                Color(0xFF49EF3E),
                Color(0xFF06D89A),
              ],
            ),
          ),
          child: Center(
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: value == groupValue
                      ? const Color(0xFF1B5DEC)
                      : const Color(0xFFB4B6B8),
                  width: value == groupValue ? 8 : 1,
                ),
                shape: BoxShape.circle,
                color: Colors
                    .white /*value == groupValue ? Color(0xFF1B5DEC) : Color(0xFFB4B6B8)*/,
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
