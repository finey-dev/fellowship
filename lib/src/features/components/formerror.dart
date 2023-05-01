import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fellowship/src/configs/configs.dart';

class FormError extends StatelessWidget {
  const FormError({
    Key? key,
    required this.errors,
    this.style,
  }) : super(key: key);

  final List<String?> errors;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          errors.length, (index) => formErrorText(error: errors[index]!)),
    );
  }

  Row formErrorText({required String error}) {
    return Row(
      children: [
        SvgPicture.asset(
          AppAssetsPath.close,
          color: kErrorColor,
          height: getProportionateScreenWidth(14),
          width: getProportionateScreenWidth(14),
        ),
        SizedBox(
          width: getProportionateScreenWidth(10),
        ),
        Text(
          error,
          style: style,
        ),
      ],
    );
  }
}
