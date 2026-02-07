import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/entities/song/song_entity.dart';
import 'package:spotify/domain/usecases/song/get_news_songs_usecase.dart';

part 'news_songs_state.dart';

class NewsSongsCubit extends Cubit<NewsSongsState> {
  final GetNewsSongsUseCase getNewsSongsUseCase;
  NewsSongsCubit(this.getNewsSongsUseCase) : super(NewsSongsLoading());

  Future<void> getNewsSongs() async {
    final result = await getNewsSongsUseCase();

    result.fold(
      (l) => emit(NewsSongsError(message: l.toString())),
      (r) => emit(NewsSongsLoaded(newsSongs: r)),
    );
  }
}
