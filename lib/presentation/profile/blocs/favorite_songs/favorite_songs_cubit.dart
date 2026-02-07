import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/entities/song/song_entity.dart';
import 'package:spotify/domain/usecases/song/get_favorites_song_usecase.dart';

part 'favorite_songs_state.dart';

class FavoriteSongsCubit extends Cubit<FavoriteSongsState> {
  final GetFavoritesSongUseCase getFavoritesSongUseCase;
  FavoriteSongsCubit(this.getFavoritesSongUseCase)
      : super(FavoriteSongsLoading());

  List<SongEntity> favoriteSongs = [];
  Future<void> getFavoriteSongs() async {
    var returnedSongs = await getFavoritesSongUseCase();

    returnedSongs.fold((l) => emit(FavoriteSongsError()), (r) {
      emit(FavoriteSongsLoaded(favoriteSongs: r));
      favoriteSongs = r;
    });
  }

  void removeSong(int index) {
    if (state is! FavoriteSongsLoaded) return;

    final currentState = state as FavoriteSongsLoaded;
    final updatedSongs = List<SongEntity>.from(currentState.favoriteSongs)
      ..removeAt(index);

    emit(FavoriteSongsLoaded(favoriteSongs: updatedSongs));
  }
}
