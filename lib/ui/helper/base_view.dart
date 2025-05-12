import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseView<T extends GetxController> extends StatefulWidget {
  const BaseView({super.key});

  T createController(BuildContext context);

  Widget buildView(BuildContext context, T controller);

  @override
  State<BaseView<T>> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends GetxController> extends State<BaseView<T>> {
  late T controller;

  @override
  void initState() {
    super.initState();
    controller = widget.createController(context);
    if (!Get.isRegistered<T>()) {
      Get.put<T>(controller);
    } else {
      controller = Get.find<T>();
    }
  }

  @override
  void dispose() {
    Get.delete<T>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.buildView(context, controller);
  }
}
