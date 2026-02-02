class UsersModel {
  List<Items>? items;
  int? count;
  bool? hasMore;
  int? limit;
  int? offset;
  List<Links>? links;

  UsersModel({
    this.items,
    this.count,
    this.hasMore,
    this.limit,
    this.offset,
    this.links,
  });

  UsersModel.fromJson(Map<String, dynamic> json) {
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
  String? usersName;
  String? usersNameE;
  List<Links>? links;

  Items({this.usersCode, this.usersName, this.usersNameE, this.links});

  Items.fromJson(Map<String, dynamic> json) {
    usersCode = json['UsersCode'];
    usersName = json['UsersName'];
    usersNameE = json['UsersNameE'];
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
    data['UsersName'] = this.usersName;
    data['UsersNameE'] = this.usersNameE;
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
