import 'package:dartz/dartz.dart';
import 'package:spotify/core/failure/failure.dart';
import 'package:spotify/data/sources/audio/audio_player_datasource.dart';
import 'package:spotify/domain/repository/audio/audio_player_repository.dart';

class AudioPlayerRepositoryImpl implements AudioPlayerRepository {
  final AudioPlayerDataSource dataSource;

  AudioPlayerRepositoryImpl(this.dataSource);

  @override
  Stream<Duration> get positionStream => dataSource.positionStream;

  @override
  Stream<Duration?> get durationStream => dataSource.durationStream;

  @override
  Future<Either<Failure, void>> load(String url) async {
    try {
      await dataSource.setUrl(url);
      return const Right(null);
    } catch (e) {
      return Left(AudioFailure('Error loading audio'));
    }
  }

  @override
  Future<Either<Failure, void>> play() async {
    try {
      await dataSource.play();
      return const Right(null);
    } catch (_) {
      return Left(AudioFailure('Error playing audio'));
    }
  }

  @override
  Future<Either<Failure, void>> pause() async {
    try {
      await dataSource.pause();
      return const Right(null);
    } catch (_) {
      return Left(AudioFailure('Error pausing audio'));
    }
  }

  @override
  bool get isPlaying => dataSource.isPlaying;

  @override
  Future<void> dispose() => dataSource.dispose();
}
