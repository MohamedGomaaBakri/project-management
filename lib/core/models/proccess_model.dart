class ProccessModel {
  List<Items>? items;
  int? count;
  bool? hasMore;
  int? limit;
  int? offset;
  List<Links>? links;

  ProccessModel({
    this.items,
    this.count,
    this.hasMore,
    this.limit,
    this.offset,
    this.links,
  });

  ProccessModel.fromJson(Map<String, dynamic> json) {
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
  dynamic? partId;
  dynamic? flowId;
  dynamic? procId;
  dynamic? procOrder;
  dynamic? usersCode;
  dynamic? remarks;
  dynamic? doneFlag;
  dynamic? doneDate;
  dynamic? procPeriod;
  dynamic? procStartDate;
  dynamic? procEndDate;
  dynamic? stopFlag;
  dynamic? sendUsersCode;
  dynamic? managerRemarks;
  dynamic? projectsManagerFlag;
  dynamic? projectManagerFlag;
  dynamic? projectEngFlag;
  dynamic? projectUserFlag;
  dynamic? projectsManagerDoneFlag;
  dynamic? projectManagerDoneFlag;
  dynamic? projectEngDoneFlag;
  dynamic? projectUserDoneFlag;
  dynamic? projectsManagerCode;
  dynamic? projectManagerCode;
  dynamic? projectEngCode;
  dynamic? projectId;
  dynamic? altKey;
  dynamic? nextUsersCode;
  dynamic? nameA;
  dynamic? projectId1;
  dynamic? nameE;
  dynamic? secNo;
  dynamic? contractNo;
  dynamic? procNameA;
  dynamic? procNameE;
  dynamic? nextUsersCodeAct;
  dynamic? ProcPeriod;
  dynamic? ProcStartDate;
  dynamic? ProcEndDate;
  dynamic? NextProcNameA;
  dynamic? NextProcNameE;
  dynamic? ProcQty;
  List<Links>? links;

  Items({
    this.partId,
    this.flowId,
    this.procId,
    this.procOrder,
    this.usersCode,
    this.remarks,
    this.doneFlag,
    this.doneDate,
    this.procPeriod,
    this.procStartDate,
    this.procEndDate,
    this.stopFlag,
    this.sendUsersCode,
    this.managerRemarks,
    this.projectsManagerFlag,
    this.projectManagerFlag,
    this.projectEngFlag,
    this.projectUserFlag,
    this.projectsManagerDoneFlag,
    this.projectManagerDoneFlag,
    this.projectEngDoneFlag,
    this.projectUserDoneFlag,
    this.projectsManagerCode,
    this.projectManagerCode,
    this.projectEngCode,
    this.projectId,
    this.altKey,
    this.nextUsersCode,
    this.nameA,
    this.projectId1,
    this.nameE,
    this.secNo,
    this.contractNo,
    this.procNameA,
    this.procNameE,
    this.nextUsersCodeAct,
    this.ProcPeriod,
    this.ProcStartDate,
    this.ProcEndDate,
    this.NextProcNameA,
    this.NextProcNameE,
    this.ProcQty,
    this.links,
  });

  Items.fromJson(Map<String, dynamic> json) {
    partId = json['PartId'];
    flowId = json['FlowId'];
    procId = json['ProcId'];
    procOrder = json['ProcOrder'];
    usersCode = json['UsersCode'];
    remarks = json['Remarks'];
    doneFlag = json['DoneFlag'];
    doneDate = json['DoneDate'];
    procPeriod = json['ProcPeriod'];
    procStartDate = json['ProcStartDate'];
    procEndDate = json['ProcEndDate'];
    stopFlag = json['StopFlag'];
    sendUsersCode = json['SendUsersCode'];
    managerRemarks = json['ManagerRemarks'];
    projectsManagerFlag = json['ProjectsManagerFlag'];
    projectManagerFlag = json['ProjectManagerFlag'];
    projectEngFlag = json['ProjectEngFlag'];
    projectUserFlag = json['ProjectUserFlag'];
    projectsManagerDoneFlag = json['ProjectsManagerDoneFlag'];
    projectManagerDoneFlag = json['ProjectManagerDoneFlag'];
    projectEngDoneFlag = json['ProjectEngDoneFlag'];
    projectUserDoneFlag = json['ProjectUserDoneFlag'];
    projectsManagerCode = json['ProjectsManagerCode'];
    projectManagerCode = json['ProjectManagerCode'];
    projectEngCode = json['ProjectEngCode'];
    projectId = json['ProjectId'];
    altKey = json['AltKey'];
    nextUsersCode = json['NextUsersCode'];
    nameA = json['NameA'];
    projectId1 = json['ProjectId1'];
    nameE = json['NameE'];
    secNo = json['SecNo'];
    contractNo = json['ContractNo'];
    procNameA = json['ProcNameA'];
    procNameE = json['ProcNameE'];
    nextUsersCodeAct = json['NextUsersCodeAct'];
    ProcPeriod = json['ProcPeriod'];
    ProcStartDate = json['ProcStartDate'];
    ProcEndDate = json['ProcEndDate'];
    NextProcNameA = json['NextProcNameA'];
    NextProcNameE = json['NextProcNameE'];
    ProcQty = json['ProcQty'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PartId'] = this.partId;
    data['FlowId'] = this.flowId;
    data['ProcId'] = this.procId;
    data['ProcOrder'] = this.procOrder;
    data['UsersCode'] = this.usersCode;
    data['Remarks'] = this.remarks;
    data['DoneFlag'] = this.doneFlag;
    data['DoneDate'] = this.doneDate;
    data['ProcPeriod'] = this.procPeriod;
    data['ProcStartDate'] = this.procStartDate;
    data['ProcEndDate'] = this.procEndDate;
    data['StopFlag'] = this.stopFlag;
    data['SendUsersCode'] = this.sendUsersCode;
    data['ManagerRemarks'] = this.managerRemarks;
    data['ProjectsManagerFlag'] = this.projectsManagerFlag;
    data['ProjectManagerFlag'] = this.projectManagerFlag;
    data['ProjectEngFlag'] = this.projectEngFlag;
    data['ProjectUserFlag'] = this.projectUserFlag;
    data['ProjectsManagerDoneFlag'] = this.projectsManagerDoneFlag;
    data['ProjectManagerDoneFlag'] = this.projectManagerDoneFlag;
    data['ProjectEngDoneFlag'] = this.projectEngDoneFlag;
    data['ProjectUserDoneFlag'] = this.projectUserDoneFlag;
    data['ProjectsManagerCode'] = this.projectsManagerCode;
    data['ProjectManagerCode'] = this.projectManagerCode;
    data['ProjectEngCode'] = this.projectEngCode;
    data['ProjectId'] = this.projectId;
    data['AltKey'] = this.altKey;
    data['NextUsersCode'] = this.nextUsersCode;
    data['NameA'] = this.nameA;
    data['ProjectId1'] = this.projectId1;
    data['NameE'] = this.nameE;
    data['SecNo'] = this.secNo;
    data['ContractNo'] = this.contractNo;
    data['ProcNameA'] = this.procNameA;
    data['ProcNameE'] = this.procNameE;
    data['NextUsersCodeAct'] = this.nextUsersCodeAct;
    data['ProcPeriod'] = this.ProcPeriod;
    data['ProcStartDate'] = this.ProcStartDate;
    data['ProcEndDate'] = this.ProcEndDate;
    data['NextProcNameA'] = this.NextProcNameA;
    data['NextProcNameE'] = this.NextProcNameE;
    data['ProcQty'] = this.ProcQty;
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
