import 'dart:async';
import 'package:feiyu/app/tool/time.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'controller_widget.dart';

class VideoPlayerSlider extends StatefulWidget {
  final Function startPlayControlTimer;
  final Timer timer;

  VideoPlayerSlider({this.startPlayControlTimer, this.timer});

  @override
  _VideoPlayerSliderState createState() => _VideoPlayerSliderState();
}

class _VideoPlayerSliderState extends State<VideoPlayerSlider> {
  VideoPlayerController get controller =>
      ControllerWidget.of(context).controller;

  bool get videoInit => ControllerWidget.of(context).videoInit;
  double progressValue; //进度
  String labelProgress; //tip内容
  bool handle = false; //判断是否在滑动的标识

  @override
  void initState() {
    super.initState();
    progressValue = 0.0;
    labelProgress = '00:00';
  }

  @override
  void didUpdateWidget(VideoPlayerSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    var v = controller.value;
    if (!handle && videoInit && v != null) {
      int position = v.position == null ? 0 : v.position.inMilliseconds;
      int duration = v.duration == null ? 0 : v.duration.inMilliseconds;
      if (position >= duration) {
        position = duration;
      } 
      setState(() {
        progressValue = duration == 0 ? 0 : position / duration * 100;
        labelProgress = videoTime(position.toInt());
      });
    }
  }

  @override 
  Widget build(BuildContext context) {
    return SliderTheme(
        data: SliderTheme.of(context).copyWith(
          //提示进度的气泡文本的颜色
          valueIndicatorTextStyle: TextStyle(
            color: Colors.black,
          ),
        ),
        child: Slider(
          value: progressValue,
          label: labelProgress,
          divisions: 100,
          onChangeStart: _onChangeStart,
          onChangeEnd: _onChangeEnd,
          onChanged: _onChanged,
          min: 0,
          max: 100,
          activeColor: Colors.yellow,
          inactiveColor: Colors.white,
        ));
  }

  void _onChangeEnd(_) async{
    if (!videoInit) return;
    widget.startPlayControlTimer(); //开始计时隐藏控制组件
    handle = false; //未在滑动
    // 跳转到滑动时间
    int duration = controller.value.duration.inMilliseconds;
    controller.seekTo(
      Duration(milliseconds: (progressValue / 100 * duration).toInt()),
    );
    await controller.play();//开始播放
  }

  void _onChangeStart(_) async {
    if (!videoInit) return;
    widget.timer?.cancel(); //停止计时
    handle = true; //滑动中
    await controller.pause();//暂停
  }

  void _onChanged(double value) {
    if (!videoInit) return;
    widget.timer?.cancel(); //停止计时
    int duration = controller.value.duration.inMilliseconds;
    setState(() {
      //滑动进度
      progressValue = value;
      //气泡进度
      labelProgress = videoTime((value / 100 * duration).toInt());
    });
  }
}
