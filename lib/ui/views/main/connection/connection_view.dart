import 'package:flutter/material.dart';
import 'package:fluttervpndemo/core/controller/main/connection/connection_view_controller.dart';
import 'package:fluttervpndemo/core/repository/login/login_repository.dart';
import 'package:fluttervpndemo/ui/helper/base_view.dart';
import 'package:fluttervpndemo/ui/helper/ui_helpers.dart';
import 'package:get/get.dart';

class ConnectionView extends BaseView<ConnectionViewController> {
  const ConnectionView({super.key});

  @override
  ConnectionViewController createController(BuildContext context) => ConnectionViewController();

  @override
  Widget buildView(BuildContext context, ConnectionViewController controller) {
    return Center(
      child: TextButton(
        onPressed: () async {
          var a = await Get.find<LoginRepository>().login({});
        },
        child: Text(
          'Request',
          style: TextStyle(
            fontSize: FontSizeValue.small,
            color: Colors.blue,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
