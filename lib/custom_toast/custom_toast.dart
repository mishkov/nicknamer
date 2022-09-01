import 'dart:math' as math;

import 'package:flutter/material.dart';

void showToast(BuildContext context, String message) {
  final toastColor = Color(0xBB000000);
  final borderRadius = BorderRadius.circular(10);
  final margin = EdgeInsets.symmetric(horizontal: 10, vertical: 70);
  final padding = EdgeInsets.all(8);
  final duration = Duration(milliseconds: 600);

  final messengerWidth = ScaffoldMessenger.of(context).context.size?.width;
  double? snackBarWidth;
  if (messengerWidth != null) {
    const maxSnackBarWidth = 300.0;
    snackBarWidth = math.min(messengerWidth, maxSnackBarWidth);
  }

  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    width: snackBarWidth,
    duration: duration,
    elevation: 0,
    backgroundColor: Colors.transparent,
    content: Container(
      decoration: BoxDecoration(
        color: toastColor,
        borderRadius: borderRadius,
      ),
      margin: margin,
      padding: padding,
      child: Text(message),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
