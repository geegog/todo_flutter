
import 'package:json_annotation/json_annotation.dart';

class MetaData {
  @JsonKey(name: 'page_number')
  int pageNumber;
  @JsonKey(name: 'page_size')
  int pageSize;
  @JsonKey(name: 'total_entries')
  int totalEntries;
  @JsonKey(name: 'total_pages')
  int totalPages;

  MetaData(this.pageNumber, this.pageSize, this.totalEntries, this.totalPages);

  @override
  String toString() => 'MetaData { pageNumber: $pageNumber, pageSize: $pageSize }';

}