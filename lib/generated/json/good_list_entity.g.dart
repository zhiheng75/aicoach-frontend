import 'package:Bubble/generated/json/base/json_convert_content.dart';
import 'package:Bubble/person/entity/good_list_entity.dart';

GoodListEntity $GoodListEntityFromJson(Map<String, dynamic> json) {
  final GoodListEntity goodListEntity = GoodListEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    goodListEntity.code = code;
  }
  final GoodListData? data = jsonConvert.convert<GoodListData>(json['data']);
  if (data != null) {
    goodListEntity.data = data;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    goodListEntity.message = message;
  }
  return goodListEntity;
}

Map<String, dynamic> $GoodListEntityToJson(GoodListEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['data'] = entity.data.toJson();
  data['message'] = entity.message;
  return data;
}

extension GoodListEntityExtension on GoodListEntity {
  GoodListEntity copyWith({
    int? code,
    GoodListData? data,
    String? message,
  }) {
    return GoodListEntity()
      ..code = code ?? this.code
      ..data = data ?? this.data
      ..message = message ?? this.message;
  }
}

GoodListData $GoodListDataFromJson(Map<String, dynamic> json) {
  final GoodListData goodListData = GoodListData();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    goodListData.code = code;
  }
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    goodListData.msg = msg;
  }
  final List<GoodListDataData>? data = (json['data'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<GoodListDataData>(e) as GoodListDataData)
      .toList();
  if (data != null) {
    goodListData.data = data;
  }
  return goodListData;
}

Map<String, dynamic> $GoodListDataToJson(GoodListData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['msg'] = entity.msg;
  data['data'] = entity.data.map((v) => v.toJson()).toList();
  return data;
}

extension GoodListDataExtension on GoodListData {
  GoodListData copyWith({
    int? code,
    String? msg,
    List<GoodListDataData>? data,
  }) {
    return GoodListData()
      ..code = code ?? this.code
      ..msg = msg ?? this.msg
      ..data = data ?? this.data;
  }
}

GoodListDataData $GoodListDataDataFromJson(Map<String, dynamic> json) {
  final GoodListDataData goodListDataData = GoodListDataData();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    goodListDataData.name = name;
  }
  final String? desc = jsonConvert.convert<String>(json['desc']);
  if (desc != null) {
    goodListDataData.desc = desc;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    goodListDataData.status = status;
  }
  final int? sort = jsonConvert.convert<int>(json['sort']);
  if (sort != null) {
    goodListDataData.sort = sort;
  }
  final String? updatedAt = jsonConvert.convert<String>(json['updated_at']);
  if (updatedAt != null) {
    goodListDataData.updatedAt = updatedAt;
  }
  final dynamic price = json['price'];
  if (price != null) {
    goodListDataData.price = price;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    goodListDataData.id = id;
  }
  final String? unit = jsonConvert.convert<String>(json['unit']);
  if (unit != null) {
    goodListDataData.unit = unit;
  }
  final String? createdAt = jsonConvert.convert<String>(json['created_at']);
  if (createdAt != null) {
    goodListDataData.createdAt = createdAt;
  }
  final String? productId = jsonConvert.convert<String>(json['product_id']);
  if (productId != null) {
    goodListDataData.productId = productId;
  }
  return goodListDataData;
}

Map<String, dynamic> $GoodListDataDataToJson(GoodListDataData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['desc'] = entity.desc;
  data['status'] = entity.status;
  data['sort'] = entity.sort;
  data['updated_at'] = entity.updatedAt;
  data['price'] = entity.price;
  data['id'] = entity.id;
  data['unit'] = entity.unit;
  data['created_at'] = entity.createdAt;
  data['product_id'] = entity.productId;
  return data;
}

extension GoodListDataDataExtension on GoodListDataData {
  GoodListDataData copyWith({
    String? name,
    String? desc,
    int? status,
    int? sort,
    String? updatedAt,
    dynamic price,
    int? id,
    String? unit,
    String? createdAt,
    String? productId,
  }) {
    return GoodListDataData()
      ..name = name ?? this.name
      ..desc = desc ?? this.desc
      ..status = status ?? this.status
      ..sort = sort ?? this.sort
      ..updatedAt = updatedAt ?? this.updatedAt
      ..price = price ?? this.price
      ..id = id ?? this.id
      ..unit = unit ?? this.unit
      ..createdAt = createdAt ?? this.createdAt
      ..productId = productId ?? this.productId;
  }
}