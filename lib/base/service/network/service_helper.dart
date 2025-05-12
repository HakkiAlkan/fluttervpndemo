import 'package:fluttervpndemo/base/helper/toast/toast_helper.dart';
import 'package:fluttervpndemo/base/model/response_model.dart';

abstract class NetworkServiceHelper {
  void showMessage(BaseError? errorModel) {
    if (errorModel == null) return;
    ToastHelper.error(title: errorModel.message ?? 'Sunucu Hatası');
  }
}
