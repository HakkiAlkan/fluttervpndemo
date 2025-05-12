import 'dart:async';

import 'package:fluttervpndemo/core/enum/vpn_state.dart';
import 'package:fluttervpndemo/core/model/connection_stats/connection_stats_model.dart';
import 'package:fluttervpndemo/core/model/country/country_model.dart';
import 'package:fluttervpndemo/core/model/server/server_model.dart';
import 'package:get/get.dart';

class VpnService extends GetxController {
//#region #init's
//   static const MethodChannel _channel = MethodChannel('com.fluttervpn.demo/vpn');
  Timer? _timer;

//#endregion

//#region #variable's
  var connectionStats = Rx<ConnectionStats?>(null);
  var vpnState = Rx<VpnState>(VpnState.disconnected);

//#endregion

//#region #override's
  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

//#endregion

//#region #methods's

  String formatDuration() {
    final duration = connectionStats.value!.connectedTime!;
    int hours = duration.inHours.remainder(24);
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(hours)} : ${twoDigits(minutes)} : ${twoDigits(seconds)}';
  }

  Future<void> startVpn(CountryModel oVpn, ServerModel sw) async {
    final isSameVpn = connectionStats.value?.connectedCountry?.id == oVpn.id && connectionStats.value?.connectedServer?.id == sw.id;
    stopVpn();
    if (isSameVpn) return;
    vpnState.value = VpnState.initializing;
    await Future.delayed(const Duration(seconds: 2));
    connectionStats.value = ConnectionStats(
      connectedTime: const Duration(seconds: 0),
      downloadSpeed: 0,
      uploadSpeed: 0,
      connectedCountry: oVpn,
      connectedServer: sw,
    );
    vpnState.value = VpnState.connected;
    _startDurationTimer();
  }

  void _startDurationTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (connectionStats.value != null) {
        connectionStats.value = connectionStats.value!.copyWith(
          connectedTime: connectionStats.value!.connectedTime! + const Duration(seconds: 1),
        );
      }
    });
  }

  void stopVpn() {
    _timer?.cancel();
    connectionStats.value = null;
    vpnState.value = VpnState.disconnected;
  }

// Future<void> startVpn({
//   required String serverAddress,
//   required String username,
//   required String password,
//   required String vpnIpAddress,
//   required int vpnNetmask,
//   required List<String> dnsServers,
// }) async {
//   try {
//     await _channel.invokeMethod('startVpn', {
//       'serverAddress': serverAddress,
//       'username': username,
//       'password': password,
//       'vpnIpAddress': vpnIpAddress,
//       'vpnNetmask': vpnNetmask,
//       'dnsServers': dnsServers,
//     });
//   } on PlatformException catch (e) {
//     errorDebugPrint("VPN Başlatılamadı: ${e.message}");
//   }
// }
//
// Future<void> stopVpn() async {
//   try {
//     await _channel.invokeMethod('stopVpn');
//   } on PlatformException catch (e) {
//     errorDebugPrint("VPN Durdurulamadı: ${e.message}");
//   }
// }
//
// Future<Map<String, dynamic>> getVpnStatus() async {
//   try {
//     final status = await _channel.invokeMethod('getVpnStatus');
//     return Map<String, dynamic>.from(status);
//   } on PlatformException catch (e) {
//     errorDebugPrint("VPN Durumu Alınamadı: ${e.message}");
//     return {};
//   }
// }
//#endregion
}
