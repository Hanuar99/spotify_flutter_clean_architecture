import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/core/router/app_routes.dart';
import 'package:spotify/domain/entities/song/song_entity.dart';
import 'package:spotify/presentation/home/cubit/news_songs_cubit.dart';

class NewSongsWidget extends StatelessWidget {
  const NewSongsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: BlocBuilder<NewsSongsCubit, NewsSongsState>(
        builder: (context, state) {
          if (state is NewsSongsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is NewsSongsError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is NewsSongsLoaded) {
            return _songs(state.newsSongs);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _songs(List<SongEntity> songs) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            context.push(
              AppRoutes.songPlayer,
              extra: songs[index],
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                          image: NetworkImage(songs[index].coverUrl),
                          fit: BoxFit.cover,
                        )),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 40,
                        width: 40,
                        transform: Matrix4.translationValues(10, 10, 0),
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
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  songs[index].title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  songs[index].artist,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 14),
      itemCount: songs.length,
    );
  }
}
