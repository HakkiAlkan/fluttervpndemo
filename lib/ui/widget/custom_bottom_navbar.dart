import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttervpndemo/core/service/theme/theme_helper.dart';
import 'package:fluttervpndemo/generated/assets.dart';
import 'package:fluttervpndemo/ui/helper/ui_helpers.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.selectedIndex,
  });

  final int currentIndex;
  final void Function(int) selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: context.customColorScheme.white,
        boxShadow: [
          BoxShadow(
            color: context.customColorScheme.shadowColor.withOpacity(0.12), // elevation 2~
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _BottomCard(onTap: () => selectedIndex(0), svgPath: Assets.svgMap, isSelected: currentIndex == 0, cardText: 'Countries')),
          Expanded(child: _BottomCard(onTap: () => selectedIndex(1), svgPath: Assets.svgRadar, isSelected: currentIndex == 1, cardText: 'Connection')),
          Expanded(child: _BottomCard(onTap: () => selectedIndex(2), svgPath: Assets.svgSetting, isSelected: currentIndex == 2, cardText: 'Settings')),
        ],
      ),
    );
  }
}

class _BottomCard extends StatelessWidget {
  const _BottomCard({
    required this.svgPath,
    required this.isSelected,
    required this.cardText,
    required this.onTap,
  });

  final String svgPath;
  final String cardText;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            svgPath,
            height: UIHelper.defaultSquareIconSize,
            width: UIHelper.defaultSquareIconSize,
            colorFilter: ColorFilter.mode(
              isSelected ? context.colorScheme.primary : context.customColorScheme.black,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            cardText,
            style: TextStyle(
              fontSize: FontSizeValue.normal,
              fontWeight: FontWeight.w500,
              color: isSelected ? context.colorScheme.primary : context.customColorScheme.txtGrey,
            ),
          ),
        ],
      ),
    );
  }
}
