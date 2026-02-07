import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/usecases/audio/get_song_duration_stream_usecase.dart';
import 'package:spotify/domain/usecases/audio/get_song_position_stream_usecase.dart';
import 'package:spotify/domain/usecases/audio/is_song_playing_usecase.dart';
import 'package:spotify/domain/usecases/audio/load_song_usecase.dart';
import 'package:spotify/domain/usecases/audio/play_or_pause_song_usecase.dart';

part 'song_player_state.dart';

class SongPlayerCubit extends Cubit<SongPlayerState> {
  final LoadSongUseCase loadSongUseCase;
  final PlayOrPauseSongUseCase playOrPauseSongUseCase;
  final IsSongPlayingUseCase isSongPlayingUseCase;
  final GetSongPositionStreamUseCase positionStreamUseCase;
  final GetSongDurationStreamUseCase durationStreamUseCase;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  late final StreamSubscription _positionSub;
  late final StreamSubscription _durationSub;

  SongPlayerCubit({
    required this.loadSongUseCase,
    required this.playOrPauseSongUseCase,
    required this.isSongPlayingUseCase,
    required this.positionStreamUseCase,
    required this.durationStreamUseCase,
  }) : super(SongPlayerLoading()) {
    _listenStreams();
  }

  void _listenStreams() {
    _positionSub = positionStreamUseCase().listen((position) {
      _position = position;
      _emitLoaded();
    });

    _durationSub = durationStreamUseCase().listen((duration) {
      if (duration != null) {
        _duration = duration;
        _emitLoaded();
      }
    });
  }

  Future<void> loadSong(String url) async {
    try {
      await loadSongUseCase(url);
      _emitLoaded();
    } catch (_) {
      emit(SongPlayerError());
    }
  }

  Future<void> playOrPause() async {
    await playOrPauseSongUseCase();
    _emitLoaded();
  }

  void _emitLoaded() {
    emit(
      SongPlayerLoaded(
        position: _position,
        duration: _duration,
        isPlaying: isSongPlayingUseCase(),
      ),
    );
  }

  @override
  Future<void> close() {
    _positionSub.cancel();
    _durationSub.cancel();
    return super.close();
  }
}
