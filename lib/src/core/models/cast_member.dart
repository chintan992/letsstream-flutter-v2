/// Represents a cast or crew member associated with movies or TV shows.
///
/// This model contains information about individuals who worked on film or
/// television productions, including actors, directors, writers, and other
/// crew members. It's commonly used to display cast and crew information
/// in movie and TV show details.
///
/// ```dart
/// // Create a cast member from JSON data
/// final castMember = CastMember.fromJson({
///   'id': 819,
///   'name': 'Edward Norton',
///   'profile_path': '/path/to/profile.jpg',
///   'character': 'The Narrator'
/// });
/// ```
class CastMember {
  /// The unique identifier for the cast/crew member from TMDB.
  final int id;

  /// The full name of the cast or crew member.
  final String name;

  /// The file path to the person's profile/headshot image.
  ///
  /// This is a relative path that should be combined with TMDB's base URL
  /// to construct the full image URL. Can be null if no profile image
  /// is available.
  final String? profilePath;

  /// The name of the character portrayed by this person (for cast members).
  ///
  /// For actors, this represents the character they played in the movie
  /// or TV show. For crew members, this might represent their role or job title.
  /// Can be null if character information is not available.
  final String? character;

  /// Creates a new CastMember instance with the specified properties.
  ///
  /// All parameters are required as they represent essential information
  /// about the cast or crew member. This constructor is typically used
  /// when creating CastMember objects from data that has already been
  /// validated and processed.
  CastMember({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.character,
  });

  /// Creates a CastMember instance from a JSON map.
  ///
  /// This factory method handles the deserialization of cast/crew data from
  /// TMDB API responses. It provides sensible defaults for missing data
  /// and handles type conversion from dynamic JSON values.
  ///
  /// [json] A map containing cast/crew data from TMDB API.
  ///
  /// Returns a new CastMember instance with parsed and validated data.
  ///
  /// ```dart
  /// final jsonData = {
  ///   'id': 819,
  ///   'name': 'Edward Norton',
  ///   'profile_path': '/profile.jpg',
  ///   'character': 'The Narrator'
  /// };
  /// final castMember = CastMember.fromJson(jsonData);
  /// ```
  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      id: (json['id'] as num).toInt(),
      name: (json['name'] ?? '') as String,
      profilePath: json['profile_path'] as String?,
      character: json['character'] as String?,
    );
  }
}
