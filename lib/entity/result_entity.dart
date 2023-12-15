import 'package:Bubble/generated/json/base/json_field.dart';
import 'dart:convert';
export 'package:Bubble/generated/json/empty_response_entity.g.dart';

@JsonSerializable()
class ResultData {
	late int code;
	late String msg;
	late Object? data;

	ResultData();

	factory ResultData.fromJson(Map<String, dynamic> json) {
		ResultData resultData = ResultData();
		resultData.code = json['code'];
		resultData.msg = json['msg'];
		resultData.data = json['data'];
		return resultData;
	}

	Map<String, dynamic> toJson() {
		return {
			'code': code,
			'msg': msg,
			'data': data,
		};
	}

	@override
	String toString() {
		return jsonEncode(this);
	}
}