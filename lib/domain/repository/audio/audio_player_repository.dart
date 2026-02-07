import 'package:dartz/dartz.dart';
import 'package:spotify/core/failure/failure.dart';

abstract class AudioPlayerRepository {
  Stream<Duration> get positionStream;
  Stream<Duration?> get durationStream;

  Future<Either<Failure, void>> load(String url);
  Future<Either<Failure, void>> play();
  Future<Either<Failure, void>> pause();
  bool get isPlaying;
  Future<void> dispose();
}
