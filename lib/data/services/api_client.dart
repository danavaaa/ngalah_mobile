import 'package:dio/dio.dart';
import '../../core/config.dart';
import 'auth_storage.dart';

class ApiClient {
  ApiClient._();
  static final ApiClient I = ApiClient._(); //

  late final Dio dio = Dio(
      BaseOptions(
        // konfigurasi dasar untuk Dio
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 20), // waktu tunggu koneksi
        receiveTimeout: const Duration(
          seconds: 20,
        ), // waktu tunggu penerimaan data
        responseType: ResponseType.json, // tipe respons yang diharapkan
        headers: {
          'Accept': 'application/json',
        }, // header standar untuk semua permintaan
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
          // menangani error
          return handler.next(e); // teruskan error
        },
      ),
    );
}
