class SafeAndSecurityDetailsModel {
  List<Items>? items;
  int? count;
  bool? hasMore;
  int? limit;
  int? offset;
  List<Links>? links;

  SafeAndSecurityDetailsModel({
    this.items,
    this.count,
    this.hasMore,
    this.limit,
    this.offset,
    this.links,
  });

  SafeAndSecurityDetailsModel.fromJson(Map<String, dynamic> json) {
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
  int? partId;
  int? safeId;
  dynamic remarks;
  int? usersCode;
  int? doneFlag;
  String? doneDate;
  String? altKey;
  String? projectNameA;
  dynamic projectNameE;
  dynamic secNo;
  String? contractNo;
  String? safeNameA;
  dynamic safeNameE;
  String? doneStatusA;
  String? doneStatusE;
  List<Links>? links;

  Items({
    this.projectId,
    this.partId,
    this.safeId,
    this.remarks,
    this.usersCode,
    this.doneFlag,
    this.doneDate,
    this.altKey,
    this.projectNameA,
    this.projectNameE,
    this.secNo,
    this.contractNo,
    this.safeNameA,
    this.safeNameE,
    this.doneStatusA,
    this.doneStatusE,
    this.links,
  });

  Items.fromJson(Map<String, dynamic> json) {
    projectId = json['ProjectId'];
    partId = json['PartId'];
    safeId = json['SafeId'];
    remarks = json['Remarks'];
    usersCode = json['UsersCode'];
    doneFlag = json['DoneFlag'];
    doneDate = json['DoneDate'];
    altKey = json['AltKey'];
    projectNameA = json['ProjectNameA'];
    projectNameE = json['ProjectNameE'];
    secNo = json['SecNo'];
    contractNo = json['ContractNo'];
    safeNameA = json['SafeNameA'];
    safeNameE = json['SafeNameE'];
    doneStatusA = json['DoneStatusA'];
    doneStatusE = json['DoneStatusE'];
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
    data['PartId'] = this.partId;
    data['SafeId'] = this.safeId;
    data['Remarks'] = this.remarks;
    data['UsersCode'] = this.usersCode;
    data['DoneFlag'] = this.doneFlag;
    data['DoneDate'] = this.doneDate;
    data['AltKey'] = this.altKey;
    data['ProjectNameA'] = this.projectNameA;
    data['ProjectNameE'] = this.projectNameE;
    data['SecNo'] = this.secNo;
    data['ContractNo'] = this.contractNo;
    data['SafeNameA'] = this.safeNameA;
    data['SafeNameE'] = this.safeNameE;
    data['DoneStatusA'] = this.doneStatusA;
    data['DoneStatusE'] = this.doneStatusE;
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
