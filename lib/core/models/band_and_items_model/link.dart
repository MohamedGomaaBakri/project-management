class Link {
  final String? rel;
  final String? href;
  final String? name;
  final String? kind;

  Link({this.rel, this.href, this.name, this.kind});

  // هذه هي الدالة التي كانت تسبب الـ Crash
  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      rel: json['rel']?.toString(),
      href: json['href']?.toString(),
      name: json['name']?.toString(),
      kind: json['kind']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'rel': rel, 'href': href, 'name': name, 'kind': kind};
  }
}
