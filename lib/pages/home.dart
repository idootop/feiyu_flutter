import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:sensors/sensors.dart';

import 'package:feiyu/app/config/config.dart';
import 'package:feiyu/app/model/movie.dart';
import 'package:feiyu/app/model/player.dart';
import 'package:feiyu/app/model/push.dart';
import 'package:feiyu/app/model/site.dart';
import 'package:feiyu/app/tool/http.dart';
import 'package:feiyu/app/tool/random.dart';
import 'package:feiyu/app/widget/myBlurButton.dart';
import 'package:feiyu/app/widget/myBottomInput.dart';
import 'package:feiyu/app/widget/myBottomTip.dart';
import 'package:feiyu/app/widget/myImage.dart';
import 'package:feiyu/app/widget/myText.dart';
import 'package:feiyu/app/widget/myTips.dart';
import 'package:feiyu/pages/searchList.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

import 'detail.dart';

class Home extends StatefulWidget {
  final Http http;
  final Push push;
  final Player player;
  final List<Site> sites;
  final List<Movie> movies;
  final bool loading;

  Home(
      {this.http,
      this.push,
      this.player,
      this.sites,
      this.movies,
      this.loading});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Http http;
  double screenWidth, screenHeight;

  Push push;
  Player player;
  List<Site> sites = [];
  List<Movie> movies = [];
  bool loading = true;

