import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'http_url.dart';
import '../httpRequest/http_url.dart';
import '../httpRequest/https_untils.dart';
import 'package:cookie_jar/cookie_jar.dart';

class ShopPaperImgDao2 {
// 上传图片
  static Future uploadHttp(String url,formData) async {
    Response response;
    Dio dio = Dio();
    print('开始获取数据....');
    try {
      dio.interceptors.add(CookieManager(CookieJar()));
      response = await dio.post(servicePath[url], data: formData);
    } on DioError catch (e) {
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        print('连接超时');
      } else if (e.type == DioErrorType.SEND_TIMEOUT) {
        print("请求超时");
      } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
        //它在接收超时时发生
        print("响应超时");
      } else if (e.type == DioErrorType.RESPONSE) {
        // 当服务器响应，但状态不正确，如404,503…
        print("出现异常");
      } else if (e.type == DioErrorType.CANCEL) {
        // 当请求被取消时，dio将抛出此类型的错误。
        print("请求取消");
      } else {
        //默认默认错误类型，其他一些错误。在这种情况下，可以读取DioError。如果不是空，则为错误。
        print("未知错误");
      }
    }
    print("response == ${response}");
    return response.data;
  }
}