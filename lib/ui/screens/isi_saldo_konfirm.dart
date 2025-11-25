import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models/topup_va.dart';

const Color kGreen = Color(0xFF0C4E1A);

class IsiSaldoKonfirmScreen extends StatelessWidget {
  final TopupVa topup;

  const IsiSaldoKonfirmScreen({super.key, required this.topup});

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
            _infoTile('Total Pengisian', _formatRupiah(topup.nominal)),
            const SizedBox(height: 12),
            _infoTile('Selesaikan Transfer dalam', '23 jam 59 menit 59 detik'),
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
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: panggil API batal / hapus topup
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Hapus',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Tutup',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _vaCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
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
              color: Colors.green.shade100,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  topup.bankCode,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      topup.vaNumber,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: topup.vaNumber));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('VA disalin')),
                        );
                      },
                      child: const Text('Salin'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // detail bank
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              children: [
                _rowDetail('Bank Tujuan', topup.bankName),
                _rowDetail('Nama Tujuan', 'Nama Santri/Siswa'),
                _rowDetail(
                  'Nominal Pengisian Saldo',
                  _formatRupiah(topup.nominal),
                ),
                _rowDetail('Biaya Admin', _formatRupiah(topup.adminFee)),
              ],
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(8),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nominal Transfer',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  _formatRupiah(topup.totalTransfer),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value, textAlign: TextAlign.right)],
      ),
    );
  }

  Widget _simplePanel({required String title, required String content}) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
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
}
