part of 'news_songs_cubit.dart';

sealed class NewsSongsState {}

final class NewsSongsLoading extends NewsSongsState {}

final class NewsSongsLoaded extends NewsSongsState {
  final List<SongEntity> newsSongs;
  NewsSongsLoaded({required this.newsSongs});
}

final class NewsSongsError extends NewsSongsState {
  final String message;
  NewsSongsError({required this.message});
}
