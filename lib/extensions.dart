import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => ColorScheme.of(this);

  TextTheme get textTheme => TextTheme.of(this);

  Brightness get brightness => Theme.brightnessOf(this);

  bool get isDark => brightness == Brightness.dark;

  TargetPlatform get platform => theme.platform;

  MaterialLocalizations get materialLocalizations =>
      MaterialLocalizations.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  double get screenHeight => MediaQuery.heightOf(this);

  double get screenWidth => MediaQuery.widthOf(this);
}

extension DateTimeExtension on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  DateTime get dateOnly => DateTime(year, month, day);
}
