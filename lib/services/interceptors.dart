import 'dart:io';
import 'dart:html';
import 'package:ecommerce_int2/services/auth.services.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CookieManager {
  static addToCookie(String key, String value) {
    document.cookie = "$key=$value;";
  }

  static String getCookie(String key, String cookies) {
    List<String> listValues = cookies.isNotEmpty ? cookies.split(";") : List();
    String matchVal = "";
    for (int i = 0; i < listValues.length; i++) {
      List<String> map = listValues[i].split("=");
      String _key = map[0].trim();
      String _val = map[1].trim();
      if (key == _key) {
        matchVal = _val;
        break;
      }
    }
    return matchVal;
  }
}

class JWTApiInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    try {
      String bearerToken = await storage.read(key: 'Bearer-Token');
      data.headers['Bearer-Token'] = bearerToken;
    } catch (e) {
      print(e);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    return data;
  }
}

class HttpClient {
  Client _client;
  _initClient() {
    if (_client == null) {
      _client = InterceptedClient.build(interceptors: [JWTApiInterceptor()]);
    }
  }

  HttpClient() {
    _initClient();
  }
}

Client http = new HttpClient()._client;
