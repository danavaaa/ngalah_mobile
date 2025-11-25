import 'package:flutter/material.dart';
import '../../data/models/topup_va.dart';
import '../../data/services/isi_saldo_service.dart';
import 'isi_saldo_konfirm.dart';

const Color kGreen = Color(0xFF0C4E1A);
const Color kLightTile = Color(0xFFE3F6E7);

class IsiSaldoScreen extends StatefulWidget {
  const IsiSaldoScreen({super.key});

  @override
  State<IsiSaldoScreen> createState() => _IsiSaldoScreenState();
}

class _IsiSaldoScreenState extends State<IsiSaldoScreen> {
  final TextEditingController _nominalController = TextEditingController(
    text: '0',
  );

  int? _selectedAmountIndex;
  int? _selectedBankIndex;

  // NOMINAL CEPAT
  final List<int> _presetAmounts = [
    50000,
    100000,
    200000,
    300000,
    500000,
    1000000,
  ];

  // DATA BANK + LOGO
  final List<_BankOption> _banks = const [
    _BankOption(
      name: 'Bank Negara Indonesia',
      code: 'BNI',
      adminFee: 2500,
      logoPath: 'assets/images/bni.png',
    ),
    _BankOption(
      name: 'Bank Rakyat Indonesia',
      code: 'BRI',
      adminFee: 0,
      logoPath: 'assets/images/bri.png',
    ),
    _BankOption(
      name: 'Bank Syariah Indonesia',
      code: 'BSI',
      adminFee: 2000,
      logoPath: 'assets/images/bsi.png',
    ),
  ];

  @override
  void dispose() {
    _nominalController.dispose();
    super.dispose();
  }

  void _setPresetAmount(int index) {
    setState(() {
      _selectedAmountIndex = index;
      final value = _presetAmounts[index];
      _nominalController.text = value.toString();
    });
  }

  Future<void> _onConfirm() async {
    final nominal =
        int.tryParse(_nominalController.text.replaceAll('.', '')) ?? 0;

    if (nominal <= 0 || _selectedBankIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Isi nominal dan pilih bank terlebih dahulu'),
        ),
      );
      return;
    }

    final selectedBank = _banks[_selectedBankIndex!];

    // dialog loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final service = IsiSaldoService();

      // PANGGIL SERVICE (nanti tinggal diganti ke API asli)
      final TopupVa data = await service.createTopup(
        nominal: nominal,
        bankCode: selectedBank.code,
      );

      if (!mounted) return;
      Navigator.pop(context); // tutup dialog loading

      // PINDAH KE HALAMAN KONFIRMASI + KIRIM DATA
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => IsiSaldoKonfirmScreen(topup: data)),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // tutup dialog kalau error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal membuat topup: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kGreen,
        foregroundColor: Colors.white,
        title: const Text('Isi Saldo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Masukkan Nominal Pengisian Saldo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),

            // INPUT NOMINAL
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text(
                    'Rp. ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _nominalController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      onChanged: (_) {
                        setState(() {
                          _selectedAmountIndex = null;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // NOMINAL CEPAT : 3 kolom × 2 baris
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.6,
              children: List.generate(_presetAmounts.length, (index) {
                final amount = _presetAmounts[index];
                final isSelected = _selectedAmountIndex == index;

                return GestureDetector(
                  onTap: () => _setPresetAmount(index),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? kGreen : kLightTile,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      _formatPresetLabel(amount),
                      style: TextStyle(
                        color: isSelected ? Colors.white : kGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            // PILIH METODE TRANSFER
            const Text(
              'Pilih Metode Transfer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Transfer Bank / Virtual Account',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // CARD LIST BANK
                  Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: List.generate(_banks.length, (index) {
                        final bank = _banks[index];
                        final isSelected = _selectedBankIndex == index;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedBankIndex = index;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? kLightTile.withOpacity(0.6)
                                      : Colors.white,
                              borderRadius:
                                  index == 0
                                      ? const BorderRadius.vertical(
                                        top: Radius.circular(8),
                                      )
                                      : index == _banks.length - 1
                                      ? const BorderRadius.vertical(
                                        bottom: Radius.circular(8),
                                      )
                                      : null,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                // LOGO BANK
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.grey.shade200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.asset(
                                      bank.logoPath,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bank.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Biaya admin Rp. ${_formatRupiah(bank.adminFee)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                if (isSelected)
                                  const Icon(Icons.check_circle, color: kGreen),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Konfirmasi',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatPresetLabel(int amount) {
    if (amount == 1000000) return '1 jt';
    if (amount >= 1000) {
      return '${amount ~/ 1000} rb';
    }
    return amount.toString();
  }

  String _formatRupiah(int nominal) {
    // 450000 -> 450.000
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

    return buffer.toString().split('').reversed.join();
  }
}

class _BankOption {
  final String name;
  final String code;
  final int adminFee;
  final String logoPath;

  const _BankOption({
    required this.name,
    required this.code,
    required this.adminFee,
    required this.logoPath,
  });
}
