import 'package:flutter/material.dart';

//封装图片加载控件，增加图片加载失败时加载默认图片
class MyImage extends StatefulWidget {
  final String url;
  final BoxFit fit;
  final Widget error;
  final Widget load;
  final double width;
  final double height;

  MyImage(this.url,
      {this.width,
      this.height,
      this.fit = BoxFit.cover,
      this.error = const Placeholder(),
      this.load = const Placeholder()});

  @override
  State<StatefulWidget> createState() {
    return _StateMyImage();
  }
}

class _StateMyImage extends State<MyImage> {
  Widget _image;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _image = widget.load;
    Image _imagex = Image.network(
      widget.url,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
    );
    var resolve = _imagex.image.resolve(ImageConfiguration.empty);
    resolve.addListener(ImageStreamListener((_, __) {
      //加载成功
      setState(() {
        _image = _imagex;
      });
    }, onChunk: (ImageChunkEvent event) {
      //加载中
      setState(() {
        _image = widget.load;
      });
    }, onError: (dynamic exception, StackTrace stackTrace) {
      //加载失败
      setState(() {
        _image = widget.error;
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return _image;
  }
}
