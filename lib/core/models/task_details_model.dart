class TaskDetailsModel {
  List<Items>? items;
  int? count;
  bool? hasMore;
  int? limit;
  int? offset;
  List<Links>? links;

  TaskDetailsModel({
    this.items,
    this.count,
    this.hasMore,
    this.limit,
    this.offset,
    this.links,
  });

  TaskDetailsModel.fromJson(Map<String, dynamic> json) {
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
  int? flowId;
  int? procId;
  String? altKey;
  int? attFlagCheck;
  int? attPermitCheck;
  int? attNotifCheck;
  int? AttBandCheck;
  List<Links>? links;

  Items({
    this.projectId,
    this.partId,
    this.flowId,
    this.procId,
    this.altKey,
    this.attFlagCheck,
    this.attPermitCheck,
    this.attNotifCheck,
    this.AttBandCheck,
    this.links,
  });

  Items.fromJson(Map<String, dynamic> json) {
    projectId = json['ProjectId'];
    partId = json['PartId'];
    flowId = json['FlowId'];
    procId = json['ProcId'];
    altKey = json['AltKey'];
    attFlagCheck = json['AttFlagCheck'];
    attPermitCheck = json['AttPermitCheck'];
    attNotifCheck = json['AttNotifCheck'];
    AttBandCheck = json['AttBandCheck'];
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
    data['FlowId'] = this.flowId;
    data['ProcId'] = this.procId;
    data['AltKey'] = this.altKey;
    data['AttFlagCheck'] = this.attFlagCheck;
    data['AttPermitCheck'] = this.attPermitCheck;
    data['AttNotifCheck'] = this.attNotifCheck;
    data['AttBandCheck'] = this.AttBandCheck;
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
