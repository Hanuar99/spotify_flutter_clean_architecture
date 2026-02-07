import 'package:spotify/domain/entities/song/song_entity.dart';

class SongModel extends SongEntity {
  SongModel({
    required super.title,
    required super.artist,
    required super.duration,
    required super.release,
    required super.coverUrl,
    required super.audioUrl,
    required super.isFavorite,
    required super.songId,
  });

  factory SongModel.fromJson(
    Map<String, dynamic> json, {
    required bool isFavorite,
    required String songId,
  }) {
    return SongModel(
      title: json['title'],
      artist: json['artist'],
      duration: json['duration'],
      release: json['release'],
      coverUrl: json['coverUrl'],
      audioUrl: json['audioUrl'],
      isFavorite: isFavorite,
      songId: songId,
    );
  }
}
