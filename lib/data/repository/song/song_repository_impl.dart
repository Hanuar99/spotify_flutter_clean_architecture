import 'package:dartz/dartz.dart';
import 'package:spotify/data/sources/song/song_firebase_service.dart';
import 'package:spotify/domain/repository/song/song_repository.dart';

class SongRepositoryImpl extends SongRepository {
  final SongFirebaseService songFirebaseService;

  SongRepositoryImpl({required this.songFirebaseService});
  @override
  Future<Either> getNewsSongs() async {
    return await songFirebaseService.getNewsSongs();
  }

  @override
  Future<Either> getPlayList() async {
    return await songFirebaseService.getPlayList();
  }

  @override
  Future<Either> addOrRemoveFavoriteSong(String songId) async {
    return await songFirebaseService.addOrRemoveFavoriteSong(songId);
  }

  @override
  Future<bool> isFavoriteSong(String songId) async {
    return await songFirebaseService.isFavoriteSong(songId);
  }

  @override
  Future<Either> getUserFavoriteSongs() async {
    return await songFirebaseService.getUserFavoriteSongs();
  }
}
