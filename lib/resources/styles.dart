
import 'dart:ui';

import 'package:flutter/material.dart';

class Styles{

  static Color selectionBGColor = const Color(0xFF5300b3);
  static Color appBarColor = const Color(0xFF180033);

static TextStyle? getJuzStyle(BuildContext context)
{
  return Theme.of(context)
      .textTheme
      .bodyLarge
      ?.copyWith(height: 2,letterSpacing: 0.1,fontWeight: FontWeight.w500);
}

static TextStyle? getAyahTextStyle(BuildContext context)
{
  return Theme.of(context)
      .textTheme
      .bodyLarge
      ?.copyWith(fontSize: 18,height: 2,letterSpacing: 0.1,fontWeight: FontWeight.w700);
}

static TextStyle? getSelectionStyle(BuildContext context)
{
  return Theme.of(context)
      .textTheme
      .titleSmall
      ?.copyWith(height: 2,letterSpacing: 0.1,fontWeight: FontWeight.w500);
}
}