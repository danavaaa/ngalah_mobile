import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models/topup_va.dart';
import '../../data/services/topup_cache_service.dart';

const Color kGreen = Color(0xFF0C4E1A);

enum TopupCloseResult { closed, deleted }

class IsiSaldoKonfirmScreen extends StatefulWidget {
  final TopupVa topup;

  const IsiSaldoKonfirmScreen({super.key, required this.topup});

  @override
  State<IsiSaldoKonfirmScreen> createState() => _IsiSaldoKonfirmScreenState();
}

class _IsiSaldoKonfirmScreenState extends State<IsiSaldoKonfirmScreen> {
  Timer? _timer;
  Duration _remain = Duration.zero;

  @override
  void initState() {
    super.initState();
    _syncRemaining();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _syncRemaining(),
    );
  }

  void _syncRemaining() {
    final diff = widget.topup.expiredAt.difference(DateTime.now());
    final next = diff.isNegative ? Duration.zero : diff;

    if (mounted) setState(() => _remain = next);

    if (next == Duration.zero) {
      _timer?.cancel();
      TopupCacheService().clearActiveTopup();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final total = d.inSeconds;
    final h = (total ~/ 3600);
    final m = ((total % 3600) ~/ 60);
    final s = (total % 60);
    return '${h.toString().padLeft(2, '0')} jam '
        '${m.toString().padLeft(2, '0')} menit '
        '${s.toString().padLeft(2, '0')} detik';
  }

  String _formatRupiah(int nominal) {
    final text = nominal.toString();
    String result = '';
    int count = 0;
    for (int i = text.length - 1; i >= 0; i--) {
      result = text[i] + result;
      count++;
      if (count == 3 && i != 0) {
        result = '.${result}';
        count = 0;
      }
    }
    return 'Rp. $result';
  }

  @override
  Widget build(BuildContext context) {
    final countdownText =
        _remain == Duration.zero ? 'Kadaluarsa' : _formatDuration(_remain);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreen,
        foregroundColor: Colors.white,
        title: const Text('Isi Saldo'),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _infoTile('Total Pengisian', _formatRupiah(widget.topup.nominal)),
            const SizedBox(height: 12),
            _infoTile('Selesaikan Transfer dalam', countdownText),
            const SizedBox(height: 16),

            // KARTU UTAMA VA
            _vaCard(context),

            const SizedBox(height: 16),

            // Panduan sederhana
            _simplePanel(
              title: 'Panduan Transfer',
              content:
                  '1. Lakukan transfer sesuai dengan jumlah Nominal Transfer di atas.\n'
                  '2. Biaya admin di atas adalah biaya admin untuk pembuatan VA (bukan admin transfer antar bank).\n'
                  '3. Ada kemungkinan penambahan biaya apabila transfer melalui rekening bank lain.',
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              // HAPUS
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _confirmDelete(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Hapus'),
                ),
              ),
              const SizedBox(width: 12),

              // TUTUP (KEMBALI KE DASHBOARD SISDA)
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // tutup IsiSaldoKonfirm
                    Navigator.pop(context, TopupCloseResult.closed);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // DIALOG KONFIRMASI HAPUS
  Future<void> _confirmDelete(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Hapus transaksi Isi Saldo?'),
          actions: [
            TextButton(
              onPressed: () async {
                await TopupCacheService().clearActiveTopup();
                if (!mounted) return;

                Navigator.of(dialogContext).pop(); // tutup dialog
                Navigator.pop(context, TopupCloseResult.deleted);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: const Text('Hapus'),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
              child: const Text('Tidak'),
            ),
          ],
        );
      },
    );
  }

  // WIDGET BANTUAN

  Widget _infoTile(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          const SizedBox(width: 10),
          Text(value),
        ],
      ),
    );
  }

  Widget _vaCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // header logo + VA
          Container(
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Text(widget.topup.bankCode),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.topup.vaNumber,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: widget.topup.vaNumber),
                    );
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('VA disalin')));
                  },
                  icon: const Icon(Icons.copy, size: 18),
                ),
              ],
            ),
          ),

          // detail bank
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _rowDetail('Bank Tujuan', widget.topup.bankName),
                _rowDetail('Nominal', _formatRupiah(widget.topup.nominal)),
                _rowDetail('Biaya Admin', _formatRupiah(widget.topup.adminFee)),
              ],
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                const Expanded(child: Text('Nominal Transfer')),
                Text(_formatRupiah(widget.topup.totalTransfer)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          const SizedBox(width: 10),
          Text(value),
        ],
      ),
    );
  }

  Widget _simplePanel({required String title, required String content}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(content),
        ],
      ),
    );
  }
}
