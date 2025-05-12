import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttervpndemo/base/init/cache/base_get_storage_helper.dart';
import 'package:fluttervpndemo/core/enum/shared_preferences_keys.dart';
import 'package:fluttervpndemo/core/service/theme/custom_theme_model.dart';
import 'package:get/get.dart';

class ThemeManager extends GetxService {
  Rx<ThemeMode> themeMode = Rx<ThemeMode>(ThemeMode.system);
  late ThemeData lightTheme;
  late ThemeData darkTheme;

  final ColorScheme lightColorScheme = const ColorScheme.highContrastLight(
    primary: Color(0xff1A5CFF),
    surfaceTint: Color(0xff2c638b),
    onPrimary: Color(0xffffffff),
    surface: Color(0xffF2F5F9),
    primaryContainer: Color(0xff3B74FF),
    onSurfaceVariant: Color(0xffFAFAFA),
    onPrimaryContainer: Color(0xffffffff),
    secondary: Color(0xff1f2e3b),
    onSecondary: Color(0xffffffff),
    secondaryContainer: Color(0xff3c4b59),
    onSecondaryContainer: Color(0xffffffff),
    tertiary: Color(0xff002f49),
    onTertiary: Color(0xffffffff),
    tertiaryContainer: Color(0xff074d73),
    onTertiaryContainer: Color(0xffffffff),
    error: Color(0xff600004),
    onError: Color(0xffffffff),
    errorContainer: Color(0xff98000a),
    onErrorContainer: Color(0xffffffff),
    onSurface: Color(0xff000000),
    outline: Color(0xff272d33),
    outlineVariant: Color(0xff444a50),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xff2d3135),
    inversePrimary: Color(0xff99ccfa),
    primaryFixed: Color(0xff0e4d75),
    onPrimaryFixed: Color(0xffffffff),
    primaryFixedDim: Color(0xff003655),
    onPrimaryFixedVariant: Color(0xffffffff),
    secondaryFixed: Color(0xff3c4b59),
    onSecondaryFixed: Color(0xffffffff),
    secondaryFixedDim: Color(0xff253442),
    onSecondaryFixedVariant: Color(0xffffffff),
    tertiaryFixed: Color(0xff074d73),
    onTertiaryFixed: Color(0xffffffff),
    tertiaryFixedDim: Color(0xff003653),
    onTertiaryFixedVariant: Color(0xffffffff),
    surfaceDim: Color(0xffb6b9be),
    surfaceBright: Color(0xffffffff),
    surfaceContainerLowest: Color(0xffffffff),
    surfaceContainerLow: Color(0xffeef1f6),
    surfaceContainer: Color(0xffe0e2e8),
    surfaceContainerHigh: Color(0xffd2d4da),
    surfaceContainerHighest: Color(0xffc4c7cc),
  );

  final ColorScheme darkColorScheme = const ColorScheme.highContrastDark(
    primary: Color(0xff1A5CFF),
    onPrimary: Color(0xff000000),
    surfaceTint: Color(0xff99ccfa),
    surface: Color(0xff121212),
    onSurfaceVariant: Color(0xff000000),
    primaryContainer: Color(0xff3B74FF),
    onPrimaryContainer: Color(0xff000c19),
    secondary: Color(0xffe6f1ff),
    onSecondary: Color(0xff000000),
    secondaryContainer: Color(0xffb5c4d6),
    onSecondaryContainer: Color(0xff000c19),
    tertiary: Color(0xffe5f1ff),
    onTertiary: Color(0xff000000),
    tertiaryContainer: Color(0xff93c8f4),
    onTertiaryContainer: Color(0xff000c18),
    error: Color(0xffffece9),
    onError: Color(0xff000000),
    errorContainer: Color(0xffffaea4),
    onErrorContainer: Color(0xff220001),
    onSurface: Color(0xffffffff),
    outline: Color(0xffebf0f8),
    outlineVariant: Color(0xffbec3cb),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xffe0e2e8),
    inversePrimary: Color(0xff0b4c73),
    primaryFixed: Color(0xffcde5ff),
    onPrimaryFixed: Color(0xff000000),
    primaryFixedDim: Color(0xff99ccfa),
    onPrimaryFixedVariant: Color(0xff001322),
    secondaryFixed: Color(0xffd4e4f6),
    onSecondaryFixed: Color(0xff000000),
    secondaryFixedDim: Color(0xffb8c8da),
    onSecondaryFixedVariant: Color(0xff03121f),
    tertiaryFixed: Color(0xffcbe6ff),
    onTertiaryFixed: Color(0xff000000),
    tertiaryFixedDim: Color(0xff97ccf9),
    onTertiaryFixedVariant: Color(0xff001321),
    surfaceDim: Color(0xff101418),
    surfaceBright: Color(0xff4d5055),
    surfaceContainerLowest: Color(0xff000000),
    surfaceContainerLow: Color(0xff1c2024),
    surfaceContainer: Color(0xff2d3135),
    surfaceContainerHigh: Color(0xff383c40),
    surfaceContainerHighest: Color(0xff43474c),
  );

  final lightCustomTheme = const CustomTheme(
    txtWhite: Color(0xffFFFFFF),
    txtDarkGrey: Color(0xff333333),
    txtGrey: Color(0xff666666),
    white: Color(0xFFFFFFFF),
    alwaysWhite: Color(0xFFFFFFFF),
    black: Color(0xff000000),
    alwaysBlack: Color(0xff000000),
    shadowColor: Color(0xff2d3135),
    primaryGreen: Color(0xFF56CB8F),
    primaryRed: Color(0xffFD5D5D),
  );

  final darkCustomTheme = const CustomTheme(
    txtWhite: Color(0xffFFFFFF),
    txtDarkGrey: Color(0xFFFFFFFF),
    txtGrey: Color(0xffe0e0e0),
    shadowColor: Color(0xff000000),
    white: Color(0xff000000),
    alwaysWhite: Color(0xFFFFFFFF),
    black: Color(0xFFFFFFFF),
    alwaysBlack: Color(0xff000000),
    primaryGreen: Color(0xFF56CB8F),
    primaryRed: Color(0xffFD5D5D),
  );

  Future<void> changeTheme() async {
    themeMode.value = themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _updateStatusBarBrightness(themeMode.value == ThemeMode.dark ? Brightness.light : Brightness.dark);
    await Get.find<StorageService>().setBoolValue(PreferencesKeys.isDarkMode.name, themeMode.value == ThemeMode.light ? false : true);
  }

  void initThemeData() {
    lightTheme = getTheme(lightColorScheme, [lightCustomTheme]);
    darkTheme = getTheme(darkColorScheme, [darkCustomTheme]);
  }

  ThemeData getTheme(ColorScheme colorScheme, List<ThemeExtension>? extensions) {
    final TextTheme textTheme = createGilroyTextTheme();

    final TextTheme coloredTextTheme = textTheme.apply(
      displayColor: colorScheme.onSurface,
      bodyColor: colorScheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      extensions: extensions,
      fontFamily: 'Gilroy',
      textTheme: coloredTextTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,
    );
  }

  TextTheme createGilroyTextTheme() {
    const String fontFamily = 'Gilroy';

    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  void _updateStatusBarBrightness(Brightness brightness) {
    final iosStyleBrightness = brightness == Brightness.dark ? Brightness.light : Brightness.dark;
    if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          statusBarBrightness: iosStyleBrightness,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          statusBarIconBrightness: brightness,
          systemNavigationBarIconBrightness: brightness,
        ),
      );
    }
  }
}
