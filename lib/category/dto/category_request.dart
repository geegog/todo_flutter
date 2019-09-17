import 'package:json_annotation/json_annotation.dart';
import 'category.dart';

part 'category_request.g.dart';

@JsonSerializable(explicitToJson: true)
class CategoryRequest {
  CategoryRequest(this.category);

  Category category;

  factory CategoryRequest.fromJson(Map<String, dynamic> json) =>
      _$CategoryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryRequestToJson(this);
}
