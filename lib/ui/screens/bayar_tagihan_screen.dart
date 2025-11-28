import 'package:flutter/material.dart';

import '../../data/models/upt_tagihan.dart';
import '../../data/services/upt_tagihan_service.dart';
import '../../data/models/non_upt_tagihan.dart';
import '../../data/services/non_upt_tagihan_service.dart';
import 'metode_pembayaran_screen.dart';

const Color kGreen = Color(0xFF0C4E1A);

class BayarTagihanScreen extends StatefulWidget {
  const BayarTagihanScreen({super.key});

  @override
  State<BayarTagihanScreen> createState() => _BayarTagihanScreenState();
}

class _BayarTagihanScreenState extends State<BayarTagihanScreen> {
  // SERVICE
  final UptTagihanService _uptService = UptTagihanService();
  final NonUptTagihanService _nonUptService = NonUptTagihanService();

  int _selectedTabIndex = 0; // 0 = UPT, 1 = NON-UPT

  // STATE UPT
  bool _isLoadingUpt = true;
  String? _errorUpt;
  List<UptTagihan> _uptTagihan = [];
  final Set<String> _selectedUptIds = {};

  // STATE NON-UPT
  bool _isLoadingNonUpt = true;
  String? _errorNonUpt;
  List<NonUptTagihan> _nonUptTagihan = [];
  final Set<String> _selectedNonUptIds = {};

  @override
  void initState() {
    super.initState();
    _loadUpt();
    _loadNonUpt();
  }

  Future<void> _loadUpt() async {
    setState(() {
      _isLoadingUpt = true;
      _errorUpt = null;
    });

    try {
      final data = await _uptService.fetchUptTagihan();
      setState(() {
        _uptTagihan = data;
        _isLoadingUpt = false;
      });
    } catch (e) {
      setState(() {
        _errorUpt = 'Gagal memuat tagihan UPT: $e';
        _isLoadingUpt = false;
      });
    }
  }

  Future<void> _loadNonUpt() async {
    setState(() {
      _isLoadingNonUpt = true;
      _errorNonUpt = null;
    });

    try {
      final data = await _nonUptService.fetchNonUptTagihan();
      setState(() {
        _nonUptTagihan = data;
        _isLoadingNonUpt = false;
      });
    } catch (e) {
      setState(() {
        _errorNonUpt = 'Gagal memuat tagihan NON-UPT: $e';
        _isLoadingNonUpt = false;
      });
    }
  }

  /// total rupiah yang dipilih di tab aktif
  int get _totalSelected {
    if (_selectedTabIndex == 0) {
      int sum = 0;
      for (final t in _uptTagihan) {
        if (_selectedUptIds.contains(t.id)) {
          sum += t.nominal;
        }
      }
      return sum;
    } else {
      int sum = 0;
      for (final t in _nonUptTagihan) {
        if (_selectedNonUptIds.contains(t.id)) {
          sum += t.nominal;
        }
      }
      return sum;
    }
  }

