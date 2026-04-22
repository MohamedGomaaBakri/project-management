class TeamsModel {
  List<Items>? items;
  int? count;
  bool? hasMore;
  int? limit;
  int? offset;
  List<Links>? links;

  TeamsModel({
    this.items,
    this.count,
    this.hasMore,
    this.limit,
    this.offset,
    this.links,
  });

  TeamsModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    count = json['count'];
    hasMore = json['hasMore'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    data['hasMore'] = this.hasMore;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? bandCodeDet;
  String? bandName;
  String? bandNameE;
  int? bandCode;
  String? altKey;
  int? teamType;
  int? teamCode;
  int? unitCode;
  String? unitNameA;
  String? unitNameE;
  String? teamNameA;
  String? teamNameE;
  String? teamNo;
  List<Links>? links;

  Items({
    this.bandCodeDet,
    this.bandName,
    this.bandNameE,
    this.bandCode,
    this.altKey,
    this.teamType,
    this.teamCode,
    this.unitCode,
    this.unitNameA,
    this.unitNameE,
    this.teamNameA,
    this.teamNameE,
    this.teamNo,
    this.links,
  });

  Items.fromJson(Map<String, dynamic> json) {
    bandCodeDet = json['BandCodeDet'];
    bandName = json['BandName'];
    bandNameE = json['BandNameE'];
    bandCode = json['BandCode'];
    altKey = json['AltKey'];
    teamType = json['TeamType'];
    teamCode = json['TeamCode'];
    unitCode = json['UnitCode'];
    unitNameA = json['UnitNameA'];
    unitNameE = json['UnitNameE'];
    teamNameA = json['TeamNameA'];
    teamNameE = json['TeamNameE'];
    teamNo = json['TeamNo'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BandCodeDet'] = this.bandCodeDet;
    data['BandName'] = this.bandName;
    data['BandNameE'] = this.bandNameE;
    data['BandCode'] = this.bandCode;
    data['AltKey'] = this.altKey;
    data['TeamType'] = this.teamType;
    data['TeamCode'] = this.teamCode;
    data['UnitCode'] = this.unitCode;
    data['UnitNameA'] = this.unitNameA;
    data['UnitNameE'] = this.unitNameE;
    data['TeamNameA'] = this.teamNameA;
    data['TeamNameE'] = this.teamNameE;
    data['TeamNo'] = this.teamNo;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Links {
  String? rel;
  String? href;
  String? name;
  String? kind;

  Links({this.rel, this.href, this.name, this.kind});

  Links.fromJson(Map<String, dynamic> json) {
    rel = json['rel'];
    href = json['href'];
    name = json['name'];
    kind = json['kind'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rel'] = this.rel;
    data['href'] = this.href;
    data['name'] = this.name;
    data['kind'] = this.kind;
    return data;
  }
}
