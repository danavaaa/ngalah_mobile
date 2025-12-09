import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/sisda_provider.dart';
import '../../data/models/topup_va.dart';
import '../../data/services/topup_cache_service.dart';

import 'isi_saldo_screen.dart';
import 'isi_saldo_konfirm.dart';
import 'riwayat_transaksi_screen.dart';
import 'bayar_tagihan_screen.dart';
import 'pagu_screen.dart';

const Color kGreen = Color(0xFF0C4E1A);
const Color kCardGreen = Color(0xFF2E6C3E);
const Color kLightTile = Color(0xFFE3F6E7);

class SisdaDashboardScreen extends StatefulWidget {
  const SisdaDashboardScreen({super.key});

  @override
  State<SisdaDashboardScreen> createState() => _SisdaDashboardScreenState();
}

class _SisdaDashboardScreenState extends State<SisdaDashboardScreen> {
  Future<TopupVa?>? _activeTopupFuture;

  @override
  void initState() {
    super.initState();
    _refreshActiveTopup();
  }

  void _refreshActiveTopup() {
    setState(() {
      _activeTopupFuture = TopupCacheService().getActiveTopup();
    });
  }

  bool _isActiveTopupValid(TopupVa? t) =>
      t != null && t.expiredAt.isAfter(DateTime.now());

  String _formatRupiah(int nominal) {
    final text = nominal.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = text.length - 1; i >= 0; i--) {
      buffer.write(text[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write('.');
        count = 0;
      }
    }
    return 'Rp. ${buffer.toString().split('').reversed.join()}';
  }

  String _formatExpiredFromNow(DateTime expiredAt) {
    final diff = expiredAt.difference(DateTime.now());
    if (diff.isNegative) return 'Kadaluarsa';
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    return '${hours}j ${minutes}m';
  }

  void _showSuccessSnackBar(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Buka halaman konfirmasi VA (dari banner kuning / dari flow isi saldo)
  /// lalu handle result (deleted => snackbar + refresh)
  Future<void> _openActiveTopup(TopupVa topup) async {
    final result = await Navigator.push<TopupCloseResult>(
      context,
      MaterialPageRoute(builder: (_) => IsiSaldoKonfirmScreen(topup: topup)),
    );
    // setelah balik dari halaman topup, refresh lagi (bisa jadi dihapus/expired)
    _refreshActiveTopup();

    if (!mounted) return;

    if (result == TopupCloseResult.deleted) {
      _showSuccessSnackBar('Pembayaran berhasil di batalkan');
    }
  }

  /// Tap menu Isi Saldo:
  /// - kalau masih ada VA aktif => tampilkan dialog putih (tidak boleh isi saldo lagi)
  /// - kalau tidak ada => masuk IsiSaldoScreen
  Future<void> _handleIsiSaldoTap(BuildContext context) async {
    final active = await TopupCacheService().getActiveTopup();

    if (_isActiveTopupValid(active)) {
      if (!context.mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false, // hanya bisa ditutup lewat X
        barrierColor: Colors.black.withOpacity(0.15),
        builder:
            (ctx) => VaActiveInfoDialog(onClose: () => Navigator.of(ctx).pop()),
      );
      return;
    }

    // tidak ada VA aktif -> lanjut Isi Saldo
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const IsiSaldoScreen()),
    );
    _refreshActiveTopup();
  }

  @override
  Widget build(BuildContext context) {
    final sisda = context.watch<SisdaProvider>();
    final account = sisda.currentAccount;

    final idYayasan = account?.iduser ?? '21010101'; // dari API: iduser
    final nomorWA = account?.telepon ?? '085123456789';
    final nama = account?.nama ?? 'DARUT TAQWA';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kGreen,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text('Ngalah Mobile', style: TextStyle(fontSize: 16)),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Profil',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              color: kGreen,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FOTO PROFIL
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.person, size: 45, color: kGreen),
                  ),
                  const SizedBox(width: 15),

                  // DATA SISWA
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          idYayasan,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          nama,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          nomorWA,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // CARD UTAMA
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
              decoration: BoxDecoration(
                color: kGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  // SALDO & TAGIHAN
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 110,
                          decoration: BoxDecoration(
                            color: kCardGreen,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Saldo",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.info_outline,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Rp. 2.000.000",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 110,
                          decoration: BoxDecoration(
                            color: kCardGreen,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Tagihan",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.info_outline,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Rp. 1.200.000",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // MENU 4 FITUR DI DALAM CARD
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ISI SALDO
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _handleIsiSaldoTap(context),
                          child: _topMenuItem(
                            Icons.add_box_outlined,
                            "Isi Saldo",
                          ),
                        ),
                      ),

                      // RIWAYAT
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RiwayatTransaksiScreen(),
                              ),
                            );
                          },
                          child: _topMenuItem(Icons.receipt_long, "Riwayat"),
                        ),
                      ),

                      // BAYAR
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BayarTagihanScreen(),
                              ),
                            );
                          },
                          child: _topMenuItem(Icons.payments_outlined, "Bayar"),
                        ),
                      ),

                      // PAGU
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PaguScreen(),
                              ),
                            );
                          },
                          child: _topMenuItem(
                            Icons.description_outlined,
                            "Pagu",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // GRID 8 FITUR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 20,
                crossAxisSpacing: 15,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 0.7,
                children: const [
                  _FeatureItem(icon: Icons.school, label: "Pendidikan"),
                  _FeatureItem(icon: Icons.access_time, label: "Absensi"),
                  _FeatureItem(icon: Icons.article, label: "Raport"),
                  _FeatureItem(icon: Icons.campaign, label: "Pengumuman"),
                  _FeatureItem(icon: Icons.bed, label: "Perizinan"),
                  _FeatureItem(
                    icon: Icons.restaurant_menu,
                    label: "Kupon Makan",
                  ),
                  _FeatureItem(
                    icon: Icons.account_balance_wallet,
                    label: "Tarik Tunai",
                  ),
                  _FeatureItem(
                    icon: Icons.manage_accounts,
                    label: "Atur Uang Saku",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // BANNER TOPUP AKTIF
            FutureBuilder<TopupVa?>(
              future: _activeTopupFuture,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }

                final topup = snap.data;
                if (!_isActiveTopupValid(topup)) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => _openActiveTopup(topup),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6D58B),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet_outlined,
                              color: kGreen,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Anda Memiliki Virtual Account Active',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${topup!.bankCode} • ${_formatRupiah(topup.totalTransfer)} • Exp ${_formatExpiredFromNow(topup.expiredAt)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.chevron_right,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET 4 MENU
  Widget _topMenuItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 30, color: Colors.white),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: kLightTile,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, size: 32, color: kGreen),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: kGreen,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Dialog putih VA aktif
class VaActiveInfoDialog extends StatelessWidget {
  final VoidCallback onClose;

  const VaActiveInfoDialog({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  'ada Virtual Account pembayaran Active, silahkan selesaikan pembayaran atau hapus VA aktif',
                  style: TextStyle(fontSize: 13, height: 1.3),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: onClose,
                borderRadius: BorderRadius.circular(30),
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.close, size: 18, color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
