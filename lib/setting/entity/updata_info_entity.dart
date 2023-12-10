import 'package:Bubble/generated/json/base/json_field.dart';
import 'package:Bubble/generated/json/updata_info_entity.g.dart';
import 'dart:convert';
export 'package:Bubble/generated/json/updata_info_entity.g.dart';

@JsonSerializable()
class UpdataInfoEntity {
	late int code;
	late UpdataInfoData data;
	late String message;

	UpdataInfoEntity();

	factory UpdataInfoEntity.fromJson(Map<String, dynamic> json) => $UpdataInfoEntityFromJson(json);

	Map<String, dynamic> toJson() => $UpdataInfoEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class UpdataInfoData {
	late int code;
	late String msg;
	late UpdataInfoDataData data;

	UpdataInfoData();

	factory UpdataInfoData.fromJson(Map<String, dynamic> json) => $UpdataInfoDataFromJson(json);

	Map<String, dynamic> toJson() => $UpdataInfoDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class UpdataInfoDataData {
	late String version;
	@JSONField(name: "force_update")
	late bool forceUpdate;
	@JSONField(name: "version_code")
	late int versionCode;
	late String platform;
	@JSONField(name: "created_at")
	late String createdAt;
	late int id;
	late String message;
	late String package;
	late bool online;
	@JSONField(name: "updated_at")
	late String updatedAt;

	UpdataInfoDataData();

	factory UpdataInfoDataData.fromJson(Map<String, dynamic> json) => $UpdataInfoDataDataFromJson(json);

	Map<String, dynamic> toJson() => $UpdataInfoDataDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}