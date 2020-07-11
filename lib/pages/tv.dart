import 'package:dlna/dlna.dart';
import 'package:feiyu/app/model/movie.dart';
import 'package:feiyu/app/widget/myRoundButton.dart';
import 'package:feiyu/app/widget/myText.dart';
import 'package:feiyu/app/widget/myToast.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

class TV extends StatefulWidget {
  final Playlist playlist;

  TV({this.playlist});
  @override
  _TVState createState() => _TVState();
}

class _TVState extends State<TV> {
  bool searching = true;
  var screenWidth = ScreenUtil.getInstance().screenWidth;
  var screenHeight = ScreenUtil.getInstance().screenHeight;

  DLNAManager dlnaManager;
  List<DLNADevice> _devices = [];
  VideoObject _didlObject;
  DLNADevice _dlnaDevice;
  String actionMessage = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async => await init());
  }

  Future<void> init() async {
    //初始化DLNAManager
    dlnaManager = DLNAManager();
    // dlnaManager.enableCache();
    //设置视频对象
    _didlObject = VideoObject(
        widget.playlist?.name ?? '爱的迫降',
        widget.playlist?.m3u8 ??
            'https://txxs.mahua-yongjiu.com/20191214/7845_6fcff130/index.m3u8',
        VideoObject.VIDEO_MP4);
    _didlObject.refreshPosition = true;
    //监听DLNAManager
    dlnaManager.setRefresher(DeviceRefresher(onDeviceAdd: (dlnaDevice) {
      if (!_devices.contains(dlnaDevice)) {
        print('add ' + dlnaDevice.toString());
        _devices.add(dlnaDevice);
        searching = false;
      }
      setState(() {});
    }, onDeviceRemove: (dlnaDevice) {
      print('remove ' + dlnaDevice.toString());
      _devices.remove(dlnaDevice);
      setState(() {});
    }, onDeviceUpdate: (dlnaDevice) {
      print('update ' + dlnaDevice.toString());
      setState(() {});
    }, onSearchError: (error) {
      print('error ' + error);
    }, onPlayProgress: (positionInfo) {
      print(_time2Str(DateTime.now().millisecondsSinceEpoch) +
          ' current play progress ' +
          positionInfo.relTime);
    }));
    // 开始搜索
    dlnaManager.startSearch();
    setState(() {});
  }

  play(index) async {
    //选择设备
    _dlnaDevice = _devices[index];
    dlnaManager.setDevice(_dlnaDevice);
    //设置链接
    var result = await dlnaManager.actSetVideoUrl(_didlObject);
    if (!result.success) {
      myToast('投屏失败');
      Navigator.pop(context);
    }
    //播放
    var re = await dlnaManager.actPlay();
    if (!re.success) {
      myToast('投屏失败');
      Navigator.pop(context);
    }
    myToast('投屏成功');
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
    dlnaManager?.release(); //关闭连接
  }

  @override
  Widget build(BuildContext context) {
    var flag = screenHeight <= screenWidth;
    return Scaffold(
      backgroundColor: Colors.black54,
      body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            color: Colors.black54,
            child: Stack(
              children: <Widget>[
                //body
                Align(
                  alignment: Alignment.center,
                  child: Material(
                      borderRadius: BorderRadius.circular(screenWidth / 20),
                      child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {},
                          child: Container(
                            width:
                                (flag ? screenHeight * 1 : screenWidth) * 0.8,
                            height: (flag ? screenHeight * 0.8 : screenWidth) *
                                (0.8 / 9 * 11),
                            padding: EdgeInsets.all(
                                (flag ? screenHeight : screenWidth) / 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(screenWidth / 20)),
                            child: Column(
                              children: <Widget>[
                                myText('投屏', big: FontWeight.bold),
                                Container(
                                  padding: EdgeInsets.all(
                                      (flag ? screenHeight : screenWidth) / 20),
                                  child: Text(
                                    "*请选择一个要投屏的设备",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: searching || _devices.length < 1
                                        ? searchW()
                                        : ListView.builder(
                                            padding: EdgeInsets.zero,
                                            physics: BouncingScrollPhysics(),
                                            itemCount: _devices.length,
                                            itemBuilder: (_, index) {
                                              return GestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                onTap: () async {
                                                  await play(index);
                                                },
                                                child: ListTile(
                                                  title: Text(
                                                    _devices[index].deviceName,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  trailing: myIcon(
                                                      Icons.play_circle_filled,
                                                      colorIcon: Colors.yellow,
                                                      onTap: () async {
                                                    await play(index);
                                                  }),
                                                ),
                                              );
                                            })),
                                SizedBox(
                                    height:
                                        (flag ? screenHeight : screenWidth) /
                                            20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    myRoundButton('取消', onTap: () {
                                      Navigator.pop(context);
                                    },
                                        colorText: Colors.red,
                                        size: 16,
                                        height: 36),
                                    myRoundButton('确定', onTap: () {
                                      Navigator.pop(context);
                                    },
                                        colorText: Colors.blue,
                                        size: 16,
                                        height: 36)
                                  ],
                                )
                              ],
                            ),
                          ))),
                ),
              ],
            ),
          )),
    );
  }

  Widget searchW() {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(),
            ),
            SizedBox(height: 30),
            Text(
              '搜索中...',
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }

  String _time2Str(int intTime) {
    var time = DateTime.fromMillisecondsSinceEpoch(intTime);
    return "${time.year.toString()}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
  }
}
