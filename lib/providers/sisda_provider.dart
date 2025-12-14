import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../core/utils/random_token.dart';
import 'package:ngalah_mobile/data/services/pagu_service.dart';
import '../data/services/upt_tagihan_service.dart';
import '../data/models/upt_tagihan.dart';

// Model User Sisda
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
    // from API response
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

// Provider Sisda
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
  // GETTER DIO
  Dio get dio => _dio; // untuk akses Dio dari luar

  // STATE USER & LOGIN
  SisdaUser? _user;
  String? _error;
  bool _otpVerified = false;
  SisdaUser? get user => _user;
  String? get error => _error;
  bool get isLoggedIn => _user != null && _otpVerified == true;
  SisdaUser? get currentAccount => _user;
  // STATE SALDO
  int? _saldo; // dalam rupiah
  bool _saldoLoading = false;
  String? _saldoError;

  int? get saldo => _saldo;
  bool get saldoLoading => _saldoLoading;
  String? get saldoError => _saldoError;
  // LOGIN
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

        // pastikan login_otp kebaca
        debugPrint("LOGIN OTP (from server): ${_user?.loginOtp}");
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

  //  Kirim OTP via WhatsApp
  Future<bool> sendWaOtp() async {
    _error = null;
    notifyListeners();
    // Pastikan user sudah login
    if (_user == null) {
      // belum login
      _error = "User belum login. Lakukan login dulu.";
      notifyListeners();
      return false;
    }
    // Ambil OTP dan nomor telepon
    final otp = _user!.loginOtp?.trim();
    final phone = _user!.telepon.trim();

    if (otp == null || otp.isEmpty) {
      // OTP kosong
      _error =
          "login_otp kosong. Pastikan login berhasil dan response berisi login_otp.";
      notifyListeners();
      return false;
    }
    if (phone.isEmpty) {
      // nomor telepon kosong
      _error = "Nomor telepon kosong.";
      notifyListeners();
      return false;
    }

    try {
      final res = await _dio.post(
        // kirim OTP via WA
        '/sandbox/auth/v1/wa',
        data: {"msg": otp, "telepon": phone},
      );

      debugPrint("WA OTP RESPONSE: ${res.data}");

      // Cek response
      final data = res.data;
      if (data is Map && data["success"] == false) {
        _error = data["data"]?.toString() ?? "Gagal kirim OTP";
        notifyListeners();
        return false;
      }
      // Berhasil kirim
      return true;
    } on DioException catch (e) {
      _error = e.response?.data?.toString() ?? e.message ?? "Request error";
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // VERIFIKASI OTP
  bool verifyOtpLocal(String inputOtp) {
    final serverOtp = _user?.loginOtp?.trim();
    if (serverOtp == null || serverOtp.isEmpty) return false;
    return inputOtp.trim() == serverOtp;
  }

  // Tandai OTP sudah terverifikasi
  void markOtpSuccess() {
    _otpVerified = true;
    _error = null;
    notifyListeners();
  }

  // AMBIL SALDO DARI API
  Future<void> loadSaldo() async {
    // pastikan sudah login
    if (_user == null) {
      _saldoError = "User belum login";
      notifyListeners();
      return;
    }

    // idperson = iduser (dari API)
    final idperson = _user!.iduser.trim();

    _saldoLoading = true;
    _saldoError = null;
    notifyListeners();
    // request saldo
    try {
      final res = await _dio.post(
        '/sandbox/duwit/v1/person_tes',
        data: {"idperson": idperson},
      );

      debugPrint("SALDO RESPONSE: ${res.data}");
      // proses response
      final data = res.data;
      if (data is Map && data["success"] == true && data["data"] is Map) {
        final inner = Map<String, dynamic>.from(data["data"]);

        final rawSaldo = inner["saldo"];
        _saldo =
            rawSaldo is int
                ? rawSaldo
                : int.tryParse(rawSaldo?.toString() ?? "0");
        // reset error
        _saldoError = null;
      } else {
        _saldoError = "Format response saldo tidak sesuai.";
      }
    } on DioException catch (e) {
      _saldoError =
          e.response?.data?.toString() ?? e.message ?? "Request error";
    } catch (e) {
      _saldoError = e.toString();
    } finally {
      _saldoLoading = false;
      notifyListeners();
    }
  }

  // AMBIL TAGIHAN NOMINAL DARI API
  int? tagihanNominal;
  bool tagihanLoading = false;
  String? tagihanError;
  // Hitung tagihan dari data pagu
  Future<void> loadTagihanFromPagu() async {
    tagihanLoading = true;
    tagihanError = null;
    notifyListeners();

    try {
      if (user == null) throw Exception("User belum login");

      final idperson = user!.iduser;
      final service = PaguService(dio);
      final items = await service.fetchPagu(idperson: idperson);

      final now = DateTime.now();

      // Tagihan = sudah jatuh tempo + belum lunas
      final filtered = items.where((p) {
        final today = DateTime(now.year, now.month, now.day);
        final due = DateTime(
          p.jatuhTempo.year,
          p.jatuhTempo.month,
          p.jatuhTempo.day,
        );

        final sudahJatuhTempo = !due.isAfter(today); // due <= today
        final belumLunas = p.terbayar < p.tagihan;

        return sudahJatuhTempo && belumLunas;
      });
      // Hitung total tagihan
      final totalTagihan = filtered.fold<int>(0, (sum, p) => sum + p.sisa);
      // Simpan hasil
      tagihanNominal = totalTagihan;
    } catch (e) {
      tagihanError = e.toString();
      tagihanNominal = null;
    } finally {
      tagihanLoading = false;
      notifyListeners();
    }
  }

  // UPT TAGIHAN
  List<UptTagihan> uptTagihanItems = [];
  bool uptTagihanLoading = false;
  String? uptTagihanError;

  // untuk checkbox
  final Set<String> selectedUptIds = {};
  // Ambil data UPT Tagihan dari API
  Future<void> loadUptTagihan() async {
    uptTagihanLoading = true;
    uptTagihanError = null;
    notifyListeners();
    // request data
    try {
      if (user == null) throw Exception("User belum login");
      final idperson = user!.iduser;

      final service = UptTagihanService(dio);
      final items = await service.fetchUptTagihan(idperson: idperson);

      // tampilkan yang masih ada sisa (belum lunas)
      uptTagihanItems = items.where((x) => x.sisa > 0).toList();

      // reset selection jika perlu
      selectedUptIds.removeWhere(
        (id) => !uptTagihanItems.any((x) => x.id == id),
      );
    } catch (e) {
      uptTagihanError = e.toString();
      uptTagihanItems = [];
      selectedUptIds.clear();
    } finally {
      uptTagihanLoading = false;
      notifyListeners();
    }
  }

  // Toggle pilihan UPT Tagihan
  void toggleUptSelected(String id) {
    if (selectedUptIds.contains(id)) {
      selectedUptIds.remove(id);
    } else {
      selectedUptIds.add(id);
    }
    notifyListeners();
  }

  // Hitung total UPT Dipilih
  int get totalUptDipilih {
    int sum = 0;
    for (final item in uptTagihanItems) {
      if (selectedUptIds.contains(item.id)) {
        sum += item.sisa; // sisa pembayaran
      }
    }
    return sum;
  }

  // LOGOUT
  void logout() {
    _user = null;
    _otpVerified = false;
    _error = null;

    // reset saldo juga
    _saldo = null;
    _saldoError = null;
    _saldoLoading = false;

    notifyListeners();
  }
}
