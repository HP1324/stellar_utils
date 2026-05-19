import 'package:flutter/material.dart';

extension ContextExtension on BuildContext{
  ColorScheme get colorScheme => ColorScheme.of(this);

  TextTheme get textTheme => TextTheme.of(this);

  Brightness get brightness => Theme.brightnessOf(this);

  bool get isDark => this == Brightness.dark;


  TargetPlatform get platform => Theme.of(this).platform;

  MaterialLocalizations get materialLocalizations => MaterialLocalizations.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  double get screenHeight => MediaQuery.sizeOf(this).height;

  double get screenWidth => MediaQuery.sizeOf(this).width;

}

