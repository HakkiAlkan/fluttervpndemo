import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:fluttervpndemo/core/controller/main/main_view_controller.dart';
import 'package:fluttervpndemo/core/model/country/country_model.dart';
import 'package:fluttervpndemo/generated/assets.dart';
import 'package:get/get.dart';

class CountriesViewController extends GetxController {
//#region #init's
//#endregion

//#region #variable's
  late final MainViewController mainViewController;
  late RxList<CountryModel> freeServerList;
  late RxList<CountryModel> premiumServerList;
  final RxBool isBusy = false.obs;
  late Worker searchWorker;

//#endregion

//#region #override's
  @override
  void onInit() {
    super.onInit();
    mainViewController = Get.find<MainViewController>();
    freeServerList = <CountryModel>[].obs;
    premiumServerList = <CountryModel>[].obs;
    searchWorker = ever<String?>(mainViewController.searchTxt, searchFieldListener);
  }

  @override
  void onReady() {
    super.onReady();
    getFreeServerList();
  }

  @override
  void onClose() {
    super.onClose();
    searchWorker.dispose();
  }

//#endregion

//#region #methods's

  void searchFieldListener(String? val) {
    if (val != null) {
      for (var element in freeServerList) {
        if (element.name!.toLowerCase().contains(val.toLowerCase())) {
          element.isVisible = true;
        } else {
          element.isVisible = false;
        }
      }
    } else {
      for (var element in freeServerList) {
        element.isVisible = true;
      }
    }
    freeServerList.refresh();
  }

  Future<void> getFreeServerList() async {
    isBusy.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isBusy.value = false;
    final jsonString = await rootBundle.loadString(Assets.dataData);
    final jsonList = json.decode(jsonString) as List;
    final newList = List<CountryModel>.from(jsonList.map((x) => CountryModel.fromJson(x)));
    freeServerList.value = newList;
  }
//#endregion
}
