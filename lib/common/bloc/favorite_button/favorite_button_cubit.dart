import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/usecases/song/add_or_remove_favorite_usecase.dart';

part 'favorite_button_state.dart';

class FavoriteButtonCubit extends Cubit<FavoriteButtonState> {
  final AddOrRemoveFavoriteUsecase addOrRemoveFavoriteUsecase;
  FavoriteButtonCubit(this.addOrRemoveFavoriteUsecase)
      : super(FavoriteButtonInitial());

  Future<void> favoriteButtonUpdate(String songId) async {
    var result = await addOrRemoveFavoriteUsecase.call(songId);
    result.fold((l) => null,
        (isFavorite) => emit(FavoriteButtonUpdated(isFavorite: isFavorite)));
  }
}
