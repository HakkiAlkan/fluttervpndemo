import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttervpndemo/base/model/base_model.dart';
import 'package:fluttervpndemo/base/model/response_model.dart';
import 'package:fluttervpndemo/base/service/network/network_url/app_network_urls.dart';
import 'package:fluttervpndemo/core/service/bll/app_service.dart';
import 'package:get/get.dart' as getx;
import 'app_exception.dart';

class NetworkApiService {
  late BaseOptions options;
  late Dio _client;

  // final AppService appService = locator<AppService>();

  NetworkApiService() {
    options = BaseOptions();
    options.connectTimeout = const Duration(minutes: 2);
    options.receiveTimeout = const Duration(minutes: 2);
    options.baseUrl = AppNetworkUrls.baseApiUrl;
    // options.headers["_token"] = locator<AppService>().getToken();
    // options.headers["FirebaseID"] = "1";
    // options.headers['OsID'] = Platform.isIOS ? 1 : 2;
    // options.headers["Version"] = "";
    // options.headers["LangID"] = "";
    // options.headers["Authorization"] = "Bearer 4";
    _init(options);
  }

  _init(BaseOptions baseOptions) {
    _client = Dio(baseOptions);
    _client.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      debugPrint("Request..[${options.path}]  ${Random().nextInt(99).toString()}");
      return handler.next(options); //continue
    }, onResponse: (response, handler) {
      debugPrint("Response.. [${response.requestOptions.path}]  ${Random().nextInt(99).toString()}");
      return handler.next(response); // continue
    }, onError: (DioException e, handler) {
      debugPrint("▐▐▐▐  [onError] ▐▐▐▐ ");
      debugPrint('ERROR[${e.response?.statusCode}] => PATH: ${e.error}');
      debugPrint("▐▐▐▐  [onError] ▐▐▐▐ ");
      return handler.next(e); //continue
    }));
  }

  void setToken(String token) {
    options.headers["_token"] = token;
  }

  Future<ResponseModel> postApiResponse<T>(String path, {required T parseModel, FormData? formData, Map<String, dynamic>? queryParameters, void Function(int, int)? onReceiveProgress, Map<String, dynamic>? headers}) async {
    try {
      Response response;
      bool connectivityResult = await getx.Get.find<AppService>().isRunApi();
      if (connectivityResult) {
        if (headers != null && headers.isNotEmpty) {
          response = await _client.request(path, data: formData, options: Options(method: 'POST', headers: headers));
        } else {
          response = await _client.post(path, data: formData, options: Options(method: 'POST'));
        }
        return _checkResponseStatus<T>(response, parseModel);
      } else {
        debugPrint('İnternet Yok');
        return ResponseModel(error: BaseError(message: 'İnternet Bulunmamaktadır!'));
      }
    } on DioException catch (e) {
      return ResponseModel(error: BaseError(message: e.message));
    } on Exception catch (e) {
      return ResponseModel(error: BaseError(message: e.toString()));
    }
  }

  ResponseModel _checkResponseStatus<T>(Response response, dynamic parseModel) {
    switch (response.statusCode) {
      case 200:
        final model = _parseBody<T>(parseModel, response.data);
        return ResponseModel<T>(data: model);
      case 400:
        throw BadRequestException(response.statusCode.toString());
      case 401:
        throw UnauthorisedException(response.statusCode.toString());
      case 403:
        throw ForbiddenException(response.statusCode.toString());
      case 404:
        throw NotFoundException(response.statusCode.toString());
      case 500:
        throw InternalServerError(response.statusCode.toString());
      default:
        throw FetchDataException('Error occurred while communicating with server with status code: ${response.statusCode}');
    }
  }

  T _parseBody<T>(BaseModel parseModel, dynamic responseBody) {
    if (responseBody is List) {
      return responseBody.map((data) => parseModel.fromJson(data)).cast<T>().toList() as T;
    } else if (responseBody is Map<String, dynamic>) {
      return parseModel.fromJson(responseBody) as T;
    }
    return parseModel as T;
  }
}
