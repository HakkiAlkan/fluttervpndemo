import 'package:fluttervpndemo/base/model/base_model.dart';

class ServerModel extends BaseModel<ServerModel> {
  int? id;
  int? countryId;
  String? name;
  String? city;
  int? strength;

  ServerModel({
    this.id,
    this.countryId,
    this.name,
    this.city,
    this.strength,
  });

  factory ServerModel.fromJson(Map<String, dynamic> json) => ServerModel(
        id: json["id"],
        countryId: json["countryId"],
        name: json["name"],
        city: json["city"],
        strength: json["strength"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "countryId": countryId,
        "name": name,
        "city": city,
        "strength": strength,
      };

  @override
  ServerModel fromJson(Map<String, dynamic> json) => ServerModel.fromJson(json);
}
