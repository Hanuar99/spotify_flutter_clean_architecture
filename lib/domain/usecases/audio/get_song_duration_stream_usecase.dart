import 'package:spotify/domain/repository/audio/audio_player_repository.dart';

class GetSongDurationStreamUseCase {
  final AudioPlayerRepository repository;

  GetSongDurationStreamUseCase(this.repository);

  Stream<Duration?> call() => repository.durationStream;
}
