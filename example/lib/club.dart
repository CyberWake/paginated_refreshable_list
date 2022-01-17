class Club {
  const Club({
    required this.id,
    required this.name,
    this.logo,
  });
  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      id: json['id'] == null ? json['_id'] as String : json['id'] as String,
      name: json['name'] as String,
      logo: json['logo'] as String?,
    );
  }

  final String id;
  final String name;
  final String? logo;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['image'] = logo;
    return _data;
  }
}
