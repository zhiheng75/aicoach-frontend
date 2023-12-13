import 'package:Bubble/generated/json/base/json_field.dart';
import 'package:Bubble/generated/json/send_img_result_entity.g.dart';
import 'dart:convert';
export 'package:Bubble/generated/json/send_img_result_entity.g.dart';

@JsonSerializable()
class SendImgResultEntity {
	late int code;
	late SendImgResultData data;
	late String message;

	SendImgResultEntity();

	factory SendImgResultEntity.fromJson(Map<String, dynamic> json) => $SendImgResultEntityFromJson(json);

	Map<String, dynamic> toJson() => $SendImgResultEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class SendImgResultData {
	late int code;
	late String msg;
	late List<SendImgResultDataData> data;

	SendImgResultData();

	factory SendImgResultData.fromJson(Map<String, dynamic> json) => $SendImgResultDataFromJson(json);

	Map<String, dynamic> toJson() => $SendImgResultDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class SendImgResultDataData {
	late String filename;
	@JSONField(name: "content-type")
	late String contentType;

	SendImgResultDataData();

	factory SendImgResultDataData.fromJson(Map<String, dynamic> json) => $SendImgResultDataDataFromJson(json);

	Map<String, dynamic> toJson() => $SendImgResultDataDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}