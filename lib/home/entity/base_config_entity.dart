import 'package:Bubble/generated/json/base/json_field.dart';
import 'package:Bubble/generated/json/base_config_entity.g.dart';
import 'dart:convert';
export 'package:Bubble/generated/json/base_config_entity.g.dart';

@JsonSerializable()
class BaseConfigEntity {
	late int code;
	late BaseConfigData data;
	late String message;

	BaseConfigEntity();

	factory BaseConfigEntity.fromJson(Map<String, dynamic> json) => $BaseConfigEntityFromJson(json);

	Map<String, dynamic> toJson() => $BaseConfigEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class BaseConfigData {
	late int code;
	late String msg;
	late List<BaseConfigDataData> data;

	BaseConfigData();

	factory BaseConfigData.fromJson(Map<String, dynamic> json) => $BaseConfigDataFromJson(json);

	Map<String, dynamic> toJson() => $BaseConfigDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class BaseConfigDataData {
	late String key;
	late String value;
	late int status;
	late int id;
	late String desc;
	@JSONField(name: "created_at")
	late String createdAt;

	BaseConfigDataData();

	factory BaseConfigDataData.fromJson(Map<String, dynamic> json) => $BaseConfigDataDataFromJson(json);

	Map<String, dynamic> toJson() => $BaseConfigDataDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}