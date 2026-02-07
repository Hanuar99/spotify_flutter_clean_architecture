import 'package:just_audio/just_audio.dart';

abstract class AudioPlayerDataSource {
  Stream<Duration> get positionStream;
  Stream<Duration?> get durationStream;

  Future<void> setUrl(String url);
  Future<void> play();
  Future<void> pause();
  bool get isPlaying;
  Future<void> dispose();
}

class AudioPlayerDataSourceImpl implements AudioPlayerDataSource {
  final AudioPlayer _player;

  AudioPlayerDataSourceImpl(this._player);

  @override
  Stream<Duration> get positionStream => _player.positionStream;

  @override
  Stream<Duration?> get durationStream => _player.durationStream;

  @override
  Future<void> setUrl(String url) => _player.setUrl(url);

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  bool get isPlaying => _player.playing;

  @override
  Future<void> dispose() => _player.dispose();
}
