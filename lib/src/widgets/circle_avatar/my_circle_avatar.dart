import 'package:chatview3/src/widgets/circle_avatar/color.dart';
import 'package:chatview3/src/widgets/circle_avatar/constant.dart';
import 'package:flutter/material.dart';

class MyCircleAvatar extends StatelessWidget {
  final Color? backgroundColor;
  final Color textColor;
  final double radius, textSize;
  final String text;
  final bool random;

  const MyCircleAvatar({
    super.key,
    this.backgroundColor,
    required this.radius,
    required this.textSize,
    required this.text,
    required this.textColor,
    this.random = false,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor ??
          (random == true
              ? randomColor()
              : text == ''
                  ? ConstantColor.colorDefault
                  : fixedColor(getFirstLetters(text))),
      radius: radius,
      child: Center(
        child: Text(
          getFirstLetters(text),
          style: TextStyle(
            color: textColor,
            fontSize: textSize,
          ),
        ),
      ),
    );
  }
}
