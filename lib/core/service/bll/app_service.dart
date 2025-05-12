import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttervpndemo/base/service/network/network_url/app_network_urls.dart';

class AppService {
  Future<bool> isRunApi() async {
    bool connect = false;
    try {
      final result = await InternetAddress.lookup(AppNetworkUrls.baseApiUrl.replaceAll("https://", "").replaceAll("/", ""));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connect = true;
      }
    } on SocketException catch (e) {
      connect = false;
      debugPrint('$e = internet yok / AppService/isRunApi');
    }
    return connect;
  }
}

base64Dec(String img64) {
  Uint8List bytes = base64.decode(img64);
  return bytes;
}

String base64Enc(Uint8List data) {
  return base64Encode(data);
}
