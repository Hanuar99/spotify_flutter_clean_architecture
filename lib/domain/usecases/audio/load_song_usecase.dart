import 'package:dartz/dartz.dart';
import 'package:spotify/core/failure/failure.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/repository/audio/audio_player_repository.dart';

class LoadSongUseCase implements UseCase<Either<Failure, void>, String> {
  final AudioPlayerRepository repository;

  LoadSongUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.load(params);
  }
}
