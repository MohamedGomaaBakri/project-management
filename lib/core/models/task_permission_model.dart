class PermissionModel {
  List<Permission>? items;
  int? count;
  bool? hasMore;
  int? limit;
  int? offset;
  List<Links>? links;

  PermissionModel({
    this.items,
    this.count,
    this.hasMore,
    this.limit,
    this.offset,
    this.links,
  });

  PermissionModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Permission>[];
      json['items'].forEach((v) {
        items!.add(new Permission.fromJson(v));
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

class Permission {
  int? projectId;
  int? permitSerial;
  int? permitType;
  String? permitNo;
  int? permitCopy;
  String? startDate;
  String? endDate;
  int? totalLength;
  int? insertUser;
  String? insertDate;
  int? updateUser;
  String? updateDate;
  dynamic note;
  int? doneFlag;
  String? drillingMethod;
  String? streets;
  dynamic orgPermitSerial;
  int? renewFlag;
  dynamic totalWidth;
  int? permitLoc;
  dynamic doneDate;
  String? altKey;
  String? typeNameA;
  int? code;
  dynamic typeNameE;
  String? locNameA;
  int? code1;
  String? locNameE;
  dynamic permitValue;
  String? projectNameA;
  int? projectId1;
  dynamic projectNameE;
  String? contractNo;
  int? codeStatus;
  String? statusNameA;
  String? statusNameE;
  List<Links>? links;

  Permission({
    this.projectId,
    this.permitSerial,
    this.permitType,
    this.permitNo,
    this.permitCopy,
    this.startDate,
    this.endDate,
    this.totalLength,
    this.insertUser,
    this.insertDate,
    this.updateUser,
    this.updateDate,
    this.note,
    this.doneFlag,
    this.drillingMethod,
    this.streets,
    this.orgPermitSerial,
    this.renewFlag,
    this.totalWidth,
    this.permitLoc,
    this.doneDate,
    this.altKey,
    this.typeNameA,
    this.code,
    this.typeNameE,
    this.locNameA,
    this.code1,
    this.locNameE,
    this.permitValue,
    this.projectNameA,
    this.projectId1,
    this.projectNameE,
    this.contractNo,
    this.codeStatus,
    this.statusNameA,
    this.statusNameE,
    this.links,
  });

  Permission.fromJson(Map<String, dynamic> json) {
    projectId = json['ProjectId'];
    permitSerial = json['PermitSerial'];
    permitType = json['PermitType'];
    permitNo = json['PermitNo'];
    permitCopy = json['PermitCopy'];
    startDate = json['StartDate'];
    endDate = json['EndDate'];
    totalLength = json['TotalLength'];
    insertUser = json['InsertUser'];
    insertDate = json['InsertDate'];
    updateUser = json['UpdateUser'];
    updateDate = json['UpdateDate'];
    note = json['Note'];
    doneFlag = json['DoneFlag'];
    drillingMethod = json['DrillingMethod'];
    streets = json['Streets'];
    orgPermitSerial = json['OrgPermitSerial'];
    renewFlag = json['RenewFlag'];
    totalWidth = json['TotalWidth'];
    permitLoc = json['PermitLoc'];
    doneDate = json['DoneDate'];
    altKey = json['AltKey'];
    typeNameA = json['TypeNameA'];
    code = json['Code'];
    typeNameE = json['TypeNameE'];
    locNameA = json['LocNameA'];
    code1 = json['Code1'];
    locNameE = json['LocNameE'];
    permitValue = json['PermitValue'];
    projectNameA = json['ProjectNameA'];
    projectId1 = json['ProjectId1'];
    projectNameE = json['ProjectNameE'];
    contractNo = json['ContractNo'];
    codeStatus = json['CodeStatus'];
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
    data['PermitSerial'] = this.permitSerial;
    data['PermitType'] = this.permitType;
    data['PermitNo'] = this.permitNo;
    data['PermitCopy'] = this.permitCopy;
    data['StartDate'] = this.startDate;
    data['EndDate'] = this.endDate;
    data['TotalLength'] = this.totalLength;
    data['InsertUser'] = this.insertUser;
    data['InsertDate'] = this.insertDate;
    data['UpdateUser'] = this.updateUser;
    data['UpdateDate'] = this.updateDate;
    data['Note'] = this.note;
    data['DoneFlag'] = this.doneFlag;
    data['DrillingMethod'] = this.drillingMethod;
    data['Streets'] = this.streets;
    data['OrgPermitSerial'] = this.orgPermitSerial;
    data['RenewFlag'] = this.renewFlag;
    data['TotalWidth'] = this.totalWidth;
    data['PermitLoc'] = this.permitLoc;
    data['DoneDate'] = this.doneDate;
    data['AltKey'] = this.altKey;
    data['TypeNameA'] = this.typeNameA;
    data['Code'] = this.code;
    data['TypeNameE'] = this.typeNameE;
    data['LocNameA'] = this.locNameA;
    data['Code1'] = this.code1;
    data['LocNameE'] = this.locNameE;
    data['PermitValue'] = this.permitValue;
    data['ProjectNameA'] = this.projectNameA;
    data['ProjectId1'] = this.projectId1;
    data['ProjectNameE'] = this.projectNameE;
    data['ContractNo'] = this.contractNo;
    data['CodeStatus'] = this.codeStatus;
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
