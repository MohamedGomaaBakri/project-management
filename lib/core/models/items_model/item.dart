import 'link.dart';

class Item {
  String? itemCode;
  String? itemNameA;
  dynamic itemNameE;
  int? itemGroupCode;
  int? itemSerial;
  int? detSerial;
  double? basicQty;
  int? restQty;
  String? altKey;
  int? projectId;
  int? unitCode;
  String? unitNameA;
  String? unitNameE;
  List<Link>? links;

  Item({
    this.itemCode,
    this.itemNameA,
    this.itemNameE,
    this.itemGroupCode,
    this.itemSerial,
    this.detSerial,
    this.basicQty,
    this.restQty,
    this.altKey,
    this.projectId,
    this.unitCode,
    this.unitNameA,
    this.unitNameE,
    this.links,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    itemCode: json['ItemCode'] as String?,
    itemNameA: json['ItemNameA'] as String?,
    itemNameE: json['ItemNameE'] as dynamic,
    itemGroupCode: json['ItemGroupCode'] as int?,
    itemSerial: json['ItemSerial'] as int?,
    detSerial: json['DetSerial'] as int?,
    basicQty: (json['BasicQty'] as num?)?.toDouble(),
    restQty: json['RestQty'] as int?,
    altKey: json['AltKey'] as String?,
    projectId: json['ProjectId'] as int?,
    unitCode: json['UnitCode'] as int?,
    unitNameA: json['UnitNameA'] as String?,
    unitNameE: json['UnitNameE'] as String?,
    links: (json['links'] as List<dynamic>?)
        ?.map((e) => Link.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'ItemCode': itemCode,
    'ItemNameA': itemNameA,
    'ItemNameE': itemNameE,
    'ItemGroupCode': itemGroupCode,
    'ItemSerial': itemSerial,
    'DetSerial': detSerial,
    'BasicQty': basicQty,
    'RestQty': restQty,
    'AltKey': altKey,
    'ProjectId': projectId,
    'UnitCode': unitCode,
    'UnitNameA': unitNameA,
    'UnitNameE': unitNameE,
    'links': links?.map((e) => e.toJson()).toList(),
  };
}
