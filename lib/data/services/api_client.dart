import 'package:dio/dio.dart';
import '../../core/config.dart';
import 'auth_storage.dart';

class ApiClient {
  ApiClient._();
  static final ApiClient I = ApiClient._();

  late final Dio dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        responseType: ResponseType.json,
        headers: {'Accept': 'application/json'},
      ),
    )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await AuthStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (e, handler) {
          // logging sederhana
          // print('API ERROR: ${e.response?.statusCode} ${e.message}');
          return handler.next(e);
        },
      ),
    );
}
