class MaterialProjectsModel {
  List<Items>? items;
  int? count;
  bool? hasMore;
  int? limit;
  int? offset;
  List<Links>? links;

  MaterialProjectsModel({
    this.items,
    this.count,
    this.hasMore,
    this.limit,
    this.offset,
    this.links,
  });

  MaterialProjectsModel.fromJson(Map<String, dynamic> json) {
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
  String? nameA;
  String? nameE;
  String? contractNo;
  String? woNo;
  String? secNo;
  List<Links>? links;

  Items({
    this.projectId,
    this.nameA,
    this.nameE,
    this.contractNo,
    this.woNo,
    this.secNo,
    this.links,
  });

  Items.fromJson(Map<String, dynamic> json) {
    projectId = json['ProjectId'];
    nameA = json['NameA'];
    nameE = json['NameE'];
    contractNo = json['ContractNo'];
    woNo = json['WoNo'];
    secNo = json['SecNo'];
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
    data['NameA'] = this.nameA;
    data['NameE'] = this.nameE;
    data['ContractNo'] = this.contractNo;
    data['WoNo'] = this.woNo;
    data['SecNo'] = this.secNo;
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
