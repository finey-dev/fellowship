import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fellowship/src/configs/configs.dart';

class CustomSuffixIcon extends StatelessWidget {
  const CustomSuffixIcon({
    Key? key,
    required this.svgIcon,
    this.onTap,
  }) : super(key: key);

  final String svgIcon;
  final Future<void> Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        getProportionateScreenWidth(20),
        getProportionateScreenWidth(20),
        getProportionateScreenWidth(20),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: SvgPicture.asset(
          svgIcon,
          height: getProportionateScreenWidth(18),
        ),
      ),
    );
  }
}
