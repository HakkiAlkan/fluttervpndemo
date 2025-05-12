import 'package:fluttervpndemo/base/model/base_model.dart';
import 'package:fluttervpndemo/core/enum/auth_type.dart';

class UserModel extends BaseModel<UserModel> {
  int? id;
  String? name;
  String? surname;
  AuthType? authType;

  UserModel({
    this.id,
    this.name,
    this.surname,
    this.authType,
  });

  UserModel.initial()
      : id = -1,
        name = 'Guest',
        surname = 'Guest',
        authType = AuthType.quest;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        surname: json["surname"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "surname": surname,
      };

  @override
  UserModel fromJson(Map<String, dynamic> json) => UserModel.fromJson(json);
}
