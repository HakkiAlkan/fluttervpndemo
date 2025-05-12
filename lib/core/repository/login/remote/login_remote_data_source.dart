import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluttervpndemo/base/service/network/network_api_service.dart';
import 'package:fluttervpndemo/base/service/network/network_url/app_network_urls.dart';
import 'package:fluttervpndemo/base/service/network/service_helper.dart';
import 'package:fluttervpndemo/core/model/user/user_model.dart';

class LoginRemoteDataSource extends NetworkServiceHelper {
  final NetworkApiService networkManager;

  LoginRemoteDataSource({required this.networkManager});

  Future<UserModel?> login(Map<String, String> formData) async {
    final response = await networkManager.postApiResponse<UserModel>(
      AppNetworkUrls.baseApiUrl,
      parseModel: UserModel(),
      formData: FormData.fromMap({"account": jsonEncode(formData)}),
    );
    showMessage(response.error);
    return response.data;
  }
}
