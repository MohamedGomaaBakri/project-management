import 'link.dart';

class BandAndItem {
  int? projectId;
  int? partId;
  int? flowId;
  int? procId;
  int? serial;
  int? bandSerial;
  int? bandDetSerial;
  int? bandCode;
  int? bandCodeDet;
  String? bandNameA;
  String? bandNameE;
  String? trnsDate;
  num? bandQty;
  int? detSerial;
  int? itemSerial;
  int? groupCode;
  String? itemCode;
  String? itemNameA;
  dynamic itemNameE;
  int? unitCode;
  String? unitNameA;
  String? unitNameE;
  num? itemQty;
  dynamic descA;
  dynamic descE;
  int? insertUser;
  String? insertDate;
  String? altKey;
  int? bandCodeCnt;
  num? itemBasicQty;
  num? bandRestQty;
  num? itemRestQty;
  List<Link>? links;

  BandAndItem({
    this.projectId,
    this.partId,
    this.flowId,
    this.procId,
    this.serial,
    this.bandSerial,
    this.bandDetSerial,
    this.bandCode,
    this.bandCodeDet,
    this.bandNameA,
    this.bandNameE,
    this.trnsDate,
    this.bandQty,
    this.detSerial,
    this.itemSerial,
    this.groupCode,
    this.itemCode,
    this.itemNameA,
    this.itemNameE,
    this.unitCode,
    this.unitNameA,
    this.unitNameE,
    this.itemQty,
    this.descA,
    this.descE,
    this.insertUser,
    this.insertDate,
    this.altKey,
    this.bandCodeCnt,
    this.itemBasicQty,
    this.bandRestQty,
    this.itemRestQty,
    this.links,
  });

  factory BandAndItem.fromJson(Map<String, dynamic> json) => BandAndItem(
    projectId: json['ProjectId'] as int?,
    partId: json['PartId'] as int?,
    flowId: json['FlowId'] as int?,
    procId: json['ProcId'] as int?,
    serial: json['Serial'] as int?,
    bandSerial: json['BandSerial'] as int?,
    bandDetSerial: json['BandDetSerial'] as int?,
    bandCode: json['BandCode'] as int?,
    bandCodeDet: json['BandCodeDet'] as int?,
    bandNameA: json['BandNameA'] as String?,
    bandNameE: json['BandNameE'] as String?,
    trnsDate: json['TrnsDate'] as String?,
    bandQty: json['BandQty'] as num?,
    detSerial: json['DetSerial'] as int?,
    itemSerial: json['ItemSerial'] as int?,
    groupCode: json['GroupCode'] as int?,
    itemCode: json['ItemCode'] as String?,
    itemNameA: json['ItemNameA'] as String?,
    itemNameE: json['ItemNameE'] as dynamic,
    unitCode: json['UnitCode'] as int?,
    unitNameA: json['UnitNameA'] as String?,
    unitNameE: json['UnitNameE'] as String?,
    itemQty: json['ItemQty'] as num?,
    descA: json['DescA'] as dynamic,
    descE: json['DescE'] as dynamic,
    insertUser: json['InsertUser'] as int?,
    insertDate: json['InsertDate'] as String?,
    altKey: json['AltKey'] as String?,
    bandCodeCnt: json['BandCodeCnt'] as int?,
    itemBasicQty: json['ItemBasicQty'] as num?,
    bandRestQty: json['BandRestQty'] as num?,
    itemRestQty: json['ItemRestQty'] as num?,
    links: (json['links'] as List<dynamic>?)
        ?.map((e) => Link.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'ProjectId': projectId,
    'PartId': partId,
    'FlowId': flowId,
    'ProcId': procId,
    'Serial': serial,
    'BandSerial': bandSerial,
    'BandDetSerial': bandDetSerial,
    'BandCode': bandCode,
    'BandCodeDet': bandCodeDet,
    'BandNameA': bandNameA,
    'BandNameE': bandNameE,
    'TrnsDate': trnsDate,
    'BandQty': bandQty,
    'DetSerial': detSerial,
    'ItemSerial': itemSerial,
    'GroupCode': groupCode,
    'ItemCode': itemCode,
    'ItemNameA': itemNameA,
    'ItemNameE': itemNameE,
    'UnitCode': unitCode,
    'UnitNameA': unitNameA,
    'UnitNameE': unitNameE,
    'ItemQty': itemQty,
    'DescA': descA,
    'DescE': descE,
    'InsertUser': insertUser,
    'InsertDate': insertDate,
    'AltKey': altKey,
    'BandCodeCnt': bandCodeCnt,
    'ItemBasicQty': itemBasicQty,
    'BandRestQty': bandRestQty,
    'ItemRestQty': itemRestQty,
    'links': links?.map((e) => e.toJson()).toList(),
  };
}
