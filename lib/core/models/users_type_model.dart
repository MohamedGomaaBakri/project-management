class UsersTypeModel {
  List<Items>? items;
  int? count;
  bool? hasMore;
  int? limit;
  int? offset;
  List<Links>? links;

  UsersTypeModel({
    this.items,
    this.count,
    this.hasMore,
    this.limit,
    this.offset,
    this.links,
  });

  UsersTypeModel.fromJson(Map<String, dynamic> json) {
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
  int? projectId;
  int? code;
  String? nameA;
  String? nameE;
  int? managerCode;
  String? usersName;
  String? usersNameE;
  List<Links>? links;

  Items({
    this.usersCode,
    this.projectId,
    this.code,
    this.nameA,
    this.nameE,
    this.managerCode,
    this.usersName,
    this.usersNameE,
    this.links,
  });

  Items.fromJson(Map<String, dynamic> json) {
    usersCode = json['UsersCode'];
    projectId = json['ProjectId'];
    code = json['Code'];
    nameA = json['NameA'];
    nameE = json['NameE'];
    managerCode = json['ManagerCode'];
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
    data['ProjectId'] = this.projectId;
    data['Code'] = this.code;
    data['NameA'] = this.nameA;
    data['NameE'] = this.nameE;
    data['ManagerCode'] = this.managerCode;
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
