import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify/common/bloc/favorite_button/favorite_button_cubit.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/common/widgets/appbar/app_bar_widget.dart';
import 'package:spotify/common/widgets/favorite_button/favorite_button_widget.dart';
import 'package:spotify/core/router/app_routes.dart';
import 'package:spotify/presentation/profile/blocs/favorite_songs/favorite_songs_cubit.dart';
import 'package:spotify/presentation/profile/blocs/profile_info_cubit/profile_info_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBarWidget(
        backgroundColor: Color(0xff2C2B2B),
        title: Text('Profile'),
      ),
      body: Column(
        children: [
          ProfileInfo(),
          const SizedBox(height: 20),
          FavoriteSongs(),
        ],
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3.5,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.isDarkMode ? Color(0xff2C2B2B) : Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
        builder: (context, state) {
          if (state is ProfileInfoLoading) {
            return Center(
              child: Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  key: ValueKey('loading_profile'),
                ),
              ),
            );
          }

          if (state is ProfileInfoLoaded) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: state.user.imageUrl != null
                      ? NetworkImage(state.user.imageUrl!)
                      : null,
                  child: state.user.imageUrl == null
                      ? const Icon(Icons.person, size: 60)
                      : null,
                ),
                SizedBox(height: 15),
                Text(
                  state.user.email!,
                  style: TextStyle(
                    // fontSize: 20,
                    // fontWeight: FontWeight.bold,
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  state.user.fullName!,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            );
          }
          if (state is ProfileInfoError) {
            return Center(
              child: Text(state.message),
            );
          }
          return Container();
        },
      ),
    );
  }
}

class FavoriteSongs extends StatelessWidget {
  const FavoriteSongs({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteButtonCubit = context.watch<FavoriteButtonCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('FAVORITE SONGS'),
          const SizedBox(height: 20),
          BlocBuilder<FavoriteSongsCubit, FavoriteSongsState>(
              builder: (context, state) {
            if (state is FavoriteSongsLoading) {
              return Center(
                child: Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state is FavoriteSongsLoaded) {
              return ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(height: 20),
                itemCount: state.favoriteSongs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      context.push(
                        AppRoutes.songPlayer,
                        extra: state.favoriteSongs[index],
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          state.favoriteSongs[index].coverUrl),
                                      fit: BoxFit.cover)),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.favoriteSongs[index].title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  state.favoriteSongs[index].artist,
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
                            state.favoriteSongs[index].duration
                                .toString()
                                .replaceAll('.', ':'),
                          ),
                          SizedBox(width: 20),
                          FavoriteButtonWidget(
                            isFavorite: state.favoriteSongs[index].isFavorite,
                            onPressed: () async {
                              final favoriteSongsCubit =
                                  context.read<FavoriteSongsCubit>();

                              await favoriteButtonCubit.favoriteButtonUpdate(
                                state.favoriteSongs[index].songId,
                              );

                              favoriteSongsCubit.removeSong(index);
                            },
                          ),
                        ])
                      ],
                    ),
                  );
                },
              );
            }

            if (state is FavoriteSongsError) {
              return Center(
                child: Text('Please try again'),
              );
            }
            return Container();
          }),
        ],
      ),
    );
  }
}
