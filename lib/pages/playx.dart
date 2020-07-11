import 'dart:ui';
import 'package:feiyu/app/model/movie.dart';
import 'package:feiyu/app/model/player.dart';
import 'package:feiyu/app/widget/myBottomSheet.dart';
import 'package:feiyu/app/widget/myText.dart';
import 'package:feiyu/pages/share.dart';
import 'package:feiyu/pages/tv.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:screen/screen.dart';
import 'package:video_player/video_player.dart';
import 'package:feiyu/pages/video/controller_widget.dart';
import 'package:feiyu/pages/video/video_player_control.dart';
import 'package:feiyu/pages/video/video_player_pan.dart';

class PlayX extends StatefulWidget {
  final Movie movie;
  final Playlist playlist;
  final Player player;
  PlayX(this.movie, this.playlist, {@required this.player});

  @override
  _PlayXState createState() => _PlayXState();
}

class _PlayXState extends State<PlayX> {
  Playlist selected;
  final GlobalKey<VideoPlayerControlState> _key =
      GlobalKey<VideoPlayerControlState>();

  ///指示video资源是否加载完成，加载完成后会获得总时长和视频长宽比等信息
  bool _videoInit = false;
  bool _videoError = false;
  bool changing = false;

  VideoPlayerController _controller; // video控件管理器

  /// 记录是否全屏
  bool get _isFullScreen =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  Size get _window => MediaQueryData.fromWindow(window).size;

  DateTime _tempTime = DateTime.now();

  share() async {
    if (changing) return;
    await _controller?.pause();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Share(
            title: widget.movie.title,
            cover: widget.movie.cover,
            m3u8: selected.m3u8,
            name: selected.name,
            player: widget.player),
      ),
    );
    await _controller?.play();
  }

  shareTV() async {
    if (changing) return;
    await _controller?.pause();
    await Navigator.push(context, MyBottomSheet(child: TV(playlist: selected)));
    await _controller?.play();
  }

  full(bool fullx) {
    setState(() {}); //刷新界面
  }

  @override
  Widget build(BuildContext context) {
    var screen = ScreenUtil.getInstance();
    var screenWidth = screen.screenWidth;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(padding: EdgeInsets.zero, children: <Widget>[
        Offstage(
            offstage: _isFullScreen,
            child: SafeArea(
                child: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text(
                widget.movie.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: share,
                ),
              ],
            ))),
        Container(
          color: Colors.black,
          width: !_isFullScreen ? _window.width : _window.width,
          height: !_isFullScreen ? _window.width / 16 * 9 : _window.height,
          child: _isHadUrl(),
        ),
        Offstage(
            offstage: _isFullScreen,
            child: Container(
              height: _isFullScreen
                  ? 0
                  : _window.height -
                      _window.width / 16 * 9 -
                      screen.appBarHeight -
                      screen.statusBarHeight,
              child: ListView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    SizedBox(height: screenWidth / 20),
                    myLable('选集'),
                    SizedBox(height: screenWidth / 20),
                    Container(
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth / 10),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: widget.movie.playlist
                            .map((e) => myItem(e))
                            .toList(),
                      ),
                    ),
                    SizedBox(height: screenWidth / 20),
                    myLable('简介'),
                    SizedBox(height: screenWidth / 20),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth / 10),
                      child: Text(
                        widget.movie.desp,
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            letterSpacing: 1.5),
                      ),
                    ),
                    SizedBox(height: screenWidth / 10),
                  ]),
            )),
      ]),
    );
  }

  Widget myItem(Playlist playlist) {
    var flag = selected == playlist;
    return GestureDetector(
      onTap: () async {
        setState(() {
          selected = playlist;
        });
        await _urlChange();
      },
      child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: flag ? Colors.yellow : const Color(0xFFf4f5fa),
              borderRadius: BorderRadiusDirectional.all(Radius.circular(10))),
          child: myText(playlist.name,
              size: 12,
              color: flag ? Colors.black : Colors.black,
              big: flag ? FontWeight.bold : null)),
    );
  }

// 判断是否有url
  Widget _isHadUrl() {
    return ControllerWidget(
      controlKey: _key,
      controller: _controller,
      videoInit: _videoInit,
      title: selected.name,
      child: VideoPlayerPan(
        share: shareTV,
        full: full,
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: _isVideoInit(),
        ),
      ),
    );
  }

// 加载url成功时，根据视频比例渲染播放器
  Widget _isVideoInit() {
    if (_videoInit) {
      if (_videoError) {
        return Text(
          '加载失败，请重试~',
          style: TextStyle(color: Colors.white),
        );
      }
      return AspectRatio(
        aspectRatio: _controller?.value?.aspectRatio,
        child: VideoPlayer(_controller),
      );
    } else if (_controller != null && !changing) {
      return Text(
        '加载失败，请重试~',
        style: TextStyle(color: Colors.white),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(),
          ),
          SizedBox(height: 30),
          Text(
            '加载中...',
            style: TextStyle(color: Colors.white),
          )
        ],
      );
    }
  }

  void _videoListener() async {
    if (_controller?.value?.hasError ?? false) {
      _videoError = true;
      changing = false;
      print(_controller?.value?.errorDescription);
    }
    if (_controller?.value?.initialized ?? false) {
      changing = false;
    }
    if (_controller?.value?.isBuffering ?? false) {}
    if (DateTime.now().difference(_tempTime).inMilliseconds > 999) {
      // Duration res = await _controller?.position;
      if (_controller?.value?.isPlaying ?? false) {
        _key.currentState?.setPosition(
          position: _controller?.value?.position ?? Duration.zero,
          totalDuration: _controller?.value?.duration ?? Duration.zero,
        );
      }
      _tempTime = DateTime.now();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    selected = widget.playlist;
    _urlChange(); // 初始进行一次url加载
    Screen.keepOn(true); // 设置屏幕常亮
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    Screen.keepOn(false);
  }

  _urlChange() async {
    setState(() {
      changing = true;
    });
    var old = _controller;
    if (_controller != null) {
      /// 如果控制器存在，清理掉重新创建
      _controller?.removeListener(_videoListener);
      await _controller?.pause();
    }
    _controller = VideoPlayerController.network(selected.m3u8);
    setState(() {
      /// 重置组件参数
      _videoInit = false;
      _videoError = false;
    });

    /// 加载资源完成时，监听播放进度，并且标记_videoInit=true加载完成
    _controller?.addListener(_videoListener);
    try {
      await _controller?.initialize();
      _key.currentState?.setPosition(
        position: Duration(seconds: 0),
        totalDuration: _controller?.value?.duration ?? Duration(seconds: 0),
      );
      setState(() {
        _videoInit = true;
        _videoError = false;
        _controller?.play();
      });
      await old?.dispose();
    } catch (e) {
      setState(() {
        _videoInit = true;
        _videoError = true;
        _controller?.pause();
      });
    }
  }
}
