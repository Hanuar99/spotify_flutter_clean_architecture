import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify/common/bloc/favorite_button/favorite_button_cubit.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/common/widgets/favorite_button/favorite_button_widget.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/core/router/app_routes.dart';
import 'package:spotify/domain/entities/song/song_entity.dart';
import 'package:spotify/presentation/home/cubit/play_list_cubit.dart';

class PlayListWidget extends StatelessWidget {
  const PlayListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteButtonCubit = context.watch<FavoriteButtonCubit>();

    return BlocBuilder<PlayListCubit, PlayListState>(
      builder: (context, state) {
        if (state is PlayListLoading) {
          return Center(
            child: Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is PlayListError) {
          return Center(
            child: Text(state.message),
          );
        }

        if (state is PlayListLoaded) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  'PlayList',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'See More',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xffC6C6C6),
                  ),
                ),
              ]),
              const SizedBox(height: 20),
              _songs(state.playList, favoriteButtonCubit: favoriteButtonCubit),
            ]),
          );
        }
        return Container();
      },
    );
  }

  Widget _songs(List<SongEntity> songs,
      {required FavoriteButtonCubit favoriteButtonCubit}) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            context.push(
              AppRoutes.songPlayer,
              extra: songs[index],
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.isDarkMode
                          ? AppColors.darkGrey
                          : Color(0xffE6E6E6),
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: context.isDarkMode
                          ? Color(0xff959595)
                          : Color(0xff555555),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        songs[index].title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        songs[index].artist,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xff959595),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(children: [
                Text(
                  songs[index].duration.toString().replaceAll('.', ':'),
                ),
                SizedBox(width: 20),
                FavoriteButtonWidget(
                  isFavorite: songs[index].isFavorite,
                  onPressed: () async {
                    await favoriteButtonCubit
                        .favoriteButtonUpdate(songs[index].songId);
                  },
                ),
              ])
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: songs.length,
    );
  }
}
