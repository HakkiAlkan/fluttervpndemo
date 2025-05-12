import 'package:fluttervpndemo/core/enum/app_state.dart';
import 'package:fluttervpndemo/core/enum/auth_type.dart';
import 'package:fluttervpndemo/core/model/user/user_model.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
//#region #init's
//#endregion

//#region #variable's
  late AppState _appState;

  AppState get appState => _appState;

  late UserModel _userModel;

  UserModel get userModel => _userModel;

//#endregion

//#region #override's

  @override
  void onInit() {
    super.onInit();
    _userModel = UserModel.initial();
    _appState = AppState.initializing;
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await checkUser();
  }

//#endregion

//#region #methods's

  void setUser(UserModel model) {
    _userModel = model;
  }

  Future<void> checkUser() async {
    await Future.delayed(const Duration(seconds: 2)); // API Request
    setUser(UserModel(id: 10, authType: AuthType.verified, name: 'Hakkı', surname: 'ALKAN'));
    _appState = AppState.ready;
    update(); // Go-Router
  }
//#endregion
}
