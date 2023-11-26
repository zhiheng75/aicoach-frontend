import 'package:spokid/generated/json/base/json_field.dart';
import 'package:spokid/generated/json/empty_response_entity.g.dart';
import 'dart:convert';
export 'package:spokid/generated/json/empty_response_entity.g.dart';

@JsonSerializable()
class EmptyResponseEntity {
	late int code;
	late EmptyResponseData data;
	late String message;

	EmptyResponseEntity();

	factory EmptyResponseEntity.fromJson(Map<String, dynamic> json) => $EmptyResponseEntityFromJson(json);

	Map<String, dynamic> toJson() => $EmptyResponseEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class EmptyResponseData {
	late int code;
	late String msg;
	late EmptyResponseDataData data;

	EmptyResponseData();

	factory EmptyResponseData.fromJson(Map<String, dynamic> json) => $EmptyResponseDataFromJson(json);

	Map<String, dynamic> toJson() => $EmptyResponseDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class EmptyResponseDataData {


	EmptyResponseDataData();

	factory EmptyResponseDataData.fromJson(Map<String, dynamic> json) => $EmptyResponseDataDataFromJson(json);

	Map<String, dynamic> toJson() => $EmptyResponseDataDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}