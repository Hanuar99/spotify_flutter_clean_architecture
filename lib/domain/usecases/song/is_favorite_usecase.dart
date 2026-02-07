import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/repository/song/song_repository.dart';

class IsFavoriteUsecase implements UseCase<bool, String> {
  final SongRepository songRepository;

  IsFavoriteUsecase(this.songRepository);
  @override
  Future<bool> call(String params) async {
    return songRepository.isFavoriteSong(params);
  }
}
