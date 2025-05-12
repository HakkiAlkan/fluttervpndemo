import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttervpndemo/core/service/theme/theme_helper.dart';
import 'package:fluttervpndemo/ui/helper/ui_helpers.dart';
import 'package:toastification/toastification.dart';

class ToastHelper {
  /// Metodunda eğer ki go_router yönlendirmesi varsa bunu kullanma!!
  /// Need FIX!!!
  static Future<T?> asyncLoadingWidget<T>(
    BuildContext context,
    Future<T?> Function() asyncFunction, {
    String message = "Yükleniyor...",
  }) {
    final completer = Completer<T?>();
    void showLoader() {
      if (!context.mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          () async {
            try {
              final result = await asyncFunction();
              await Future.delayed(const Duration(milliseconds: 200));
              if (dialogContext.mounted && Navigator.canPop(dialogContext)) Navigator.pop(dialogContext);
              if (!completer.isCompleted) completer.complete(result);
            } catch (error) {
              if (dialogContext.mounted && Navigator.canPop(dialogContext)) Navigator.pop(dialogContext);
              if (!completer.isCompleted) completer.complete(null); // veya fallback değeri
            }
          }();
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 0.8.sw,
                minHeight: 0.08.sh,
                maxHeight: 0.1.sh,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: HorizontalSpaceValue.veryHigh),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SpinKitRing(color: context.colorScheme.primary, size: 30.r),
                      SizedBox(width: HorizontalSpaceValue.veryHigh),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: VerticalSpaceValue.normal),
                          child: Text(
                            message,
                            style: TextStyle(fontSize: FontSizeValue.large),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    if (SchedulerBinding.instance.hasScheduledFrame || WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
      Future.microtask(showLoader);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => showLoader());
    }

    return completer.future;
  }

  static void success({String? title, String? desc, Duration duration = const Duration(seconds: 2)}) => _getToast(
        type: ToastificationType.success,
        title: title,
        desc: desc,
        duration: duration,
      );

  static void error({String? title, String? desc, Duration duration = const Duration(seconds: 4)}) => _getToast(
        type: ToastificationType.error,
        title: title,
        desc: desc,
        duration: duration,
      );

  static void warning({String? title, String? desc, Duration duration = const Duration(seconds: 4)}) => _getToast(
        type: ToastificationType.warning,
        title: title,
        desc: desc,
        duration: duration,
      );

  static void info({String? title, String? desc, Duration duration = const Duration(seconds: 2)}) => _getToast(
        type: ToastificationType.info,
        title: title,
        desc: desc,
        duration: duration,
      );

  static _getToast({required ToastificationType type, String? title, String? desc, required Duration duration}) {
    toastification.dismissAll();
    toastification.show(
      title: title == null
          ? null
          : Text(
              title,
              maxLines: 2,
              style: TextStyle(
                // color: ThemeManager.instance.currentTheme.colorScheme.alwysBlack,
                fontSize: FontSizeValue.normal,
                fontWeight: FontWeight.bold,
              ),
            ),
      description: desc == null
          ? null
          : Text(
              desc,
              maxLines: 10,
              style: TextStyle(fontSize: FontSizeValue.normal),
            ),
      autoCloseDuration: duration,
      style: ToastificationStyle.flat,
      closeOnClick: true,
      dragToClose: true,
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.always,
      type: type,
      animationDuration: const Duration(milliseconds: 150),
      alignment: Alignment.topRight,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 5,
          blurRadius: 10,
          offset: const Offset(0, 0), // changes x,y position of shadow
        ),
      ],
    );
  }
}
