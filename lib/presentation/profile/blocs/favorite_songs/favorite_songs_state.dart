part of 'favorite_songs_cubit.dart';

abstract class FavoriteSongsState {}

final class FavoriteSongsLoading extends FavoriteSongsState {}

final class FavoriteSongsLoaded extends FavoriteSongsState {
  final List<SongEntity> favoriteSongs;
  FavoriteSongsLoaded({required this.favoriteSongs});
}

final class FavoriteSongsError extends FavoriteSongsState {}
