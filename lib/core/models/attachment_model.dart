class AttatchmentModel {
  List<Items>? items;
  int? count;
  bool? hasMore;
  int? limit;
  int? offset;
  List<Links>? links;

  AttatchmentModel({
    this.items,
    this.count,
    this.hasMore,
    this.limit,
    this.offset,
    this.links,
  });

  AttatchmentModel.fromJson(Map<String, dynamic> json) {
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
  String? tblNm;
  String? pk1;
  String? pk2;
  dynamic pk3;
  dynamic pk4;
  dynamic pk5;
  dynamic pk6;
  dynamic pk7;
  dynamic pk8;
  dynamic pk9;
  dynamic entryYear;
  dynamic entryType;
  dynamic entryNo;
  String? fileDesc;
  int? docSerial;
  String? docPath;
  dynamic docFlag;
  dynamic valideFDate;
  dynamic valideTDate;
  int? docType;
  dynamic docNo;
  String? altKey;
  List<Links>? links;

  Items({
    this.tblNm,
    this.pk1,
    this.pk2,
    this.pk3,
    this.pk4,
    this.pk5,
    this.pk6,
    this.pk7,
    this.pk8,
    this.pk9,
    this.entryYear,
    this.entryType,
    this.entryNo,
    this.fileDesc,
    this.docSerial,
    this.docPath,
    this.docFlag,
    this.valideFDate,
    this.valideTDate,
    this.docType,
    this.docNo,
    this.altKey,
    this.links,
  });

  Items.fromJson(Map<String, dynamic> json) {
    tblNm = json['TblNm'];
    pk1 = json['Pk1'];
    pk2 = json['Pk2'];
    pk3 = json['Pk3'];
    pk4 = json['Pk4'];
    pk5 = json['Pk5'];
    pk6 = json['Pk6'];
    pk7 = json['Pk7'];
    pk8 = json['Pk8'];
    pk9 = json['Pk9'];
    entryYear = json['EntryYear'];
    entryType = json['EntryType'];
    entryNo = json['EntryNo'];
    fileDesc = json['FileDesc'];
    docSerial = json['DocSerial'];
    docPath = json['DocPath'];
    docFlag = json['DocFlag'];
    valideFDate = json['ValideFDate'];
    valideTDate = json['ValideTDate'];
    docType = json['DocType'];
    docNo = json['DocNo'];
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
    data['TblNm'] = this.tblNm;
    data['Pk1'] = this.pk1;
    data['Pk2'] = this.pk2;
    data['Pk3'] = this.pk3;
    data['Pk4'] = this.pk4;
    data['Pk5'] = this.pk5;
    data['Pk6'] = this.pk6;
    data['Pk7'] = this.pk7;
    data['Pk8'] = this.pk8;
    data['Pk9'] = this.pk9;
    data['EntryYear'] = this.entryYear;
    data['EntryType'] = this.entryType;
    data['EntryNo'] = this.entryNo;
    data['FileDesc'] = this.fileDesc;
    data['DocSerial'] = this.docSerial;
    data['DocPath'] = this.docPath;
    data['DocFlag'] = this.docFlag;
    data['ValideFDate'] = this.valideFDate;
    data['ValideTDate'] = this.valideTDate;
    data['DocType'] = this.docType;
    data['DocNo'] = this.docNo;
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
