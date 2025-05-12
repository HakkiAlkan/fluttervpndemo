import 'package:flutter/material.dart';

class CustomTheme extends ThemeExtension<CustomTheme> {
  final Color txtWhite;
  final Color txtGrey;
  final Color txtDarkGrey;
  final Color white;
  final Color black;
  final Color alwaysWhite;
  final Color alwaysBlack;
  final Color shadowColor;
  final Color primaryGreen;
  final Color primaryRed;

  const CustomTheme({
    required this.txtWhite,
    required this.txtGrey,
    required this.txtDarkGrey,
    required this.white,
    required this.black,
    required this.alwaysWhite,
    required this.alwaysBlack,
    required this.shadowColor,
    required this.primaryGreen,
    required this.primaryRed,
  });

  @override
  CustomTheme copyWith({
    Color? txtWhite,
    Color? txtGrey,
    Color? txtDarkGrey,
    Color? white,
    Color? black,
    Color? alwaysWhite,
    Color? alwaysBlack,
    Color? shadowColor,
    Color? primaryGreen,
    Color? primaryRed,
  }) {
    return CustomTheme(
      txtWhite: txtWhite ?? this.txtWhite,
      txtGrey: txtGrey ?? this.txtGrey,
      txtDarkGrey: txtDarkGrey ?? this.txtDarkGrey,
      white: white ?? this.white,
      black: black ?? this.black,
      alwaysWhite: alwaysWhite ?? this.alwaysWhite,
      alwaysBlack: alwaysBlack ?? this.alwaysBlack,
      shadowColor: shadowColor ?? this.shadowColor,
      primaryGreen: primaryGreen ?? this.primaryGreen,
      primaryRed: primaryRed ?? this.primaryRed,
    );
  }

  @override
  CustomTheme lerp(CustomTheme? other, double t) {
    if (other == null) return this;
    return CustomTheme(
      txtWhite: Color.lerp(txtWhite, other.txtWhite, t)!,
      txtGrey: Color.lerp(txtGrey, other.txtGrey, t)!,
      txtDarkGrey: Color.lerp(txtDarkGrey, other.txtDarkGrey, t)!,
      white: Color.lerp(white, other.white, t)!,
      black: Color.lerp(black, other.black, t)!,
      alwaysWhite: Color.lerp(alwaysWhite, other.alwaysWhite, t)!,
      alwaysBlack: Color.lerp(alwaysBlack, other.alwaysBlack, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      primaryGreen: Color.lerp(primaryGreen, other.primaryGreen, t)!,
      primaryRed: Color.lerp(primaryRed, other.primaryRed, t)!,
    );
  }
}
