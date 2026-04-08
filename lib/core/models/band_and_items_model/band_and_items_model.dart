import 'item.dart';
import 'link.dart';

class BandAndItemsModel {
  final List<BandAndItem>? items;
  final int? count;
  final bool? hasMore;
  final int? limit;
  final int? offset;
  final List<Link>? links;

  BandAndItemsModel({
    this.items,
    this.count,
    this.hasMore,
    this.limit,
    this.offset,
    this.links,
  });

  factory BandAndItemsModel.fromJson(Map<String, dynamic> json) {
    return BandAndItemsModel(
      items: (json['items'] as List<dynamic>?)
          ?.map(
            (e) => BandAndItem.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
      count: (json['count'] as num?)?.toInt(),
      hasMore: json['hasMore'] as bool?,
      limit: (json['limit'] as num?)?.toInt(),
      offset: (json['offset'] as num?)?.toInt(),
      links: (json['links'] as List<dynamic>?)
          ?.map((e) => Link.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items?.map((x) => x.toJson()).toList(),
      'count': count,
      'hasMore': hasMore,
      'limit': limit,
      'offset': offset,
      'links': links?.map((x) => x.toJson()).toList(),
    };
  }
}
