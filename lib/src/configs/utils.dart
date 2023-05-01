import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fellowship/utilities/utilities.dart';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(AwesomeSnackbarContent(
        title: 'Error',
        message: content,
        snackbarType: SnackbarType.error) as SnackBar);
}
