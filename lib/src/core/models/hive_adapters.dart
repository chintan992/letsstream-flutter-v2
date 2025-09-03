import 'package:hive/hive.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';

/// Hive adapter for Movie model
class MovieAdapter extends TypeAdapter<Movie> {
  @override
  final int typeId = 0;

  @override
  Movie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Movie(
      id: fields[0] as int,
      title: fields[1] as String,
      overview: fields[2] as String,
      popularity: fields[3] as double,
      posterPath: fields[4] as String?,
      backdropPath: fields[5] as String?,
      releaseDate: fields[6] as DateTime?,
      voteAverage: fields[7] as double,
      voteCount: fields[8] as int,
      genreIds: (fields[9] as List?)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Movie obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.overview)
      ..writeByte(3)
      ..write(obj.popularity)
      ..writeByte(4)
      ..write(obj.posterPath)
      ..writeByte(5)
      ..write(obj.backdropPath)
      ..writeByte(6)
      ..write(obj.releaseDate)
      ..writeByte(7)
      ..write(obj.voteAverage)
      ..writeByte(8)
      ..write(obj.voteCount)
      ..writeByte(9)
      ..write(obj.genreIds);
  }
}

/// Hive adapter for TvShow model
class TvShowAdapter extends TypeAdapter<TvShow> {
  @override
  final int typeId = 1;

  @override
  TvShow read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return TvShow(
      id: fields[0] as int,
      name: fields[1] as String,
      overview: fields[2] as String,
      popularity: fields[3] as double,
      posterPath: fields[4] as String?,
      backdropPath: fields[5] as String?,
      firstAirDate: fields[6] as DateTime?,
      voteAverage: fields[7] as double,
      voteCount: fields[8] as int,
      genreIds: (fields[9] as List?)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, TvShow obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.overview)
      ..writeByte(3)
      ..write(obj.popularity)
      ..writeByte(4)
      ..write(obj.posterPath)
      ..writeByte(5)
      ..write(obj.backdropPath)
      ..writeByte(6)
      ..write(obj.firstAirDate)
      ..writeByte(7)
      ..write(obj.voteAverage)
      ..writeByte(8)
      ..write(obj.voteCount)
      ..writeByte(9)
      ..write(obj.genreIds);
  }
}
