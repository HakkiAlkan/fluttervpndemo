import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttervpndemo/core/controller/splash/splash_view_controller.dart';
import 'package:fluttervpndemo/ui/helper/base_view.dart';
import 'package:fluttervpndemo/ui/helper/ui_helpers.dart';

class SplashView extends BaseView<SplashViewController> {
  const SplashView({super.key});

  @override
  SplashViewController createController(BuildContext context) => SplashViewController();

  @override
  Widget buildView(BuildContext context, SplashViewController controller) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitRing(color: Colors.blue, size: 35.r),
          SizedBox(height: 0.05.sh),
          Text(
            'Splash\nKullanıcı Kontrol\nAuto-Login..',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: FontSizeValue.large),
          ),
        ],
      ),
    );
  }
}
