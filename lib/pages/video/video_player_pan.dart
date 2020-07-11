import 'package:feiyu/app/tool/time.dart';
import 'package:flutter/material.dart';
import 'package:screen/screen.dart';

//import 'package:screen/screen.dart';
import 'package:video_player/video_player.dart';
import 'package:sys_volume/flutter_volume.dart';

import 'after_layout.dart';
import 'controller_widget.dart';
import 'video_player_control.dart';

class VideoPlayerPan extends StatefulWidget {
  final Function share;
  final Function(bool) full;
  VideoPlayerPan({
    //  this.controlKey,
    this.child,
    this.share,
    this.full,
  });

//  final GlobalKey<VideoPlayerControlState> controlKey;
  final Widget child;

  @override
  _VideoPlayerPanState createState() => _VideoPlayerPanState();
}

class _VideoPlayerPanState extends State<VideoPlayerPan>
    with AfterLayoutMixin<VideoPlayerPan> {
  Offset startPosition; // 起始位置
  double movePan; // 偏移量累计总和
  double layoutWidth; // 组件宽度
  double layoutHeight; // 组件高度
  String volumePercentage = ''; // 组件位移描述
  double playDialogOpacity = 0.0;
  bool allowHorizontal = false; // 是否允许快进
  Duration position = Duration(seconds: 0); // 当前时间
  double volume = 0.0;
  double brightness = 0.0; //亮度
  bool brightnessOk = false; // 是否允许调节亮度

  VideoPlayerController get controller =>
      ControllerWidget.of(context).controller;
  bool get videoInit => ControllerWidget.of(context).videoInit;
  String get title => ControllerWidget.of(context).title;

  @override
  void afterFirstLayout(BuildContext context) {
    _reset(context);
    Future.delayed(Duration.zero).then((value) async {
      FlutterVolume.disableUI();
      brightness = await Screen.brightness;
      volume = await FlutterVolume.get();
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    brightnessOk = false;
    allowHorizontal = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: _onVerticalDragStart,
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Container(
        child: Stack(
          children: <Widget>[
            widget.child,
            Center(
              child: AnimatedOpacity(
                opacity: playDialogOpacity,
                duration: Duration(milliseconds: 500),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 6.0),
                  decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Text(
                    volumePercentage,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ),
            VideoPlayerControl(
              share: widget.share,
              full: widget.full,
              key: ControllerWidget.of(context).controlKey,
            )
          ],
        ),
      ),
    );
  }

  void _onVerticalDragStart(details) async {
    _reset(context);
    startPosition = details.globalPosition;
    if (startPosition.dx < (layoutWidth / 2)) {
      /// 左边触摸
      brightnessOk = true;
    }
  }

  double start = 0;
  void _onVerticalDragUpdate(details) {
    if (!videoInit) {
      return;
    }

    /// 累计计算偏移量(下滑减少百分比，上滑增加百分比)
    movePan += (-details.delta.dy);
    if (startPosition.dx < (layoutWidth / 2)) {
      /// 左边触摸
      if (brightnessOk = true) {
        setState(() {
          volumePercentage = '亮度：${(_setBrightnessValue() * 100).toInt()}%';
          playDialogOpacity = 1.0;
        });
      }
    } else {
      /// 右边触摸
      setState(() {
        volumePercentage = '音量：${(_setVerticalValue() * 100).toInt()}%';
        playDialogOpacity = 1.0;
      });
    }
    onDrag();
  }

  void _onVerticalDragEnd(_) async {
    brightness = await Screen.brightness;
    volume = await FlutterVolume.get();
    brightnessOk = false;
    playDialogOpacity = 0.0;
    setState(() {});
  }

  void onDrag() async {
    if (!videoInit) {
      return;
    }
    if (startPosition.dx < (layoutWidth / 2)) {
      if (brightnessOk) {
        await Screen.setBrightness(_setBrightnessValue());
      }
    } else {
      await FlutterVolume.set(_setVerticalValue());
    }
  }

  double _setBrightnessValue() {
    // 亮度百分控制
    double value =
        double.parse((movePan / layoutHeight + brightness).toStringAsFixed(2));
    if (value >= 1.00) {
      value = 1.00;
    } else if (value <= 0.00) {
      value = 0.00;
    }
    return value;
  }

  double _setVerticalValue() {
    print(movePan / layoutHeight * 100);
    // 声音百分控制
    double value =
        double.parse((movePan / layoutHeight + volume).toStringAsFixed(2));
    if (value >= 1.0) {
      value = 1.0;
    } else if (value <= 0.0) {
      value = 0.0;
    }
    return value;
  }

  void _reset(BuildContext context) {
    startPosition = Offset(0, 0);
    movePan = 0;
    layoutHeight = context.size.height;
    layoutWidth = context.size.width;
    volumePercentage = '';
  }

  void _onHorizontalDragStart(DragStartDetails details) async {
    _reset(context);
    if (!videoInit) {
      return;
    }
    // 获取当前时间
    position = controller.value.position;
    // 暂停成功后才允许快进手势
    allowHorizontal = true;
    await controller?.pause();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (!videoInit && !allowHorizontal) {
      return;
    }
    // 累计计算偏移量
    movePan += details.delta.dx;
    double value = _setHorizontalValue();
    // 用百分比计算出当前的秒数
    String currentSecond =
        videoTime((value * controller.value.duration?.inMilliseconds).toInt());
    if (value >= 0) {
      setState(() {
        volumePercentage = '快进至：$currentSecond';
        playDialogOpacity = 1.0;
      });
    } else {
      setState(() {
        volumePercentage = '快退至：${(value * 100).toInt()}%';
        playDialogOpacity = 1.0;
      });
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) async {
    if (!videoInit && !allowHorizontal) {
      return;
    }
    double value = _setHorizontalValue();
    int current = (value * controller.value.duration?.inMilliseconds).toInt();
    await controller?.seekTo(Duration(milliseconds: current));
    await controller?.play();
    allowHorizontal = false;
    setState(() {
      playDialogOpacity = 0.0;
    });
  }

  double _setHorizontalValue() {
    // 进度条百分控制
    double valueHorizontal =
        double.parse((movePan / layoutWidth).toStringAsFixed(2));
    // 当前进度条百分比
    double currentValue =
        position.inMilliseconds / controller.value.duration.inMilliseconds;
    double value =
        double.parse((currentValue + valueHorizontal).toStringAsFixed(2));
    if (value >= 1.00) {
      value = 1.00;
    } else if (value <= 0.00) {
      value = 0.00;
    }
    return value;
  }
}
