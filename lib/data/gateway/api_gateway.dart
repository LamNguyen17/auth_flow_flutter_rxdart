import 'package:dio/dio.dart';

import 'package:auth_flow_flutter_rxdart/di/injection.dart';
import 'package:auth_flow_flutter_rxdart/data/mocks/api_mock.dart';
import 'package:auth_flow_flutter_rxdart/data/common/helper/flavor_config.dart';

class ApiGateway {
  // final apiMock = injector.get<ApiMock>();

  var dio = Dio();
  static String baseUrl = FlavorConfig.instance.values.baseUrl;

  ApiGateway() {
    dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    dio.interceptors.add(InterceptorsWrapper(onRequest:
        (RequestOptions requestOptions, RequestInterceptorHandler handler) async {
      handler.next(requestOptions);
    }, onError: (DioError err, ErrorInterceptorHandler handler) async {
      if (err.response?.statusCode == 401) {
        handler.reject(err);
      } else {
        handler.reject(err);
      }
    }));
  }

  // get(String path) {
  //   if (apiMock.isMockEnabled(path)) {
  //     return apiMock.mockData(path);
  //   }
  //   return dio.get(path);
  // }
}