/// A model class representing a movie or TV show genre.
///
/// Contains the unique identifier and display name for a genre
/// as provided by The Movie Database (TMDB) API.
class Genre {
  /// The unique identifier for this genre.
  final int id;

  /// The display name of this genre.
  final String name;

  /// Creates a new genre with the specified ID and name.
  ///
  /// [id] The unique identifier for the genre.
  /// [name] The display name of the genre.
  const Genre({required this.id, required this.name});

  /// Creates a [Genre] instance from a JSON map.
  ///
  /// [json] A map containing 'id' and 'name' keys with their respective values.
  ///
  /// Returns a new [Genre] instance with the parsed values.
  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(id: json['id'] as int, name: json['name'] as String);
  }

  /// Converts this [Genre] instance to a JSON map.
  ///
  /// Returns a map containing 'id' and 'name' keys with their respective values.
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
