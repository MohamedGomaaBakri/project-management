class Link {
  String? rel;
  String? href;
  String? name;
  String? kind;

  Link({this.rel, this.href, this.name, this.kind});

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    rel: json['rel'] as String?,
    href: json['href'] as String?,
    name: json['name'] as String?,
    kind: json['kind'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'rel': rel,
    'href': href,
    'name': name,
    'kind': kind,
  };
}
