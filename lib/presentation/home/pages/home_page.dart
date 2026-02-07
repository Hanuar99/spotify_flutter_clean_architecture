import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/common/widgets/appbar/app_bar_widget.dart';
import 'package:spotify/core/router/app_routes.dart';
import 'package:spotify/generated/assets.gen.dart';
import 'package:spotify/presentation/home/widgets/new_songs_widget.dart';
import 'package:spotify/presentation/home/widgets/play_list_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBarWidget(
        hideBack: true,
        title: Assets.vectors.spotifyLogo
            .svg(height: 40, width: 40, key: Key('logo')),
        action: IconButton(
            onPressed: () {
              context.push(AppRoutes.profile);
            },
            icon: const Icon(Icons.person)),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _homeTopCard(),
            _tabs(),
            SizedBox(
              height: 260,
              child: TabBarView(controller: _tabController, children: [
                NewSongsWidget(),
                Container(),
                Container(),
                Container(),
              ]),
            ),
            PlayListWidget(),
          ],
        ),
      ),
    );
  }

  Widget _homeTopCard() {
    return Center(
      child: SizedBox(
        height: 160,
        child: Stack(
          children: [
            Align(
                alignment: Alignment.bottomCenter,
                child: Assets.vectors.homeTopCard.svg()),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 40),
                  child: Assets.images.homeArtist.image(),
                )),
          ],
        ),
      ),
    );
  }

  Widget _tabs() {
    return TabBar(
      controller: _tabController,
      // isScrollable: true,
      labelColor: context.isDarkMode ? Colors.white : Colors.black,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      tabs: [
        Text('News'),
        Text('Videos'),
        Text('Artists'),
        Text('Podcasts'),
      ],
    );
  }
}
