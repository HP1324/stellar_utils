import 'package:flutter/material.dart';
import 'package:stellar_utils/extensions.dart';
import 'package:toastification/toastification.dart';

final errorType = ToastificationType.error;
final successType = ToastificationType.success;
final warningType = ToastificationType.warning;
const alignment = Alignment.bottomCenter;
const defaultDuration = Duration(milliseconds: 2500);

void showToast(
  BuildContext context,
  ToastificationType type,
  String description, {
  Duration? closeDuration,
  Alignment? alignment = alignment,
  Widget? icon,
  Widget? title,
}) {
  toastification.dismissAll();
  final scheme = context.colorScheme;
  toastification.show(
    context: context,
    description: Text(
      description,
      style: context.textTheme.titleMedium?.copyWith(fontWeight: .w600),
    ),
    type: type,
    autoCloseDuration: closeDuration ?? defaultDuration,
    alignment: alignment,
    backgroundColor: scheme.surface,
    foregroundColor: scheme.onSurfaceVariant,
    borderSide: BorderSide(color: scheme.outline),
    icon: icon,
    title: title,
  );
}

void showErrorToast(
  BuildContext context,
  String message, {
  Duration? duration,
  Alignment? alignment,
}) {
  if (context.mounted) {
    showToast(
      context,
      errorType,
      message,
      closeDuration: duration ?? defaultDuration,
      alignment: alignment ?? .center,
    );
  }
}

void showSuccessToast(
  BuildContext context,
  String message, {
  Duration? duration,
  Alignment? alignment,
  Widget? icon,
  Widget? title,
}) {
  if (context.mounted) {
    showToast(
      context,
      successType,
      message,
      closeDuration: duration ?? defaultDuration,
      alignment: alignment ?? .center,
      icon: icon,
      title: title,
    );
  }
}

void showWarningToast(
  BuildContext context,
  String message, {
  Duration? duration,
  Alignment? alignment,
}) {
  if (context.mounted) {
    toastification.dismissAll();
    showToast(
      context,
      warningType,
      message,
      closeDuration: duration ?? defaultDuration,
      alignment: alignment ?? .center,
    );
  }
}
