class TasksAndApprovalsModel {
  List<Items>? items;
  int? count;
  bool? hasMore;
  int? limit;
  int? offset;
  List<Links>? links;

  TasksAndApprovalsModel({
    this.items,
    this.count,
    this.hasMore,
    this.limit,
    this.offset,
    this.links,
  });

  TasksAndApprovalsModel.fromJson(Map<String, dynamic> json) {
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
  int? teamCode;
  String? teamsNameA;
  String? teamsNameE;
  int? serial;
  String? trnsDate;
  dynamic bandSerial;
  dynamic bandDetSerial;
  int? bandCode;
  int? bandCodeDet;
  String? bandNameA;
  String? bandNameE;
  int? unitCode;
  String? unitNameA;
  String? unitNameE;
  int? quantity;
  String? notes;
  String? altKey;
  int? insertUser;
  String? insertDate;
  int? contractSerial;
  int? authFlag;
  dynamic authDesc;
  dynamic authUser;
  dynamic authUserNameA;
  dynamic authUserNameE;
  dynamic authDate;
  String? authStatusA;
  String? authStatusE;
  List<Links>? links;

  Items({
    this.teamCode,
    this.teamsNameA,
    this.teamsNameE,
    this.serial,
    this.trnsDate,
    this.bandSerial,
    this.bandDetSerial,
    this.bandCode,
    this.bandCodeDet,
    this.bandNameA,
    this.bandNameE,
    this.unitCode,
    this.unitNameA,
    this.unitNameE,
    this.quantity,
    this.notes,
    this.altKey,
    this.insertUser,
    this.insertDate,
    this.contractSerial,
    this.authFlag,
    this.authDesc,
    this.authUser,
    this.authUserNameA,
    this.authUserNameE,
    this.authDate,
    this.authStatusA,
    this.authStatusE,
    this.links,
  });

  Items.fromJson(Map<String, dynamic> json) {
    teamCode = json['TeamCode'];
    teamsNameA = json['TeamsNameA'];
    teamsNameE = json['TeamsNameE'];
    serial = json['Serial'];
    trnsDate = json['TrnsDate'];
    bandSerial = json['BandSerial'];
    bandDetSerial = json['BandDetSerial'];
    bandCode = json['BandCode'];
    bandCodeDet = json['BandCodeDet'];
    bandNameA = json['BandNameA'];
    bandNameE = json['BandNameE'];
    unitCode = json['UnitCode'];
    unitNameA = json['UnitNameA'];
    unitNameE = json['UnitNameE'];
    quantity = json['Quantity'];
    notes = json['Notes'];
    altKey = json['AltKey'];
    insertUser = json['InsertUser'];
    insertDate = json['InsertDate'];
    contractSerial = json['ContractSerial'];
    authFlag = json['AuthFlag'];
    authDesc = json['AuthDesc'];
    authUser = json['AuthUser'];
    authUserNameA = json['AuthUserNameA'];
    authUserNameE = json['AuthUserNameE'];
    authDate = json['AuthDate'];
    authStatusA = json['AuthStatusA'];
    authStatusE = json['AuthStatusE'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TeamCode'] = this.teamCode;
    data['TeamsNameA'] = this.teamsNameA;
    data['TeamsNameE'] = this.teamsNameE;
    data['Serial'] = this.serial;
    data['TrnsDate'] = this.trnsDate;
    data['BandSerial'] = this.bandSerial;
    data['BandDetSerial'] = this.bandDetSerial;
    data['BandCode'] = this.bandCode;
    data['BandCodeDet'] = this.bandCodeDet;
    data['BandNameA'] = this.bandNameA;
    data['BandNameE'] = this.bandNameE;
    data['UnitCode'] = this.unitCode;
    data['UnitNameA'] = this.unitNameA;
    data['UnitNameE'] = this.unitNameE;
    data['Quantity'] = this.quantity;
    data['Notes'] = this.notes;
    data['AltKey'] = this.altKey;
    data['InsertUser'] = this.insertUser;
    data['InsertDate'] = this.insertDate;
    data['ContractSerial'] = this.contractSerial;
    data['AuthFlag'] = this.authFlag;
    data['AuthDesc'] = this.authDesc;
    data['AuthUser'] = this.authUser;
    data['AuthUserNameA'] = this.authUserNameA;
    data['AuthUserNameE'] = this.authUserNameE;
    data['AuthDate'] = this.authDate;
    data['AuthStatusA'] = this.authStatusA;
    data['AuthStatusE'] = this.authStatusE;
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
