import 'link.dart';

class Band {
  int? bandCodeDet;
  String? bandName;
  String? bandNameE;
  int? serialMast;
  int? serial;
  int? bandCode;
  int? execQty;
  int? restQty;
  int? projectId;
  String? altKey;
  List<Link>? links;

  Band({
    this.bandCodeDet,
    this.bandName,
    this.bandNameE,
    this.serialMast,
    this.serial,
    this.bandCode,
    this.execQty,
    this.restQty,
    this.projectId,
    this.altKey,
    this.links,
  });

  factory Band.fromJson(Map<String, dynamic> json) => Band(
    bandCodeDet: json['BandCodeDet'] as int?,
    bandName: json['BandName'] as String?,
    bandNameE: json['BandNameE'] as String?,
    serialMast: json['SerialMast'] as int?,
    serial: json['Serial'] as int?,
    bandCode: json['BandCode'] as int?,
    execQty: json['ExecQty'] as int?,
    restQty: json['RestQty'] as int?,
    projectId: json['ProjectId'] as int?,
    altKey: json['AltKey'] as String?,
    links: (json['links'] as List<dynamic>?)
        ?.map((e) => Link.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'BandCodeDet': bandCodeDet,
    'BandName': bandName,
    'BandNameE': bandNameE,
    'SerialMast': serialMast,
    'Serial': serial,
    'BandCode': bandCode,
    'ExecQty': execQty,
    'RestQty': restQty,
    'ProjectId': projectId,
    'AltKey': altKey,
    'links': links?.map((e) => e.toJson()).toList(),
  };
}
