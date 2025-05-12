import 'package:fluttervpndemo/core/model/user/user_model.dart';
import 'package:fluttervpndemo/core/repository/login/local/login_local_data_source.dart';
import 'package:fluttervpndemo/core/repository/login/remote/login_remote_data_source.dart';

class LoginRepository {
  final LoginRemoteDataSource remote;
  final LoginLocalDataSource local;

  LoginRepository({required this.remote, required this.local});

  Future<UserModel?> login(Map<String, String> formData) async {
    return await remote.login(formData);
  }
}
