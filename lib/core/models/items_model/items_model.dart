import 'item.dart';
import 'link.dart';

class ItemsModel {
  List<Item>? items;
  int? count;
  bool? hasMore;
  int? limit;
  int? offset;
  List<Link>? links;

  ItemsModel({
    this.items,
    this.count,
    this.hasMore,
    this.limit,
    this.offset,
    this.links,
  });

  factory ItemsModel.fromJson(Map<String, dynamic> json) => ItemsModel(
    items: (json['items'] as List<dynamic>?)
        ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
        .toList(),
    count: json['count'] as int?,
    hasMore: json['hasMore'] as bool?,
    limit: json['limit'] as int?,
    offset: json['offset'] as int?,
    links: (json['links'] as List<dynamic>?)
        ?.map((e) => Link.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'items': items?.map((e) => e.toJson()).toList(),
    'count': count,
    'hasMore': hasMore,
    'limit': limit,
    'offset': offset,
    'links': links?.map((e) => e.toJson()).toList(),
  };
}
