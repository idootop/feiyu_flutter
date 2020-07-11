import 'package:dio/dio.dart';

class Http {
  Dio dio;
  BaseOptions options;

  Http() {
    options = new BaseOptions(
        contentType: "application/x-www-form-urlencoded",
        responseType: ResponseType.plain, //以文本方式接收数据
        headers: {
          // 'User-Agent':
          //     'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.18362'
        });

    dio = new Dio(options);

    //添加拦截器
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      // print("-----开始请求-----");
      return options;
    }, onResponse: (Response response) {
      // print("-----开始响应-----");
      return response;
    }, onError: (DioError e) {
      // print("-----发生错误-----");
      return e;
    }));
  }

  /*
   * get请求
   */
  Future<String> get(url, {data, options}) async {
    dio.options.responseType = ResponseType.plain;
    dio.options.contentType = "application/x-www-form-urlencoded";
    try {
      Response response =
          await dio.get(url, queryParameters: data, options: options);
      return response.data.toString();
    } on DioError catch (e) {
      if (e != null && e.response != null) {
        if (e.response.statusCode == 301) {
          var re = await get(e.response.headers['location'][0],
              options: options, data: data);
          return re;
        }
        if (e.response.statusCode == 302) {
          var re = await get(e.response.headers['location'][0],
              options: options, data: data);
          return re;
        }
      }
      return formatError(e);
    }
  }

  /*
   * post请求
   */
  Future<String> post(url, {data, options}) async {
    dio.options.responseType = ResponseType.plain;
    dio.options.contentType = "application/x-www-form-urlencoded";
    try {
      Response response =
          await dio.post(url, queryParameters: data, options: options);
      return response.data.toString();
    } on DioError catch (e) {
      if (e != null && e.response != null) {
        if (e.response.statusCode == 301) {
          var re = await post(e.response.headers['location'][0],
              options: options, data: data);
          return re;
        }
        if (e.response.statusCode == 302) {
          var re = await post(e.response.headers['location'][0],
              options: options, data: data);
          return re;
        }
      }
      return formatError(e);
    }
  }

  /*
   * 下载文件
   */
  Future<bool> download(String urlPath, String savePath,
      {void Function(int, int) progress}) async {
    try {
      double before = 0;
      await dio.download(urlPath, savePath,
          options: Options(receiveTimeout: 0),
          onReceiveProgress: progress ??
              (int count, int total) {
                double position = (count / total) * 100;
                if (position - before > 5) {
                  print('下载进度---> ${position.round()}% ');
                  before = position;
                }
              });
      return true;
    } on DioError {
      return false;
    }
  }

  /*
   * error统一处理
   */
  String formatError(DioError e) {
    return "请求失败";
  }
}
