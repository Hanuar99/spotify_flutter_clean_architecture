import 'package:spotify/domain/repository/audio/audio_player_repository.dart';

class GetSongPositionStreamUseCase {
  final AudioPlayerRepository repository;

  GetSongPositionStreamUseCase(this.repository);

  Stream<Duration> call() => repository.positionStream;
}
