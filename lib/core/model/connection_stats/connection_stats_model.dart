import 'package:fluttervpndemo/base/model/base_model.dart';
import 'package:fluttervpndemo/core/model/country/country_model.dart';
import 'package:fluttervpndemo/core/model/server/server_model.dart';

class ConnectionStats extends BaseModel<ConnectionStats> {
  int? downloadSpeed;
  int? uploadSpeed;
  Duration? connectedTime;
  CountryModel? connectedCountry;
  ServerModel? connectedServer;

  ConnectionStats({
    this.downloadSpeed,
    this.uploadSpeed,
    this.connectedTime,
    this.connectedCountry,
    this.connectedServer,
  });

  factory ConnectionStats.fromJson(Map<String, dynamic> json) => ConnectionStats(
        downloadSpeed: json["downloadSpeed"],
        uploadSpeed: json["uploadSpeed"],
        connectedTime: json["connectedTime"],
        connectedCountry: json["connectedCountry"],
        connectedServer: json["connectedServer"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "downloadSpeed": downloadSpeed,
        "uploadSpeed": uploadSpeed,
        "connectedTime": connectedTime,
        "connectedCountry": connectedCountry,
        "connectedServer": connectedServer,
      };

  ConnectionStats copyWith({
    int? downloadSpeed,
    int? uploadSpeed,
    Duration? connectedTime,
    CountryModel? connectedCountry,
    ServerModel? connectedServer,
  }) {
    return ConnectionStats(
      downloadSpeed: downloadSpeed ?? this.downloadSpeed,
      uploadSpeed: uploadSpeed ?? this.uploadSpeed,
      connectedTime: connectedTime ?? this.connectedTime,
      connectedCountry: connectedCountry ?? this.connectedCountry,
      connectedServer: connectedServer ?? this.connectedServer,
    );
  }

  @override
  ConnectionStats fromJson(Map<String, dynamic> json) => ConnectionStats.fromJson(json);
}
