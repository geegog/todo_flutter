
import 'package:json_annotation/json_annotation.dart';

class MetaData {
  String after;
  String before;
  dynamic limit;
  @JsonKey(name: 'total_count')
  dynamic totalCount;
  @JsonKey(name: 'total_count_cap_exceeded')
  dynamic totalCountCapExceeded;

  MetaData(this.limit, this.before, this.after, this.totalCount, this.totalCountCapExceeded);

}