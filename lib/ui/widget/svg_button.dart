import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttervpndemo/core/service/theme/theme_helper.dart';
import 'package:fluttervpndemo/ui/helper/layout_helper.dart';
import 'package:fluttervpndemo/ui/helper/ui_helpers.dart';

class SvgButton extends StatelessWidget {
  const SvgButton({super.key, required this.svgPath, required this.onTap, this.svgColor, this.backgroundColor, this.elevation = true});

  final String svgPath;
  final VoidCallback onTap;
  final Color? svgColor;
  final Color? backgroundColor;
  final bool elevation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: LayoutHelper.instance.isTablet ? 30.w : 40.w,
        height: LayoutHelper.instance.isTablet ? 30.w : 40.w,
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: backgroundColor ?? context.customColorScheme.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: !elevation
              ? null
              : [
                  BoxShadow(
                    color: context.customColorScheme.shadowColor.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: SvgPicture.asset(
          svgPath,
          height: UIHelper.defaultSquareIconSize,
          width: UIHelper.defaultSquareIconSize,
          colorFilter: svgColor == null
              ? null
              : ColorFilter.mode(
                  svgColor!,
                  BlendMode.srcIn,
                ),
        ),
      ),
    );
  }
}
