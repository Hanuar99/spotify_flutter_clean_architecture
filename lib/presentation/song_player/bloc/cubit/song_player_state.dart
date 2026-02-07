part of 'song_player_cubit.dart';

abstract class SongPlayerState {}

class SongPlayerLoading extends SongPlayerState {}

class SongPlayerLoaded extends SongPlayerState {
  final Duration position;
  final Duration duration;
  final bool isPlaying;

  SongPlayerLoaded({
    required this.position,
    required this.duration,
    required this.isPlaying,
  });
}

class SongPlayerError extends SongPlayerState {
  SongPlayerError();
}
