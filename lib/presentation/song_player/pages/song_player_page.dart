import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/widgets/appbar/app_bar_widget.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/song/song_entity.dart';
import 'package:spotify/presentation/song_player/bloc/cubit/song_player_cubit.dart';

class SongPlayerPage extends StatelessWidget {
  final SongEntity song;

  const SongPlayerPage({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return SongPlayerView(song: song);
  }
}

class SongPlayerView extends StatelessWidget {
  final SongEntity song;

  const SongPlayerView({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: BasicAppBarWidget(
        title: const Text('Now playing', style: TextStyle(fontSize: 18)),
        action: IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            _SongCover(coverUrl: song.coverUrl, height: height / 2),
            const SizedBox(height: 20),
            _SongDetail(song: song),
            const SizedBox(height: 20),
            const _SongPlayerControls(),
          ],
        ),
      ),
    );
  }
}

class _SongCover extends StatelessWidget {
  final String coverUrl;
  final double height;

  const _SongCover({
    required this.coverUrl,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          image: NetworkImage(coverUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _SongDetail extends StatelessWidget {
  final SongEntity song;

  const _SongDetail({required this.song});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              song.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            Text(
              song.artist,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff959595),
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.favorite_outline_outlined,
            color: AppColors.darkGrey,
            size: 35,
          ),
        ),
      ],
    );
  }
}

class _SongPlayerControls extends StatelessWidget {
  const _SongPlayerControls();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      builder: (context, state) {
        if (state is SongPlayerLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SongPlayerLoaded) {
          final max = state.duration.inSeconds > 0
              ? state.duration.inSeconds.toDouble()
              : 1.0;

          return Column(
            children: [
              Slider(
                key: const Key('song_slider'),
                value:
                    state.position.inSeconds.clamp(0, max.toInt()).toDouble(),
                min: 0,
                max: max,
                onChanged: (_) {},
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_format(state.position)),
                  Text(_format(state.duration)),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                key: const Key('play_pause_button'),
                onTap: () => context.read<SongPlayerCubit>().playOrPause(),
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: Icon(
                    state.isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  String _format(Duration d) => d.toString().split('.').first.padLeft(8, '0');
}

// class SongPlayerPage extends StatelessWidget {
//   final SongEntity song;

//   const SongPlayerPage({
//     super.key,
//     required this.song,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: BasicAppBarWidget(
//         title: const Text('Now playing', style: TextStyle(fontSize: 18)),
//         action: IconButton(
//           icon: const Icon(Icons.more_vert, color: Colors.white),
//           onPressed: () {},
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//         child: Column(
//           children: [
//             _songCover(context),
//             const SizedBox(height: 20),
//             _songDetail(song),
//             const SizedBox(height: 20),
//             _songPlayer(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _songCover(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height / 2,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(30),
//         image: DecorationImage(
//           image: NetworkImage(song.coverUrl),
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }

//   Widget _songDetail(SongEntity song) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               song.title,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 22,
//               ),
//             ),
//             Text(
//               song.artist,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w400,
//                 fontSize: 14,
//                 color: Color(0xff959595),
//               ),
//             ),
//           ],
//         ),
//         IconButton(
//           onPressed: () {},
//           icon: const Icon(
//             Icons.favorite_outline_outlined,
//             color: AppColors.darkGrey,
//             size: 35,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _songPlayer() {
//     return BlocBuilder<SongPlayerCubit, SongPlayerState>(
//       builder: (context, state) {
//         if (state is SongPlayerLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (state is SongPlayerLoaded) {
//           return Column(
//             children: [
//               Slider(
//                 value: state.position.inSeconds.toDouble(),
//                 min: 0,
//                 max: state.duration.inSeconds.toDouble(),
//                 onChanged: (_) {},
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(state.position.toString().split('.').first),
//                   Text(state.duration.toString().split('.').first),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               GestureDetector(
//                 onTap: () {
//                   context.read<SongPlayerCubit>().playOrPause();
//                 },
//                 child: Container(
//                   height: 60,
//                   width: 60,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: AppColors.primary,
//                   ),
//                   child: Icon(
//                     state.isPlaying ? Icons.pause : Icons.play_arrow,
//                   ),
//                 ),
//               ),
//             ],
//           );
//         }

//         return const SizedBox.shrink();
//       },
//     );
//   }
// }
