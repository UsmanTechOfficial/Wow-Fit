import 'package:flutter/material.dart';
import 'package:wowfit/Utils/color_resources.dart';
import 'package:wowfit/Widgets/custome_bounder_container.dart';

class CustomContainer extends StatefulWidget {
  Widget child;
  int? value = MID;
  double? height;
  static const int TOP = 1;
  static const int MID = 2;
  static const int BOTTOM = 3;
  CustomContainer({Key? key, required this.child, this.value, this.height})
      : super(key: key);

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

getShape(int val) {
  if (val == CustomContainer.TOP) {
    return const ShapeDecoration(
      shape: CustomRoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22), topRight: Radius.circular(22)),
        leftSide: BorderSide(color: ColorResources.COLOR_BLUE),
        rightSide: BorderSide(color: ColorResources.COLOR_BLUE),
        topLeftCornerSide: BorderSide(color: ColorResources.COLOR_BLUE),
        topRightCornerSide: BorderSide(color: ColorResources.COLOR_BLUE),
        topSide: BorderSide(color: ColorResources.COLOR_BLUE),
      ),
    );
  } else if (val == CustomContainer.BOTTOM) {
    return const ShapeDecoration(
      shape: CustomRoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(22), bottomLeft: Radius.circular(22)),
        leftSide: BorderSide(color: ColorResources.COLOR_BLUE),
        rightSide: BorderSide(color: ColorResources.COLOR_BLUE),
        bottomLeftCornerSide: BorderSide(color: ColorResources.COLOR_BLUE),
        bottomRightCornerSide: BorderSide(color: ColorResources.COLOR_BLUE),
        bottomSide: BorderSide(color: ColorResources.COLOR_BLUE),
      ),
    );
  } else if (val == CustomContainer.MID) {
    return const ShapeDecoration(
      shape: CustomRoundedRectangleBorder(
        leftSide: BorderSide(color: ColorResources.COLOR_BLUE),
        rightSide: BorderSide(color: ColorResources.COLOR_BLUE),
      ),
    );
  } else {
    return null;
  }
}

class _CustomContainerState extends State<CustomContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: 45,
      decoration: getShape(widget.value!),
      child: widget.child,
    );
  }
}
