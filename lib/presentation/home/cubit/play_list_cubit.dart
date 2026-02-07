import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/entities/song/song_entity.dart';
import 'package:spotify/domain/usecases/song/get_play_list_usecase.dart';

part 'play_list_state.dart';

class PlayListCubit extends Cubit<PlayListState> {
  final GetPlayListUseCase getPlayListUseCase;

  PlayListCubit(this.getPlayListUseCase) : super(PlayListLoading());

  Future<void> getPlayList() async {
    final result = await getPlayListUseCase();

    result.fold(
      (l) => emit(PlayListError(message: l.toString())),
      (r) => emit(PlayListLoaded(playList: r)),
    );
  }
}
