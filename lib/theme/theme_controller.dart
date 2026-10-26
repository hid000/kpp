import 'package:flutter/material.dart';

/// Поточний режим теми; перемикається на екрані профілю.
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(
  ThemeMode.light,
);
