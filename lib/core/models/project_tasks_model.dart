class ProjectTasksModel {
  List<Items>? items;
  int? count;
  bool? hasMore;
  int? limit;
  int? offset;
  List<Links>? links;

  ProjectTasksModel({
    this.items,
    this.count,
    this.hasMore,
    this.limit,
    this.offset,
    this.links,
  });

  ProjectTasksModel.fromJson(Map<String, dynamic> json) {
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
  int? partId;
  int? flowId;
  int? procId;
  int? procOrder;
  int? usersCode;
  String? remarks;
  int? doneFlag;
  String? doneDate;
  String? procPeriod;
  String? procStartDate;
  String? procEndDate;
  int? stopFlag;
  String? sendUsersCode;
  String? managerRemarks;
  int? projectsManagerFlag;
  int? projectManagerFlag;
  int? projectEngFlag;
  int? projectUserFlag;
  int? projectsManagerDoneFlag;
  int? projectManagerDoneFlag;
  int? projectEngDoneFlag;
  int? projectUserDoneFlag;
  String? projectsManagerCode;
  String? projectManagerCode;
  String? projectEngCode;
  String? NextUsersCode;
  String? NextUsersCodeAct;
  String? NameA;
  String? NameE;
  int? projectId;
  String? altKey;
  String? contractNo;
  String? secNo;
  String? procNameA;
  String? procNameE;
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
    this.NextUsersCode,
    this.NextUsersCodeAct,
    this.NameA,
    this.NameE,
    this.contractNo,
    this.secNo,
    this.procNameA,
    this.procNameE,
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
    NextUsersCode = json['NextUsersCode'];
    NextUsersCodeAct = json['NextUsersCodeAct'];
    NameA = json['NameA'];
    NameE = json['NameE'];
    altKey = json['AltKey'];
    contractNo = json['ContractNo'];
    secNo = json['SecNo'];
    procNameA = json['ProcNameA'];
    procNameE = json['ProcNameE'];
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
    data['NextUsersCode'] = this.NextUsersCode;
    data['NextUsersCodeAct'] = this.NextUsersCodeAct;
    data['NameA'] = this.NameA;
    data['NameE'] = this.NameE;
    data['ContractNo'] = this.contractNo;
    data['SecNo'] = this.secNo;
    data['ProcNameA'] = this.procNameA;
    data['ProcNameE'] = this.procNameE;
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
