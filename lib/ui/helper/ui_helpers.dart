import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttervpndemo/base/enum/layout_types.dart';
import 'package:fluttervpndemo/core/service/theme/theme_helper.dart';
import 'package:fluttervpndemo/generated/assets.dart';
import 'package:fluttervpndemo/ui/helper/layout_helper.dart';
import 'package:lottie/lottie.dart';

class UIHelper {
  static double defaultSquareIconSize = 24.h;

  static LottieComposition? notFoundComposition;

  static Future<LottieComposition> getCompositionByNotFound() async {
    if (notFoundComposition == null) {
      var assetData = await rootBundle.load(Assets.imagesNotFound);
      var data = await LottieComposition.fromByteData(assetData);
      await Future.delayed(const Duration(milliseconds: 100));
      notFoundComposition = data;
      return notFoundComposition!;
    }
    return notFoundComposition!;
  }

  static Color getConnectionQuality(int quality) {
    int red = 255 * (100 - quality) ~/ 100;
    int green = 255 * quality ~/ 100;
    int blue = 0;
    return Color.fromRGBO(red, green, blue, 1);
  }

  static Future<void> publicDialog({
    required BuildContext context,
    required String title,
    String? boldContent,
    required String content,
    required String rButtonText,
    String cancelText = 'İptal',
    Color? rButtonColor,
    required VoidCallback func,
    bool isReq = false,
    Color? boldContentColor,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: isReq ? false : true,
      builder: (BuildContext ctx) {
        return PopScope(
          canPop: isReq ? false : true,
          child: AlertDialog(
            backgroundColor: context.customColorScheme.white,
            surfaceTintColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(
              horizontal: HorizontalSpaceValue.medium,
              vertical: VerticalSpaceValue.defaultPaddingValue,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            content: Text.rich(
              TextSpan(
                text: boldContent == null ? null : '$boldContent ',
                style: TextStyle(
                  fontSize: FontSizeValue.medium,
                  fontWeight: FontWeight.bold,
                  color: boldContentColor,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: content,
                    style: TextStyle(
                      fontSize: FontSizeValue.medium,
                      fontWeight: FontWeight.normal,
                      color: context.customColorScheme.txtDarkGrey,
                    ),
                  ),
                ],
              ),
            ),
            title: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 0.05.sw),
                  child: Icon(
                    Icons.warning_rounded,
                    size: 25.r,
                    color: context.customColorScheme.txtDarkGrey,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: FontSizeValue.large,
                  ),
                )
              ],
            ),
            actions: [
              isReq
                  ? const SizedBox.shrink()
                  : TextButton(
                      style: TextButton.styleFrom(
                        overlayColor: context.colorScheme.primary.withOpacity(0.4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.r))),
                      ),
                      child: Text(
                        cancelText,
                        style: TextStyle(
                          fontSize: FontSizeValue.medium,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                    ),
              TextButton(
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.r)))),
                ),
                onPressed: () async {
                  Navigator.pop(ctx);
                  await Future.delayed(const Duration(milliseconds: 200));
                  func();
                },
                child: Text(
                  rButtonText,
                  style: TextStyle(
                    fontSize: FontSizeValue.medium,
                    color: rButtonColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class FontSizeValue {
  static double get xxxLarge => _getFontSize(smallPhone: 22, normalPhone: 24, largePhone: 25, tablet: 31);

  static double get xxLarge => _getFontSize(smallPhone: 18, normalPhone: 20, largePhone: 21, tablet: 27);

  static double get xLarge => _getFontSize(smallPhone: 16, normalPhone: 18, largePhone: 19, tablet: 25);

  static double get large => _getFontSize(smallPhone: 14, normalPhone: 16, largePhone: 17, tablet: 23);

  static double get medium => _getFontSize(smallPhone: 13, normalPhone: 15, largePhone: 16, tablet: 21);

  static double get normal => _getFontSize(smallPhone: 11.5, normalPhone: 13.5, largePhone: 14.5, tablet: 19);

  static double get tableNormal => _getFontSize(smallPhone: 11.5, normalPhone: 13, largePhone: 14, tablet: 18.5);

  static double get small => _getFontSize(smallPhone: 11, normalPhone: 12.5, largePhone: 13, tablet: 17.5);

  static double get xSmall => _getFontSize(smallPhone: 9, normalPhone: 10.5, largePhone: 11, tablet: 16);

  static double get xxSmall => _getFontSize(smallPhone: 7, normalPhone: 8.5, largePhone: 9, tablet: 14);

  static double _getFontSize({required double smallPhone, required double normalPhone, required double largePhone, required double tablet}) {
    final layout = LayoutHelper.instance.layoutType;

    switch (layout) {
      case LayoutType.smallPhone:
        return smallPhone.spMin;
      case LayoutType.normalPhone:
        return normalPhone.spMin;
      case LayoutType.largePhone:
        return largePhone.spMin;
      case LayoutType.tablet:
        return tablet.spMin;
    }
  }
}

class VerticalSpaceValue {
  static final double listBottomPadding = 0.1.sh;
  static final double defaultPaddingValue = 0.02.sh;
  static final double xxSmall = 0.002.sh;
  static final double xSmall = 0.005.sh;
  static final double small = 0.01.sh;
  static final double normal = 0.02.sh;
  static final double medium = 0.03.sh;
  static final double high = 0.04.sh;
}

class HorizontalSpaceValue {
  static final double defaultPaddingValue = 0.02.sw;
  static final double small = 0.01.sw;
  static final double normal = 0.02.sw;
  static final double medium = 0.04.sw;
  static final double high = 0.06.sw;
  static final double veryHigh = 0.08.sw;
}
