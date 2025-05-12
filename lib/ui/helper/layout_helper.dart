import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttervpndemo/base/enum/layout_types.dart';

class LayoutHelper {
  static final LayoutHelper instance = LayoutHelper._internal();

  LayoutHelper._internal();

  late LayoutType _layoutType;

  void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;

    final widthPx = size.width * pixelRatio;
    final heightPx = size.height * pixelRatio;

    final dpi = 160 * pixelRatio;
    final widthInches = widthPx / dpi;
    final heightInches = heightPx / dpi;
    final diagonalInches = sqrt(pow(widthInches, 2) + pow(heightInches, 2));

    if (diagonalInches < 4.8) {
      _layoutType = LayoutType.smallPhone;
    } else if (diagonalInches < 5.6) {
      _layoutType = LayoutType.normalPhone;
    } else if (diagonalInches < 7.0) {
      _layoutType = LayoutType.largePhone;
    } else {
      _layoutType = LayoutType.tablet;
    }
  }

  LayoutType get layoutType => _layoutType;

  bool get isTablet => _layoutType == LayoutType.tablet;

  bool get isLargePhone => _layoutType == LayoutType.largePhone;

  bool get isNormalPhone => _layoutType == LayoutType.normalPhone;

  bool get isSmallPhone => _layoutType == LayoutType.smallPhone;

  bool get isPhone => isSmallPhone || isNormalPhone || isLargePhone;
}

extension LayoutTypeExtension on LayoutType {
  bool get isSmallPhone => this == LayoutType.smallPhone;

  bool get isNormalPhone => this == LayoutType.normalPhone;

  bool get isLargePhone => this == LayoutType.largePhone;

  bool get isPhone => isSmallPhone || isNormalPhone || isLargePhone;

  bool get isTablet => this == LayoutType.tablet;
}
