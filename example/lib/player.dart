class Player {
  const Player({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.isRegistered,
    required this.handicap,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['_id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      gender: json['gender'].toString().isNotEmpty
          ? json['gender'] as String
          : 'male',
      isRegistered: json['is_registered'] as bool,
      handicap: json['handicap_level'] as int,
    );
  }

  final String id;
  final String firstName;
  final String lastName;
  final String gender;
  final bool isRegistered;
  final int handicap;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['gender'] = gender;
    _data['is_registered'] = isRegistered;
    _data['handicap'] = handicap;
    return _data;
  }
}
