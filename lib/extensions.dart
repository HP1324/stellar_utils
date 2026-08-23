import 'package:flutter/material.dart';

extension ContextExtension on BuildContext{
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => ColorScheme.of(this);

  TextTheme get textTheme => TextTheme.of(this);

  Brightness get brightness => Theme.brightnessOf(this);

  bool get isDark => brightness == Brightness.dark;

  TargetPlatform get platform => theme.platform;

  MaterialLocalizations get materialLocalizations => MaterialLocalizations.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  double get screenHeight => MediaQuery.heightOf(this);

  double get screenWidth => MediaQuery.widthOf(this);

}

