class MaterialsModel {
  List<Items>? items;
  int? count;
  bool? hasMore;
  int? limit;
  int? offset;
  List<Links>? links;

  MaterialsModel({
    this.items,
    this.count,
    this.hasMore,
    this.limit,
    this.offset,
    this.links,
  });

  MaterialsModel.fromJson(Map<String, dynamic> json) {
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
  int? projectId;
  String? contractNo;
  String? projectNameA;
  dynamic projectNameE;
  int? serial;
  String? trnsDate;
  int? groupCode;
  String? itemCode;
  String? itemNameA;
  dynamic itemNameE;
  int? unitCode;
  String? unitNameA;
  String? unitNameE;
  double? quantity;
  String? descA;
  dynamic descE;
  int? insertUser;
  String? insertUserNameA;
  dynamic insertUserNameE;
  String? insertDate;
  int? authFlag;
  dynamic authUser;
  dynamic authUserNameA;
  dynamic authUserNameE;
  dynamic authDate;
  dynamic authDesc;
  String? altKey;
  dynamic reqTrnsTypeCode;
  dynamic reqTrnsSerial;
  dynamic outTrnsTypeCode;
  dynamic outTrnsSerial;
  String? authNameA;
  String? authNameE;
  int? statusFlag;
  String? statusNameA;
  String? statusNameE;
  List<Links>? links;

  Items({
    this.projectId,
    this.contractNo,
    this.projectNameA,
    this.projectNameE,
    this.serial,
    this.trnsDate,
    this.groupCode,
    this.itemCode,
    this.itemNameA,
    this.itemNameE,
    this.unitCode,
    this.unitNameA,
    this.unitNameE,
    this.quantity,
    this.descA,
    this.descE,
    this.insertUser,
    this.insertUserNameA,
    this.insertUserNameE,
    this.insertDate,
    this.authFlag,
    this.authUser,
    this.authUserNameA,
    this.authUserNameE,
    this.authDate,
    this.authDesc,
    this.altKey,
    this.reqTrnsTypeCode,
    this.reqTrnsSerial,
    this.outTrnsTypeCode,
    this.outTrnsSerial,
    this.authNameA,
    this.authNameE,
    this.statusFlag,
    this.statusNameA,
    this.statusNameE,
    this.links,
  });

  Items.fromJson(Map<String, dynamic> json) {
    projectId = json['ProjectId'];
    contractNo = json['ContractNo'];
    projectNameA = json['ProjectNameA'];
    projectNameE = json['ProjectNameE'];
    serial = json['Serial'];
    trnsDate = json['TrnsDate'];
    groupCode = json['GroupCode'];
    itemCode = json['ItemCode'];
    itemNameA = json['ItemNameA'];
    itemNameE = json['ItemNameE'];
    unitCode = json['UnitCode'];
    unitNameA = json['UnitNameA'];
    unitNameE = json['UnitNameE'];
    quantity = json['Quantity'];
    descA = json['DescA'];
    descE = json['DescE'];
    insertUser = json['InsertUser'];
    insertUserNameA = json['InsertUserNameA'];
    insertUserNameE = json['InsertUserNameE'];
    insertDate = json['InsertDate'];
    authFlag = json['AuthFlag'];
    authUser = json['AuthUser'];
    authUserNameA = json['AuthUserNameA'];
    authUserNameE = json['AuthUserNameE'];
    authDate = json['AuthDate'];
    authDesc = json['AuthDesc'];
    altKey = json['AltKey'];
    reqTrnsTypeCode = json['ReqTrnsTypeCode'];
    reqTrnsSerial = json['ReqTrnsSerial'];
    outTrnsTypeCode = json['OutTrnsTypeCode'];
    outTrnsSerial = json['OutTrnsSerial'];
    authNameA = json['AuthNameA'];
    authNameE = json['AuthNameE'];
    statusFlag = json['StatusFlag'];
    statusNameA = json['StatusNameA'];
    statusNameE = json['StatusNameE'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProjectId'] = this.projectId;
    data['ContractNo'] = this.contractNo;
    data['ProjectNameA'] = this.projectNameA;
    data['ProjectNameE'] = this.projectNameE;
    data['Serial'] = this.serial;
    data['TrnsDate'] = this.trnsDate;
    data['GroupCode'] = this.groupCode;
    data['ItemCode'] = this.itemCode;
    data['ItemNameA'] = this.itemNameA;
    data['ItemNameE'] = this.itemNameE;
    data['UnitCode'] = this.unitCode;
    data['UnitNameA'] = this.unitNameA;
    data['UnitNameE'] = this.unitNameE;
    data['Quantity'] = this.quantity;
    data['DescA'] = this.descA;
    data['DescE'] = this.descE;
    data['InsertUser'] = this.insertUser;
    data['InsertUserNameA'] = this.insertUserNameA;
    data['InsertUserNameE'] = this.insertUserNameE;
    data['InsertDate'] = this.insertDate;
    data['AuthFlag'] = this.authFlag;
    data['AuthUser'] = this.authUser;
    data['AuthUserNameA'] = this.authUserNameA;
    data['AuthUserNameE'] = this.authUserNameE;
    data['AuthDate'] = this.authDate;
    data['AuthDesc'] = this.authDesc;
    data['AltKey'] = this.altKey;
    data['ReqTrnsTypeCode'] = this.reqTrnsTypeCode;
    data['ReqTrnsSerial'] = this.reqTrnsSerial;
    data['OutTrnsTypeCode'] = this.outTrnsTypeCode;
    data['OutTrnsSerial'] = this.outTrnsSerial;
    data['AuthNameA'] = this.authNameA;
    data['AuthNameE'] = this.authNameE;
    data['StatusFlag'] = this.statusFlag;
    data['StatusNameA'] = this.statusNameA;
    data['StatusNameE'] = this.statusNameE;
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
