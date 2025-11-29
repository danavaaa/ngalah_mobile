import 'package:flutter/material.dart';

import '../../data/models/pagu_item.dart';
import '../../data/services/pagu_service.dart';

const Color kGreen = Color(0xFF0C4E1A);

class PaguScreen extends StatefulWidget {
  const PaguScreen({super.key});

  @override
  State<PaguScreen> createState() => _PaguScreenState();
}

class _PaguScreenState extends State<PaguScreen> {
  final PaguService _service = PaguService();

  bool _isLoading = true;
  String? _error;
  List<PaguItem> _items = [];

  @override
  void initState() {
    super.initState();
    _loadPagu();
  }

  Future<void> _loadPagu() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _service.fetchPagu();
      setState(() {
        _items = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat data pagu: $e';
        _isLoading = false;
      });
    }
  }

  int get _totalBiaya {
    int sum = 0;
    for (final p in _items) {
      sum += p.nominal;
    }
    return sum;
  }

  int get _totalTerbayar {
    int sum = 0;
    for (final p in _items) {
      if (p.sudahLunas) sum += p.nominal;
    }
    return sum;
  }

  int get _totalSisa => _totalBiaya - _totalTerbayar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: kGreen,
        foregroundColor: Colors.white,
        title: const Text('Pagu'),
      ),
      body: Column(
        children: [Expanded(child: _buildBody()), _buildRekapitulasiCard()],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    if (_items.isEmpty) {
      return const Center(child: Text('Belum ada data pagu.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildPaguCard(item),
        );
      },
    );
  }

  Widget _buildPaguCard(PaguItem item) {
    final bool lunas = item.sudahLunas;

    return Container(
      decoration: BoxDecoration(
        color: lunas ? kGreen : Colors.grey.shade300,
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: lunas ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.jatuhTempoLabel,
                style: TextStyle(
                  fontSize: 13,
                  color: lunas ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
          // kanan: nominal
          Text(
            _formatRupiah(item.nominal),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: lunas ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRekapitulasiCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: kGreen,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _rekapItem('Total Biaya', _formatRupiah(_totalBiaya)),
            _rekapItem('Terbayar', _formatRupiah(_totalTerbayar)),
            _rekapItem('Sisa', _formatRupiah(_totalSisa)),
          ],
        ),
      ),
    );
  }

  Widget _rekapItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

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
