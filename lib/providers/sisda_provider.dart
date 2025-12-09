import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../core/utils/random_token.dart';

class SisdaUser {
  final String idu;
  final String iduser;
  final String nama;
  final String telepon;
  final String type;
  final String pin;
  final String loginToken;
  final String? loginOtp;
  SisdaUser({
    required this.idu,
    required this.iduser,
    required this.nama,
    required this.telepon,
    required this.type,
    required this.pin,
    required this.loginToken,
    this.loginOtp,
  });
  factory SisdaUser.fromJson(Map<String, dynamic> json) => SisdaUser(
    idu: (json['idu'] ?? '').toString(),
    iduser: (json['iduser'] ?? '').toString(),
    nama: (json['nama'] ?? '').toString(),
    telepon: (json['telepon'] ?? '').toString(),
    type: (json['type'] ?? '').toString(),
    pin: (json['pin'] ?? '').toString(),
    loginToken: (json['login_token'] ?? '').toString(),
    loginOtp: json['login_otp']?.toString(),
  );
}

class SisdaProvider extends ChangeNotifier {
  static const String _baseUrl = 'https://api.daruttaqwa.or.id';
  static const String _apiKey = '91566bf33986d88ec33b79b7797e58e2';
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Content-Type': 'application/json', 'Api': _apiKey},
    ),
  );
  SisdaProvider() {
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    );
  }
  SisdaUser? _user;
  String? _error;
  bool _otpVerified = false;
  SisdaUser? get user => _user;
  String? get error => _error;
  bool get isLoggedIn => _user != null && _otpVerified == true;
  SisdaUser? get currentAccount => _user;
  Future<bool> login({required String iduser, required String telepon}) async {
    _error = null;
    _otpVerified = false;
    notifyListeners();
    final loginToken = RandomToken.generate32();
    try {
      final res = await _dio.post(
        '/sandbox/auth/v1/login',
        data: {
          "iduser": iduser.trim(),
          "telepon": telepon.trim(),
          "login_token": loginToken,
        },
      );
      debugPrint("LOGIN RESPONSE: ${res.data}");
      final data = res.data;
      if (data is Map && data["success"] == true && data["data"] is Map) {
        _user = SisdaUser.fromJson(Map<String, dynamic>.from(data["data"]));
        notifyListeners();
        return true;
      }
      _user = null;
      _error = "Login gagal / format response tidak sesuai.";
      notifyListeners();
      return false;
    } on DioException catch (e) {
      _user = null;
      _error = e.response?.data?.toString() ?? e.message ?? "Request error";
      notifyListeners();
      return false;
    } catch (e) {
      _user = null;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void markOtpSuccess() {
    _otpVerified = true;
    _error = null;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _otpVerified = false;
    _error = null;
    notifyListeners();
  }
}
