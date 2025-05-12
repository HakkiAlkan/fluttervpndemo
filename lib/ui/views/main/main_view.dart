import 'package:flutter/material.dart';
import 'package:fluttervpndemo/core/controller/main/main_view_controller.dart';
import 'package:fluttervpndemo/ui/helper/base_view.dart';
import 'package:fluttervpndemo/ui/widget/custom_appbar.dart';
import 'package:fluttervpndemo/ui/widget/custom_bottom_navbar.dart';
import 'package:go_router/go_router.dart';

class MainView extends BaseView<MainViewController> {
  const MainView(this.body, {super.key});

  final StatefulNavigationShell body;

  @override
  MainViewController createController(BuildContext context) => MainViewController();

  @override
  Widget buildView(BuildContext context, MainViewController controller) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            CustomAppBar(
              title: controller.getAppBarTitle(),
              searchBarController: controller.searchBarController,
              showSearchBar: controller.isHomeViewOpen,
              onChanged: controller.searchBarOnChanged,
              categoryOnTap: () {},
              crownOnTap: () {},
            ),
            Expanded(child: body),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: controller.selectedPageIndex,
        selectedIndex: (int index) => controller.bottomBarItemOnTap(index, body),
      ),
    );
  }
}
