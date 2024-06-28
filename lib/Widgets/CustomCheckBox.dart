import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  /*final ValueChanged onChanged;*/
  var index;
  final double width;
  final double height;
  bool isSelected = false;
  Function(bool)? callback;
  CustomCheckBox({
    Key? key,
    /*required this.onChanged,*/
    required this.isSelected,
    this.index,
    this.width = 40,
    this.height = 40,
    this.callback,
  }) : super(key: key);

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          if (widget.isSelected == false) {
            setState(() {
              widget.isSelected = true;
              widget.callback!(true);
            });
            // userList[widget.index].isItemSelect = true;
          } else {
            setState(() {
              widget.isSelected = false;
              widget.callback!(false);
            });
            // userList[widget.index].isItemSelect = false;
          }
        },
        child: Container(
          height: widget.height,
          width: widget.width,
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
                  color: widget.isSelected == true
                      ? const Color(0xFF1B5DEC)
                      : const Color(0xFFB4B6B8),
                  width: widget.isSelected == true ? 8 : 1,
                ),
                shape: BoxShape.circle,
                color: Colors
                    .white /*value == groupValue ? Color(0xFF1B5DEC) : Color(0xFFB4B6B8)*/,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
