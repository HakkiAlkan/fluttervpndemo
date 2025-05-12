import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttervpndemo/core/controller/main/settings/settings_view_controller.dart';
import 'package:fluttervpndemo/core/service/theme/theme_helper.dart';

import 'package:fluttervpndemo/core/service/theme/theme_manager.dart';
import 'package:fluttervpndemo/ui/helper/base_view.dart';
import 'package:fluttervpndemo/ui/helper/ui_helpers.dart';
import 'package:get/get.dart';

class SettingsView extends BaseView<SettingsViewController> {
  const SettingsView({super.key});

  @override
  SettingsViewController createController(BuildContext context) => SettingsViewController();

  @override
  Widget buildView(BuildContext context, SettingsViewController controller) {
    return Column(
      children: [
        12.verticalSpace,
        Card(
          clipBehavior: Clip.hardEdge,
          color: context.customColorScheme.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          child: SwitchListTile(
            title: Text('Koyu Mod', style: TextStyle(fontSize: FontSizeValue.normal)),
            secondary: Icon(Icons.format_paint_outlined, size: 20.r, color: context.customColorScheme.black),
            value: Get.find<ThemeManager>().themeMode.value == ThemeMode.dark ? true : false,
            activeColor: context.colorScheme.primary,
            onChanged: (value) async => await Get.find<ThemeManager>().changeTheme(),
          ),
        ),
        12.verticalSpace,
      ],
    );
  }
}
