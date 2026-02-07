import 'package:dartz/dartz.dart';
import 'package:spotify/core/failure/failure.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/repository/audio/audio_player_repository.dart';

class PlayOrPauseSongUseCase implements NoParamsUseCase<Either<Failure, void>> {
  final AudioPlayerRepository repository;

  PlayOrPauseSongUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call() {
    return repository.isPlaying ? repository.pause() : repository.play();
  }
}