  List<double> _accelerometerValues;
  List<double> _userAccelerometerValues;
  List<double> _gyroscopeValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    screenWidth = ScreenUtil.getInstance().screenWidth;
    screenHeight = ScreenUtil.getInstance().screenHeight;
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[event.x, event.y, event.z];
      });
    }));
    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _userAccelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
    if (widget.movies == null) {
      Future.delayed(Duration.zero, () async {
        await load(context); //获取推送通知
      });
    } else {
      reopen();
      setState(() {});
    }
  }

  sensor() {
    final List<String> accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> gyroscope =
        _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        ?.toList();
    return Column(
      children: <Widget>[
        Text('Accelerometer: $accelerometer'),
        Text('gyroscope: $gyroscope'),
        Text('userAccelerometer: $userAccelerometer'),
      ],
    );
  }

  reopen() {
    http = widget.http;
    push = widget.push;
    player = widget.player;
    sites = widget.sites;
    movies = widget.movies;
    loading = widget.loading;
  }

  Future<void> load(context) async {
    http = Http();
    //获取推送
    String result = await http.get('$SERVER/$APP/push.json');
    if (result.contains('请求失败')) {
      push = Push.fromJson(jsonDecode(PUSH));
      await myTips(context, "通知", push.info);
      if (push.force.contains('是')) return;
    } else {
      push = Push.fromJson(jsonDecode(result));
      if (push.flag.contains('开')) {
        await myTips(context, "通知", push.info);
        if (push.force.contains('是')) return;
      }
    }
    //获取网页播放器
    result = await http.get('$SERVER/$APP/player.json');
    if (result.contains('请求失败')) {
      player = Player.fromJson(jsonDecode(PLAYER));
    } else {
      player = Player.fromJson(jsonDecode(result));
    }
    //获取首页电影
    result = await http.get('$SERVER/$APP/movies.json');
    if (result.contains('请求失败')) {
      movies = jsonDecode(MOVIES).map<Movie>((e) => Movie.fromJson(e)).toList();
    } else {
      movies = jsonDecode(result).map<Movie>((e) => Movie.fromJson(e)).toList();
    }
    //获取资源站
    result = await http.get('$SERVER/$APP/sites.json');
    if (result.contains('请求失败')) {
      sites = jsonDecode(SITES).map<Site>((e) => Site.fromJson(e)).toList();
    } else {
      sites = jsonDecode(result).map<Site>((e) => Site.fromJson(e)).toList();
    }
    loading = false;
    //随机显示电影
    movies = randomMovies(movies);
    setState(() {});
  }

  void about() async {
    await myBottomTip(context,
        title: '关于',
        desp: push?.about ??
            '飞鱼是一个极简的播放器，它是我最近的一个Flutter项目，代码完全开源，仅供学习交流，想要了解更多信息，请关注公众号：乂乂又又。');
  }

  void search() async {
    var s = await myBottomInput(context,
        title: '搜索', hint: '请输入电影名称...', autoFocus: true);
    if (s != null && s.length > 0) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              SearchList(s, player: player, sites: sites),
        ),
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => Home(
          http: http,
          push: push,
          player: player,
          sites: sites,
          movies: randomMovies(movies),
          loading: loading,
        ),
      ));
    }
  }

  void play(Movie movie) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Detail(movie, player: player),
      ),
    );
  }

  var max = 10;
  var big = 0.2;
  Widget moviePage(Movie movie) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          play(movie);
        },
        child: Stack(
          children: <Widget>[
            AnimatedPositioned(
                left: screenWidth * big / 2 / max * _accelerometerValues[0],
                right:
                    screenWidth * big / 2 / max * _accelerometerValues[0] * -1,
                top:
                    screenHeight * big / 2 / max * _accelerometerValues[1] * -1,
                bottom: screenHeight * big / 2 / max * _accelerometerValues[1],
                duration: const Duration(milliseconds: 90),
                curve: Curves.linear,
                child: Hero(
                    tag: movie.cover,
                    child: Container(
                      width: screenWidth * (1 + big),
                      height: screenHeight * (1 + big),
                      child: MyImage(movie.cover, fit: BoxFit.cover),
                    ))),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: screenWidth,
                height: screenHeight,
                alignment: Alignment.center,
                padding: EdgeInsets.all(screenWidth / 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(flex: 1, child: SizedBox(width: 0, height: 0)),
                    // sensor(),
                    Container(
                      margin: EdgeInsets.all(screenWidth / 20),
                      child: Icon(Icons.play_circle_filled,
                          size: 64, color: Colors.white),
                    ),
                    Expanded(flex: 1, child: SizedBox(width: 0, height: 0)),
                    GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          await myBottomTip(context,
                              title: movie.title, desp: movie.desp);
                        },
                        child: Icon(Icons.keyboard_arrow_up,
                            size: screenWidth / 10 * 1, color: Colors.white)),
                    GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          await myBottomTip(context,
                              title: movie.title, desp: movie.desp);
                        },
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(screenWidth / 20),
                            child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                    padding: EdgeInsets.only(
                                        bottom: screenWidth / 20,
                                        left: screenWidth / 20,
                                        right: screenWidth / 20,
                                        top: screenWidth / 20 / 2),
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                            screenWidth / 20)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          movie.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          movie.desp,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        )
                                      ],
                                    ))))),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget header() {
    return Container(
        padding: EdgeInsets.all(screenWidth / 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            myBlurButton(Icons.sort, onTap: about),
            myBlurButton(Icons.search, onTap: search),
          ],
        ));
  }

  Widget loadingPage() {
    return Container(
        width: screenWidth,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(child: SizedBox()),
            CircularProgressIndicator(),
            SizedBox(height: 24),
            myText('初始化...', color: Colors.black),
            Expanded(child: SizedBox()),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.black54,
          child: loading
              ? loadingPage()
              : Stack(children: <Widget>[
                  OverflowBox(
                      maxWidth: screenWidth * (1 + big),
                      maxHeight: screenHeight * (1 + big),
                      child: PageView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        children: movies
                            .map<Widget>((movie) => moviePage(movie))
                            .toList(),
                      )),
                  SafeArea(child: header()),
                ]),
        ));
  }

  List<Movie> randomMovies(List<Movie> old) {
    int len = old.length;
    List newList = new List<Movie>()..length = len;
    List order = old.map((e) => old.indexOf(e)).toList()..sort();
    for (var i = 0; i < len; i++) {
      var index = randomListItem(order);
      newList[i] = old[index];
      order.remove(index);
    }
    return newList;
  }
}
