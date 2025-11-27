import 'package:flutter/material.dart';
import '../../data/models/upt_tagihan.dart';
import 'isi_saldo_screen.dart';
import 'sisda_dashboard_screen.dart';

const Color kGreen = Color(0xFF0C4E1A);

class MetodePembayaranScreen extends StatelessWidget {
  final List<UptTagihan> tagihanDipilih;
  final int totalTagihan;
  final int saldoNgalah;

  const MetodePembayaranScreen({
    super.key,
    required this.tagihanDipilih,
    required this.totalTagihan,
    required this.saldoNgalah,
  });

  @override
  Widget build(BuildContext context) {
    final bool saldoCukup = saldoNgalah >= totalTagihan;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: kGreen,
        foregroundColor: Colors.white,
        title: const Text('Metode Pembayaran'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildTotalTagihanCard(),
          const SizedBox(height: 16),
          _buildSaldoCardSection(context, saldoCukup),
          const Spacer(),
        ],
      ),
      bottomNavigationBar: _buildBottomButton(context, saldoCukup),
    );
  }

  Future<void> _onConfirmPressed(BuildContext context, bool saldoCukup) async {
    if (!saldoCukup) return;

    // 1. Tampilkan dialog sukses
    final bool? ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Pembayaran Berhasil'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
              child: const Text(
                'Kembali ke Dashboard',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );

    // 2. Kalau user menekan "Kembali ke Dashboard"
    if (ok == true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SisdaDashboardScreen()),
        (route) => false,
      );
    }
  }

  // TOTAL TAGIHAN

  Widget _buildTotalTagihanCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                const Text('Total Tagihan', style: TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  _formatRupiah(totalTagihan),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tagihanDipilih.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = tagihanDipilih[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.bulanLabel.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      _formatRupiah(item.nominal),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // SALDO NGALAH MOBILE

  Widget _buildSaldoCardSection(BuildContext context, bool saldoCukup) {
    if (!saldoCukup) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Saldo Ngalah Mobile',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Saldo tidak mencukupi',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const IsiSaldoScreen()),
                );
              },
              icon: const Icon(Icons.add_circle_outline, color: kGreen),
              label: const Text('Isi saldo', style: TextStyle(color: kGreen)),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kGreen, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Saldo Ngalah Mobile',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Saldo ${_formatRupiah(saldoNgalah)}',
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
          const Icon(Icons.check_circle, color: kGreen, size: 28),
        ],
      ),
    );
  }

  // BUTTON KONFIRMASI

  Widget _buildBottomButton(BuildContext context, bool saldoCukup) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: ElevatedButton(
          onPressed:
              saldoCukup ? () => _onConfirmPressed(context, saldoCukup) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: saldoCukup ? kGreen : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
          ),
          child: const Text(
            'Konfirmasi',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }

  // UTIL

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
