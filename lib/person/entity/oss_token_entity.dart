import 'package:Bubble/generated/json/base/json_field.dart';
import 'package:Bubble/generated/json/oss_token_entity.g.dart';
import 'dart:convert';
export 'package:Bubble/generated/json/oss_token_entity.g.dart';

@JsonSerializable()
class OssTokenEntity {
	late int code;
	late OssTokenData data;
	late String message;

	OssTokenEntity();

	factory OssTokenEntity.fromJson(Map<String, dynamic> json) => $OssTokenEntityFromJson(json);

	Map<String, dynamic> toJson() => $OssTokenEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class OssTokenData {
	late int code;
	late String msg;
	late OssTokenDataData data;

	OssTokenData();

	factory OssTokenData.fromJson(Map<String, dynamic> json) => $OssTokenDataFromJson(json);

	Map<String, dynamic> toJson() => $OssTokenDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class OssTokenDataData {
	@JSONField(name: "SecurityToken")
	late String securityToken;
	@JSONField(name: "AccessKeyId")
	late String accessKeyId;
	@JSONField(name: "AccessKeySecret")
	late String accessKeySecret;
	@JSONField(name: "Expiration")
	late String expiration;

	OssTokenDataData();

	factory OssTokenDataData.fromJson(Map<String, dynamic> json) => $OssTokenDataDataFromJson(json);

	Map<String, dynamic> toJson() => $OssTokenDataDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}