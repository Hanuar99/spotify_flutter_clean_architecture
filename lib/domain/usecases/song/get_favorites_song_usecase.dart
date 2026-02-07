import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/repository/song/song_repository.dart';

class GetFavoritesSongUseCase implements NoParamsUseCase<Either> {
  final SongRepository songRepository;

  GetFavoritesSongUseCase(this.songRepository);
  @override
  Future<Either> call() async {
    return songRepository.getUserFavoriteSongs();
  }
}
