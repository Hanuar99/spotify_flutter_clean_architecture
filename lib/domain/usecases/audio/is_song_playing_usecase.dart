import 'package:spotify/domain/repository/audio/audio_player_repository.dart';

class IsSongPlayingUseCase {
  final AudioPlayerRepository repository;

  IsSongPlayingUseCase(this.repository);

  bool call() {
    return repository.isPlaying;
  }
}
