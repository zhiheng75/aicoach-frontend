import 'package:Bubble/generated/json/base/json_field.dart';
import 'package:Bubble/generated/json/good_list_entity.g.dart';
import 'dart:convert';
export 'package:Bubble/generated/json/good_list_entity.g.dart';

@JsonSerializable()
class GoodListEntity {
	late int code;
	late GoodListData data;
	late String message;

	GoodListEntity();

	factory GoodListEntity.fromJson(Map<String, dynamic> json) => $GoodListEntityFromJson(json);

	Map<String, dynamic> toJson() => $GoodListEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class GoodListData {
	late int code;
	late String msg;
	late List<GoodListDataData> data;

	GoodListData();

	factory GoodListData.fromJson(Map<String, dynamic> json) => $GoodListDataFromJson(json);

	Map<String, dynamic> toJson() => $GoodListDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class GoodListDataData {
	late String name;
	late String desc;
	late int status;
	late int sort;
	@JSONField(name: "updated_at")
	late String updatedAt;
	late dynamic price;
	late int id;
	late String unit;
	@JSONField(name: "created_at")
	late String createdAt;
	// late bool isSelect;
	// late bool recommend;

	GoodListDataData();

	factory GoodListDataData.fromJson(Map<String, dynamic> json) => $GoodListDataDataFromJson(json);

	Map<String, dynamic> toJson() => $GoodListDataDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}