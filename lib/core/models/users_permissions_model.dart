class UsersPermissionsModel {
  List<Items>? items;
  int? count;
  bool? hasMore;
  int? limit;
  int? offset;
  List<Links>? links;

  UsersPermissionsModel({
    this.items,
    this.count,
    this.hasMore,
    this.limit,
    this.offset,
    this.links,
  });

  UsersPermissionsModel.fromJson(Map<String, dynamic> json) {
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
  int? usersCode;
  int? mobileManagerFlag;
  int? mobileMainFlag;
  int? mobileTenderFlag;
  int? mobileProjectFlag;
  int? mobilePermitFlag;
  List<Links>? links;

  Items({
    this.usersCode,
    this.mobileManagerFlag,
    this.mobileMainFlag,
    this.mobileTenderFlag,
    this.mobileProjectFlag,
    this.mobilePermitFlag,
    this.links,
  });

  Items.fromJson(Map<String, dynamic> json) {
    usersCode = json['UsersCode'];
    mobileManagerFlag = json['MobileManagerFlag'];
    mobileMainFlag = json['MobileMainFlag'];
    mobileTenderFlag = json['MobileTenderFlag'];
    mobileProjectFlag = json['MobileProjectFlag'];
    mobilePermitFlag = json['MobilePermitFlag'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UsersCode'] = this.usersCode;
    data['MobileManagerFlag'] = this.mobileManagerFlag;
    data['MobileMainFlag'] = this.mobileMainFlag;
    data['MobileTenderFlag'] = this.mobileTenderFlag;
    data['MobileProjectFlag'] = this.mobileProjectFlag;
    data['MobilePermitFlag'] = this.mobilePermitFlag;
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
