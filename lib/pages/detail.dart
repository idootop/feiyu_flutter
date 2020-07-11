import 'package:feiyu/app/model/movie.dart';
import 'package:feiyu/app/model/player.dart';
import 'package:feiyu/app/widget/myBlurButton.dart';
import 'package:feiyu/app/widget/myImage.dart';
import 'package:feiyu/app/widget/myRoundButton.dart';
import 'package:feiyu/app/widget/myText.dart';
import 'package:feiyu/pages/playx.dart';
import 'package:feiyu/pages/share.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  final Movie movie;
  final Player player;
  Detail(this.movie, {@required this.player});
  @override
  _DetailState createState() => _DetailState(this.movie);
}

class _DetailState extends State<Detail> {
  Movie movie;
  Playlist selected;

  double screenWidth = ScreenUtil.getInstance().screenWidth;
// 屏幕高
  double screenHeight = ScreenUtil.getInstance().screenHeight;
  _DetailState(this.movie);

  @override
  void initState() {
    super.initState();
    selected = movie.playlist[0];
  }

  void share() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Share(
            title: movie.title,
            cover: movie.cover,
            m3u8: selected.m3u8,
            name: selected.name,
            player: widget.player),
      ),
    );
  }

  void play() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            PlayX(movie, selected, player: widget.player),
      ),
    );
    //从播放页返回时直接返回上一页
    Navigator.pop(context);
  }

  Widget header() {
    return Container(
        padding: EdgeInsets.all(screenWidth / 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            myBlurButton(Icons.keyboard_backspace, onTap: () {
              Navigator.pop(context);
            }),
            myBlurButton(Icons.share, onTap: share),
          ],
        ));
  }

  Widget myItem(Playlist playlist) {
    var flag = selected == playlist;
    return GestureDetector(
      onTap: () {
        setState(() {
          //播放
          selected = playlist;
        });
        play();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: <Widget>[
          //背景图
          Hero(
              tag: movie.cover + 'bg',
              child: Container(
                color: Colors.black54,
                width: screenWidth,
                child: MyImage(
                  movie.cover,
                  fit: BoxFit.cover,
                ),
              )),
          ListView(
            children: <Widget>[
              Container(
                width: screenWidth,
                height: screenWidth * 1.6 - screenWidth * 0.15,
                child: Stack(children: <Widget>[
                  //标题
                  Positioned(
                      top: screenWidth * 1 - screenWidth * 0.0,
                      left: screenWidth / 10 + screenWidth / 3,
                      child: Container(
                        color: Colors.black54,
                        width: screenWidth * 0.52 + 20,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('${movie.title}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            )),
                      )),
                  //异形底部
                  Positioned(
                      top: screenWidth - screenWidth * 0.0,
                      child: ClipPath(
                        clipper: ArcClipper(),
                        child: Container(
                          width: screenWidth,
                          height: screenWidth * 0.3,
                          color: Colors.white,
                        ),
                      )),
                  //底部背景色
                  Positioned(
                    top: screenWidth + screenWidth * 0.3 - screenWidth * 0.0,
                    child: Container(
                        width: screenWidth,
                        height: screenWidth / 6,
                        color: Colors.white,
                        child: SizedBox()),
                  ),
                  //播放按钮
                  Positioned(
                    top: screenWidth * 1.21 - screenWidth * 0.0,
                    left: screenWidth / 20 * 13,
                    child: Material(
                      elevation: 18,
                      shadowColor: Colors.yellowAccent,
                      color: Colors.transparent,
                      borderRadius: BorderRadiusDirectional.all(
                          Radius.circular(screenWidth / 20 * 3 / 2)),
                      child: myIcon(Icons.play_arrow,
                          onTap: play,
                          colorIcon: Colors.white,
                          colorBack: Colors.yellow,
                          sizeIcon: screenWidth / 20 * 2,
                          sizeBack: screenWidth / 20 * 3),
                    ),
                  ),
                  //完整封面
                  Positioned(
                    top: screenWidth * 1 - screenWidth * 0.0,
                    left: screenWidth / 10,
                    child: Material(
                        elevation: 10,
                        child: Hero(
                            tag: movie.cover,
                            child: Container(
                              width: screenWidth / 4,
                              height: screenWidth / 4 / 0.7,
                              child: MyImage(
                                movie.cover,
                                fit: BoxFit.cover,
                              ),
                            ))),
                  ),
                ]),
              ),
              Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      myLable('选集'),
                      SizedBox(height: screenWidth / 20),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: screenWidth / 10),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children:
                              movie.playlist.map((e) => myItem(e)).toList(),
                        ),
                      ),
                      SizedBox(height: screenWidth / 20),
                      myLable('简介'),
                      SizedBox(height: screenWidth / 20),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: screenWidth / 10),
                        child: Text(
                          movie.desp,
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              letterSpacing: 1.5),
                        ),
                      ),
                      SizedBox(height: screenWidth / 10),
                    ],
                  )),
            ],
          ),
          SafeArea(child: header()),
        ]));
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    var firstControlPoint = Offset(size.width / 3, size.height);
    var firstPoint = Offset(0, 0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
