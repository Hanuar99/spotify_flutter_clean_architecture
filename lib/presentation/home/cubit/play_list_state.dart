part of 'play_list_cubit.dart';

@immutable
sealed class PlayListState {}

final class PlayListLoading extends PlayListState {}

final class PlayListLoaded extends PlayListState {
  final List<SongEntity> playList;
  PlayListLoaded({required this.playList});
}

final class PlayListError extends PlayListState {
  final String message;
  PlayListError({required this.message});
}
