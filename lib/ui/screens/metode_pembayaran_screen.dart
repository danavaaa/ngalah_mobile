import 'package:flutter/material.dart';

import 'isi_saldo_screen.dart';

const Color kGreen = Color(0xFF0C4E1A);

class MetodePembayaranItem {
  final String title; // contoh: "Juli 2025" atau "UTS 1"
  final int nominal; // dalam rupiah

  MetodePembayaranItem({required this.title, required this.nominal});
}

class MetodePembayaranScreen extends StatelessWidget {
  final List<MetodePembayaranItem> items;
  final int totalTagihan;
  final int saldoNgalah;

  const MetodePembayaranScreen({
    super.key,
    required this.items,
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTotalCard(),
                    const SizedBox(height: 16),
                    _buildTableTagihan(),
                    const SizedBox(height: 24),
                    const Center(
                      child: Text(
                        'Pilih Metode Pembayaran',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSaldoCard(context, saldoCukup),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(context, saldoCukup),
    );
  }

  // WIDGET TOTAL TAGIHAN
  Widget _buildTotalCard() {
    return Container(
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
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          const Text('Total Tagihan', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            _formatRupiah(totalTagihan, prefix: 'IDR '),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // TOTAL TAGIHAN

  Widget _buildTableTagihan() {
    return Container(
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
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Pagu',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  'Nominal',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // List baris
          ...items.map(
            (item) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatRupiah(item.nominal, prefix: 'Rp. '),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // SALDO NGALAH MOBILE

  Widget _buildSaldoCard(BuildContext context, bool saldoCukup) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
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
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Kiri
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
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),

              // Kanan
              saldoCukup
                  ? const Icon(Icons.check_circle, color: kGreen, size: 26)
                  : Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Saldo tidak cukup',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Tombol isi saldo jika saldo tidak cukup
        if (!saldoCukup)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const IsiSaldoScreen()),
                );
              },
              icon: const Icon(Icons.add_circle_outline, color: kGreen),
              label: const Text('Isi saldo', style: TextStyle(color: kGreen)),
            ),
          ),
      ],
    );
  }

  // BUTTON KONFIRMASI
  Widget _buildBottomButton(BuildContext context, bool saldoCukup) {
    final bool canConfirm = saldoCukup; // tombol aktif kalau saldo cukup

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
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
              !canConfirm
                  ? null
                  : () async {
                    // Tampilkan dialog sukses
                    await showDialog<void>(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: const Text('Pembayaran Berhasil'),
                          content: const Text(
                            'Terima kasih, pembayaran anda sedang diproses.',
                          ),
                          actions: [
                            TextButton(
                              onPressed:
                                  () => Navigator.of(ctx).pop(), // tutup dialog
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );

                    // Setelah dialog tertutup, pop 2x:
                    Navigator.of(context).pop(); // tutup MetodePembayaranScreen
                    Navigator.of(
                      context,
                    ).pop(); // tutup BayarTagihanScreen -> kembali ke SisdaDashboard
                  },

          style: ElevatedButton.styleFrom(
            backgroundColor: canConfirm ? kGreen : Colors.grey,
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

  // FORMAT RUPIAH

  String _formatRupiah(int nominal, {String prefix = 'Rp. '}) {
    if (nominal <= 0) return '${prefix}0';

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

    return '$prefix$result';
  }
}
