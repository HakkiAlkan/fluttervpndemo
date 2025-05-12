import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class MainViewController extends GetxController {
//#region #init's
//#endregion

//#region #variable's
  int selectedPageIndex = 0;

  final TextEditingController searchBarController = TextEditingController();

  bool get isHomeViewOpen => selectedPageIndex == 0;

  final Rxn<String?> searchTxt = Rxn<String?>(null);

  final titles = {
    0: 'Countries',
    1: 'Connection',
    2: 'Settings',
  };

//#endregion

//#region #override's
//#endregion

//#region #methods's
  void searchBarOnChanged(String? val) => searchTxt.value = val;

  void bottomBarItemOnTap(int val, StatefulNavigationShell body) {
    FocusManager.instance.primaryFocus?.unfocus();
    selectedPageIndex = val;
    body.goBranch(val);
  }

  String getAppBarTitle() => titles[selectedPageIndex] ?? '';

//#endregion
}
