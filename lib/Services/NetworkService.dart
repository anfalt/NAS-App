import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

const String apiURL = "https://anfalt.de";

class NetworkService {
  static Dio dio;
  static final CookieJar cookieJar = new CookieJar();

  static Dio getDioInstance() {
    if (NetworkService.dio == null) {
      NetworkService.dio = NetworkService.initDio();
    }
    return NetworkService.dio;
  }

  static Dio initDio() {
    var dioInst = Dio(BaseOptions(baseUrl: apiURL));
    dioInst.interceptors.add(CookieManager(NetworkService.cookieJar));
    return dioInst;
  }
}
