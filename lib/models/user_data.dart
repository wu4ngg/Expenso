import 'package:flutter/material.dart';
import 'package:hdmgr/models/spending_limit.dart';

class UserData {
  ColorScheme colorScheme;
  List<SpendingLimit>? spendingLimitList = [SpendingLimit(value: 0)];
  UserData({this.colorScheme = 
    const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFC6D6FF),
      onPrimary: Color(0xFF000000),
      secondary: Color(0xFF7299FE),
      onSecondary: Color(0xFF000000),
      error: Color(0xFFFE8B72),
      onError: Color(0xFFFFFFFF),
      background: Color(0xFFFFFFFF),
      onBackground: Color(0xFF000000),
      surface: Color(0xFFF3F3F3),
      onSurface: Color(0xFF000000),
      surfaceVariant: Color(0xFF515151),
      onSurfaceVariant: Color(0xFFFFFFFF),
      surfaceTint: Color(0xFFFFFFFF)),
    this.spendingLimitList
  });
}