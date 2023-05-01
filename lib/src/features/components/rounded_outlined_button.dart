import 'package:flutter/material.dart';

class RoundedOutlinedButton extends StatelessWidget {
  final Color? backgroundColor;
  final Text? buttonText;
  final Function? onPressed;
  final BorderStyle style;
  final double width;

  const RoundedOutlinedButton(
      {Key? key,
      this.backgroundColor,
      this.buttonText,
      this.onPressed,
      required this.style,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                side: BorderSide(
                  color: backgroundColor ?? Colors.transparent,
                  width: width,
                  style: style,
                ),
              ),
              onPressed: onPressed as void Function()?,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(child: buttonText),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
