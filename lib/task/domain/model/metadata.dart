
import 'package:json_annotation/json_annotation.dart';

class MetaData {
  String _after;
  String _before;
  dynamic _limit;
  @JsonKey(name: 'total_count')
  dynamic _totalCount;
  @JsonKey(name: 'total_count_cap_exceeded')
  dynamic _totalCountCapExceeded;

  String get getAfter => this._after;
  String get getBefore => this._before;
  dynamic get getLimit => this._limit;
  dynamic get getTotalCount => this._totalCount;
  dynamic get getTotalCountCapExceeded => this._totalCountCapExceeded;

}