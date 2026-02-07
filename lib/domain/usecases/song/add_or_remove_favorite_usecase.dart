import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/repository/song/song_repository.dart';

class AddOrRemoveFavoriteUsecase implements UseCase<Either, String> {
  final SongRepository songRepository;

  AddOrRemoveFavoriteUsecase(this.songRepository);
  @override
  Future<Either> call(String params) async {
    return songRepository.addOrRemoveFavoriteSong(params);
  }
}
