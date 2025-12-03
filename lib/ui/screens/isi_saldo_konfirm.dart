import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models/topup_va.dart';

const Color kGreen = Color(0xFF0C4E1A);

class IsiSaldoKonfirmScreen extends StatefulWidget {
  final TopupVa topup;

  const IsiSaldoKonfirmScreen({super.key, required this.topup});

  @override
  State<IsiSaldoKonfirmScreen> createState() => _IsiSaldoKonfirmScreenState();
}

class _IsiSaldoKonfirmScreenState extends State<IsiSaldoKonfirmScreen> {
  Timer? _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();

    _remaining = widget.topup.expiredAt.difference(DateTime.now());
    if (_remaining.isNegative) _remaining = Duration.zero;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final diff = widget.topup.expiredAt.difference(DateTime.now());
      if (!mounted) return;

      setState(() {
        _remaining = diff.isNegative ? Duration.zero : diff;
      });

      if (_remaining == Duration.zero) {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatCountdown(Duration d) {
    if (d == Duration.zero) return 'Kadaluarsa';

    final totalSeconds = d.inSeconds;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    return '${hours.toString().padLeft(2, '0')} jam '
        '${minutes.toString().padLeft(2, '0')} menit '
        '${seconds.toString().padLeft(2, '0')} detik';
  }

  @override
  Widget build(BuildContext context) {
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
            _infoTileRow(
              'Total Pengisian',
              _formatRupiah(widget.topup.nominal),
            ),
            const SizedBox(height: 12),
            _infoTileRow(
              'Selesaikan Transfer dalam',
              _formatCountdown(_remaining),
            ),
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
            const SizedBox(height: 90),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Hapus',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // TUTUP (KEMBALI KE DASHBOARD SISDA)
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // tutup IsiSaldoKonfirm
                    Navigator.of(context).pop();
                    // tutup IsiSaldoScreen kembali ke SisdaDashboard
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Tutup',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET BANTUAN

  Widget _infoTileRow(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),

          Flexible(
            child: Align(
              alignment: Alignment.centerRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vaCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // header logo + VA
          Container(
            decoration: BoxDecoration(
              color: Colors.green.shade200.withOpacity(0.6),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Text(
                  widget.topup.bankCode,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.topup.vaNumber,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: widget.topup.vaNumber),
                    );
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('VA disalin')));
                  },
                  child: const Icon(Icons.copy, size: 18),
                ),
              ],
            ),
          ),

          // detail bank
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              children: [
                _rowDetailCenterValue('Bank Tujuan', widget.topup.bankName),
                _divider(),
                _rowDetailCenterValue('Nama Tujuan', 'Nama Santri/Siswa'),
                _divider(),
                _rowDetailCenterValue(
                  'Nominal Pengisian Saldo',
                  _formatRupiah(widget.topup.nominal),
                ),
                _divider(),
                _rowDetailCenterValue(
                  'Admin Bank',
                  _formatRupiah(widget.topup.adminFee),
                ),
              ],
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Colors.green.shade200.withOpacity(0.6),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                const Text(
                  'Nominal Transfer',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                const Spacer(),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _formatRupiah(widget.topup.totalTransfer),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowDetailCenterValue(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 6,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _divider() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Divider(height: 1),
  );

  Widget _simplePanel({required String title, required String content}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  // DIALOG KONFIRMASI HAPUS
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Konfirmasi',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          content: const Text(
            'Hapus transaksi Isi Saldo?',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'Hapus',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
              child: const Text(
                'Tidak',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatRupiah(int nominal) {
    final text = nominal.toString();
    String result = '';
    int count = 0;
    for (int i = text.length - 1; i >= 0; i--) {
      result = text[i] + result;
      count++;
      if (count == 3 && i != 0) {
        result = '.$result';
        count = 0;
      }
    }
    return 'Rp. $result';
  }
}
