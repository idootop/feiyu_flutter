import 'package:feiyu/app/model/movie.dart';
import 'package:feiyu/app/widget/myBottomTip.dart';
import 'package:flutter/material.dart';
import 'video/video_player_UI.dart';

class Play extends StatelessWidget {
  final Playlist playlist;
  Play(this.playlist);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: VideoPlayerUI.network(
        url: playlist.m3u8,
        title: playlist.name,
        share: () async {
          await myBottomTip(context,
              title: '关于', desp: '飞鱼是一个极简的播放器，它是我最近的一个Flutter项目。');
        },
        full: (bool full) async {
          await myBottomTip(context,
              title: '关于', desp: full ? '全屏--》未全屏' : '未全屏--》全屏');
        },
      ),
    );
  }
}
