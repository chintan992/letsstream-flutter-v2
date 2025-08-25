class CastMember {
  final int id;
  final String name;
  final String? profilePath;
  final String? character;

  CastMember({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.character,
  });

  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      id: (json['id'] as num).toInt(),
      name: (json['name'] ?? '') as String,
      profilePath: json['profile_path'] as String?,
      character: json['character'] as String?,
    );
  }
}