  // UI
  @override
  Widget build(BuildContext context) {
    final bool isLoading =
        _selectedTabIndex == 0 ? _isLoadingUpt : _isLoadingNonUpt;
    final String? error = _selectedTabIndex == 0 ? _errorUpt : _errorNonUpt;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: kGreen,
        foregroundColor: Colors.white,
        title: const Text('Bayar Tagihan'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _buildTabSwitch(),
          const SizedBox(height: 8),
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : error != null
                    ? Center(child: Text(error))
                    : _selectedTabIndex == 0
                    ? _buildUptList()
                    : _buildNonUptList(),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  // TAB UPT / NON-UPT
  Widget _buildTabSwitch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            // BUTTON UPT
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTabIndex = 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color:
                        _selectedTabIndex == 0 ? kGreen : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'UPT',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _selectedTabIndex == 0 ? Colors.white : kGreen,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // BUTTON NON-UPT
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTabIndex = 1),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color:
                        _selectedTabIndex == 1 ? kGreen : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'NON-UPT',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _selectedTabIndex == 1 ? Colors.white : kGreen,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // LIST UPT
  Widget _buildUptList() {
    if (_uptTagihan.isEmpty) {
      return const Center(child: Text('Belum ada tagihan UPT'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _uptTagihan.length,
      itemBuilder: (context, index) {
        final item = _uptTagihan[index];
        final selected = _selectedUptIds.contains(item.id);
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: selected,
                onChanged: (v) {
                  setState(() {
                    if (v == true) {
                      _selectedUptIds.add(item.id);
                    } else {
                      _selectedUptIds.remove(item.id);
                    }
                  });
                },
              ),
              Expanded(child: _buildUptCard(item)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUptCard(UptTagihan item) {
    // jika sudah lewat jatuh tempo -> merah muda, kalau belum -> putih
    final Color bgColor =
        item.isWarning ? const Color(0xFFFFC1C1) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // kiri: bulan + jatuh tempo
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.bulanLabel,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(item.jatuhTempoLabel, style: const TextStyle(fontSize: 13)),
            ],
          ),
          // kanan: nominal
          Text(
            _formatRupiah(item.nominal),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // NON-UPT PLACEHOLDER
  Widget _buildNonUptList() {
    if (_nonUptTagihan.isEmpty) {
      return const Center(child: Text('Belum ada tagihan NON-UPT'));
    }

    final nonCicilan = _nonUptTagihan.where((t) => !t.isCicilan).toList();
    final cicilan = _nonUptTagihan.where((t) => t.isCicilan).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      children: [
        if (nonCicilan.isNotEmpty) ...[
          const Text(
            'Tagihan Non Cicilan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...nonCicilan.map(_buildNonUptRow),
          const SizedBox(height: 24),
        ],
        if (cicilan.isNotEmpty) ...[
          const Text(
            'Tagihan Cicilan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...cicilan.map(_buildNonUptRow),
        ],
      ],
    );
  }

  Widget _buildNonUptRow(NonUptTagihan item) {
    final selected = _selectedNonUptIds.contains(item.id);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: selected,
            onChanged: (v) {
              setState(() {
                if (v == true) {
                  _selectedNonUptIds.add(item.id);
                } else {
                  _selectedNonUptIds.remove(item.id);
                }
              });
            },
          ),
          Expanded(child: _buildNonUptCard(item)),
        ],
      ),
    );
  }

  Widget _buildNonUptCard(NonUptTagihan item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // kiri: judul + subtitle
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(item.subtitleLabel, style: const TextStyle(fontSize: 13)),
            ],
          ),
          // kanan: nominal
          Text(
            _formatRupiah(item.nominal),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // FOOTER (TOTAL + BAYAR)
  Widget _buildFooter() {
    final total = _totalSelected;
    final canPay = total > 0;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Jumlah tagihan yang dipilih:',
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 48,
            child: Row(
              children: [
                // nominal
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: kGreen,
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(24),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _formatRupiah(total),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(width: 1, color: Colors.white),

                // tombol Bayar
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap:
                        canPay
                            ? () {
                              if (_selectedTabIndex == 0) {
                                // UPT → kirim ke MetodePembayaranScreen
                                final selectedBills =
                                    _uptTagihan
                                        .where(
                                          (t) => _selectedUptIds.contains(t.id),
                                        )
                                        .toList();

                                // sementara: contoh saldo 2.000.000
                                const int saldoNgalahContoh = 2000000;

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => MetodePembayaranScreen(
                                          tagihanDipilih: selectedBills,
                                          totalTagihan: total,
                                          saldoNgalah: saldoNgalahContoh,
                                        ),
                                  ),
                                );
                              } else {
                                // NON-UPT
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Pembayaran NON-UPT belum diimplementasikan',
                                    ),
                                  ),
                                );
                              }
                            }
                            : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: canPay ? kGreen : Colors.grey,
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(24),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Bayar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // FORMAT RUPIAH
  String _formatRupiah(int nominal) {
    if (nominal <= 0) return 'Rp. 0';
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
