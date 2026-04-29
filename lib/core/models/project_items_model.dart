class ProjectItemsModel {
  List<Items>? items;
  int? count;
  bool? hasMore;
  int? limit;
  int? offset;
  List<Links>? links;

  ProjectItemsModel({
    this.items,
    this.count,
    this.hasMore,
    this.limit,
    this.offset,
    this.links,
  });

  ProjectItemsModel.fromJson(Map<String, dynamic> json) {
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
  int? itemGroupCode;
  String? itemCode;
  String? itemName;
  String? itemNameE;
  int? unitCode;
  String? unitNameA;
  String? unitNameE;
  double? bandBal;
  String? altKey;
  List<Links>? links;

  Items({
    this.projectId,
    this.itemGroupCode,
    this.itemCode,
    this.itemName,
    this.itemNameE,
    this.unitCode,
    this.unitNameA,
    this.unitNameE,
    this.bandBal,
    this.altKey,
    this.links,
  });

  Items.fromJson(Map<String, dynamic> json) {
    projectId = json['ProjectId'];
    itemGroupCode = json['ItemGroupCode'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    itemNameE = json['ItemNameE'];
    unitCode = json['UnitCode'];
    unitNameA = json['UnitNameA'];
    unitNameE = json['UnitNameE'];
    bandBal = json['BandBal'];
    altKey = json['AltKey'];
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
    data['ItemGroupCode'] = this.itemGroupCode;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['ItemNameE'] = this.itemNameE;
    data['UnitCode'] = this.unitCode;
    data['UnitNameA'] = this.unitNameA;
    data['UnitNameE'] = this.unitNameE;
    data['BandBal'] = this.bandBal;
    data['AltKey'] = this.altKey;
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
