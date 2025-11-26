import 'package:flutter/material.dart';
import '../../data/models/riwayat_transaksi.dart';
import '../../data/services/riwayat_transaksi_service.dart';

const Color kGreen = Color(0xFF0C4E1A);

class RiwayatTransaksiScreen extends StatefulWidget {
  const RiwayatTransaksiScreen({super.key});

  @override
  State<RiwayatTransaksiScreen> createState() => _RiwayatTransaksiScreenState();
}

class _RiwayatTransaksiScreenState extends State<RiwayatTransaksiScreen> {
  final RiwayatTransaksiService _service = RiwayatTransaksiService();

  bool _isLoading = true;
  String? _error;
  List<RiwayatTransaksi> _allData = [];
  List<RiwayatTransaksi> _filteredData = [];

  // filter
  String _selectedDateFilter = 'Semua Tanggal';
  String _selectedTypeFilter = 'Semua Jenis';

  final List<String> _dateFilters = [
    'Semua Tanggal',
    'Bulan Ini',
    '30 Hari Terakhir',
    'Tahun Ini',
  ];

  final List<String> _typeFilters = [
    'Semua Jenis',
    'Isi Saldo',
    'Pembayaran UPT',
    'Uang Jajan',
    'Penarikan Tunai',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _service.fetchRiwayat();
      setState(() {
        _allData = data;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat riwayat: $e';
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    List<RiwayatTransaksi> result = List.from(_allData);

    final now = DateTime.now();

    // filter tanggal
    if (_selectedDateFilter == 'Bulan Ini') {
      result =
          result
              .where(
                (t) =>
                    t.tanggal.year == now.year && t.tanggal.month == now.month,
              )
              .toList();
    } else if (_selectedDateFilter == '30 Hari Terakhir') {
      final cutoff = now.subtract(const Duration(days: 30));
      result = result.where((t) => t.tanggal.isAfter(cutoff)).toList();
    } else if (_selectedDateFilter == 'Tahun Ini') {
      result = result.where((t) => t.tanggal.year == now.year).toList();
    }

    // filter jenis
    if (_selectedTypeFilter != 'Semua Jenis') {
      result =
          result.where((t) {
            switch (_selectedTypeFilter) {
              case 'Isi Saldo':
                return t.type == TransactionType.isiSaldo;
              case 'Pembayaran UPT':
                return t.type == TransactionType.bayarUpt;
              case 'Uang Jajan':
                return t.type == TransactionType.uangJajan;
              case 'Penarikan Tunai':
                return t.type == TransactionType.tarikTunai;
            }
            return true;
          }).toList();
    }

    // urutkan terbaru di atas
    result.sort((a, b) => b.tanggal.compareTo(a.tanggal));

    // <<< di-set lewat setState supaya UI ke-update >>>
    setState(() {
      _filteredData = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kGreen,
        foregroundColor: Colors.white,
        title: const Text('Riwayat Transaksi'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 4),
          _buildFilterBar(),
          const Divider(height: 1),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                    ? Center(child: Text(_error!))
                    : _filteredData.isEmpty
                    ? const Center(
                      child: Text(
                        'Belum ada riwayat transaksi',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                    : _buildGroupedList(),
          ),
        ],
      ),
    );
  }

  // FILTER BAR
  Widget _buildFilterBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: _showDateFilterSheet,
              child: _filterChip(_selectedDateFilter),
            ),
          ),
          Container(width: 1, height: 28, color: Colors.grey.shade300),
          Expanded(
            child: InkWell(
              onTap: _showTypeFilterSheet,
              child: _filterChip(_selectedTypeFilter),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down, size: 18),
        ],
      ),
    );
  }

  void _showDateFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return ListView(
          children:
              _dateFilters.map((f) {
                final selected = f == _selectedDateFilter;
                return ListTile(
                  title: Text(f),
                  trailing:
                      selected ? const Icon(Icons.check, color: kGreen) : null,
                  onTap: () {
                    _selectedDateFilter = f;
                    _applyFilters();
                    Navigator.pop(ctx);
                  },
                );
              }).toList(),
        );
      },
    );
  }

  void _showTypeFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return ListView(
          children:
              _typeFilters.map((f) {
                final selected = f == _selectedTypeFilter;
                return ListTile(
                  title: Text(f),
                  trailing:
                      selected ? const Icon(Icons.check, color: kGreen) : null,
                  onTap: () {
                    _selectedTypeFilter = f;
                    _applyFilters();
                    Navigator.pop(ctx);
                  },
                );
              }).toList(),
        );
      },
    );
  }

  // GROUPED LIST (per bulan)
  Widget _buildGroupedList() {
    final Map<String, List<RiwayatTransaksi>> grouped = {};

    for (final t in _filteredData) {
      final key = _monthLabel(t.tanggal);
      grouped.putIfAbsent(key, () => []).add(t);
    }

    final monthKeys = grouped.keys.toList();

    return ListView.builder(
      itemCount: monthKeys.length,
      itemBuilder: (context, index) {
        final key = monthKeys[index];
        final items = grouped[key]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // header bulan
            Container(
              color: index == 0 ? Colors.white : Colors.grey.shade300,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                key,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            // list transaksi bulan tsb
            ...items.map((t) => _HistoryRow(item: t)).toList(),
          ],
        );
      },
    );
  }

  String _monthLabel(DateTime date) {
    const bulan = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${bulan[date.month]} ${date.year}';
  }
}

// ROW 1 TRANSAKSI
class _HistoryRow extends StatelessWidget {
  final RiwayatTransaksi item;

  const _HistoryRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      child: Row(
        children: [
          Icon(item.icon, size: 28, color: kGreen),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  item.subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatTanggal(item.tanggal),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _formatRupiah(item.nominal),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: item.amountColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTanggal(DateTime date) {
    const bulan = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${bulan[date.month]} ${date.year}';
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
