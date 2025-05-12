import 'package:fluttervpndemo/base/model/base_model.dart';
import 'package:fluttervpndemo/core/model/server/server_model.dart';

class CountryModel extends BaseModel<CountryModel> {
  int? id;
  String? name;
  String? flag;
  int? locationCount;
  List<ServerModel>? serverList;
  bool isExpand;
  bool isVisible;

  CountryModel({
    this.id,
    this.name,
    this.flag,
    this.locationCount,
    this.serverList,
    this.isExpand = false,
    this.isVisible = true,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        id: json["id"],
        name: json["name"],
        flag: json["flag"],
        locationCount: json["locationCount"],
        serverList: json["serverList"] == null ? null : List<ServerModel>.from(json["serverList"].map((x) => ServerModel.fromJson(x))),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "flag": flag,
        "locationCount": locationCount,
        "serverList": serverList == null ? null : List<dynamic>.from(serverList!.map((x) => x.toJson())),
      };

  @override
  CountryModel fromJson(Map<String, dynamic> json) => CountryModel.fromJson(json);
}
