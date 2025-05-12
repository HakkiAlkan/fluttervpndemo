import 'package:flutter/material.dart';
import 'package:fluttervpndemo/core/service/theme/custom_theme_model.dart';

extension ThemeExt on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme; // Material 3

  CustomTheme get customColorScheme => Theme.of(this).extension<CustomTheme>()!;
}
