import 'package:feiyu/app/model/player.dart';
import 'package:feiyu/app/tool/decode.dart';
import 'package:feiyu/app/widget/myImage.dart';
import 'package:feiyu/app/widget/myText.dart';
import 'package:feiyu/app/widget/myToast.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Share extends StatelessWidget {
  final Player player; //在线播放器
  final String title; //标题
  final String cover; //封面
  final String name; //剧集
  final String m3u8;

  Share({this.title, this.name, this.m3u8, this.cover, this.player});

  @override
  Widget build(BuildContext context) {
    var screenWidth = ScreenUtil.getInstance().screenWidth;
    var screenHeight = ScreenUtil.getInstance().screenHeight;
    var wh = 1 / 0.7;
    var imgW = screenWidth * 0.6;
    var imgH = imgW * wh;
    var pSize = screenWidth / 20;
    var pBottom = (screenHeight - imgH - imgW) / 2 + imgW - pSize;
    var pMargin = (screenWidth - imgW) / 2 - pSize;
    var pColor = Colors.yellow;
    var flag = player.public.contains('是');
    var qrstr =
        '${player.server}?${player.m3u8}=${flag ? m3u8 : encodex(m3u8)}&${player.title}=${flag ? title : encodex(title)}';
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Container(
        child: Stack(
          children: <Widget>[
            //返回
            Align(
              alignment: Alignment.topLeft,
              child: SafeArea(
                  child: IconButton(
                      iconSize: 36,
                      padding: EdgeInsets.all(screenWidth / 20),
                      icon: Icon(
                        Icons.keyboard_backspace,
                        color: Colors.white,
                        size: 36,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      })),
            ),
            //分享
            Align(
              alignment: Alignment.topRight,
              child: SafeArea(
                  child: IconButton(
                      iconSize: 36,
                      padding: EdgeInsets.all(screenWidth / 20),
                      icon: Icon(
                        Icons.share,
                        color: Colors.white,
                        size: 36,
                      ),
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: '$title $name\n播放地址：$qrstr'));
                        myToast('已复制');
                      })),
            ),
            //body
            Align(
              alignment: Alignment.center,
              child: Column(
                // shrinkWrap: true,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(pSize / 2),
                      child: Container(
                          width: imgW, height: imgH, child: MyImage(cover))),
                  Container(
                    width: imgW,
                    height: imgW,
                    padding: EdgeInsets.all(screenWidth / 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(pSize / 2)),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          myText(title, big: FontWeight.bold, size: 16),
                          QrImage(
                            data: qrstr,
                            version: QrVersions.auto,
                            size: screenWidth * 0.36,
                            errorStateBuilder: (cxt, err) {
                              return Container(
                                child: Center(
                                  child: Text(
                                    "糟糕，出错了...",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                          myText('扫码播放→' + name,
                              big: FontWeight.bold, size: 14),
                        ]),
                  )
                ],
              ),
            ),
            Positioned(
                bottom: pBottom,
                left: pMargin,
                child: Container(
                  width: pSize * 2,
                  height: pSize * 2,
                  decoration: BoxDecoration(
                      color: pColor,
                      borderRadius: BorderRadius.circular(pSize)),
                )),
            Positioned(
                bottom: pBottom,
                right: pMargin,
                child: Container(
                  width: pSize * 2,
                  height: pSize * 2,
                  decoration: BoxDecoration(
                      color: pColor,
                      borderRadius: BorderRadius.circular(pSize)),
                ))
          ],
        ),
      ),
    );
  }
}
