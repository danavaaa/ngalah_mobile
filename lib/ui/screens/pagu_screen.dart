import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/sisda_provider.dart';
import '../../data/models/pagu_item.dart';
import '../../data/services/pagu_service.dart';

const Color kGreen = Color(0xFF0C4E1A);

class PaguScreen extends StatefulWidget {
  const PaguScreen({super.key});

  @override
  State<PaguScreen> createState() => _PaguScreenState();
}

// state untuk pagu screen
class _PaguScreenState extends State<PaguScreen> {
  bool _isLoading = true;
  String? _error;
  List<PaguItem> _items = [];
  String? _expandedId;
  // inisialisasi state
  @override
  void initState() {
    super.initState();
    _loadPagu();
  }

  // fungsi untuk memuat data pagu
  Future<void> _loadPagu() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    // mengambil data pagu dari service
    try {
      final sisda = context.read<SisdaProvider>();
      final idperson = sisda.user!.iduser;
      // memanggil service untuk fetch data pagu
      final service = PaguService(sisda.dio);
      final data = await service.fetchPagu(idperson: idperson);
      // memperbarui state dengan data yang diperoleh
      setState(() {
        _items = data;
        _isLoading = false;
      });
    } catch (e) {
      // menangani error jika terjadi
      setState(() {
        _error = 'Gagal memuat data pagu: $e';
        _isLoading = false;
      });
    }
  }

  // menghitung total biaya, terbayar, dan sisa
  int get _totalBiaya => _items.fold(0, (sum, p) => sum + p.tagihan);
  int get _totalTerbayar => _items.fold(0, (sum, p) => sum + p.terbayar);
  int get _totalSisa => _totalBiaya - _totalTerbayar;
  // UI
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

  // body utama
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
    // menampilkan daftar item pagu
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        final isExpanded = _expandedId == item.id;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildPaguCard(item, isExpanded),
        );
      },
    );
  }

  // kartu pagu
  Widget _buildPaguCard(PaguItem item, bool isExpanded) {
    final bool lunas = item.sudahLunas;
    // menangani interaksi ketukan pada kartu
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_expandedId == item.id) {
            _expandedId = null;
          } else {
            _expandedId = item.id;
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: lunas ? kGreen : Colors.grey.shade400,
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(12),
                  bottom: isExpanded ? Radius.zero : const Radius.circular(12),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // kiri: bulan + jatuh tempo
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.bulanLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: lunas ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.jatuhTempoLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: lunas ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // kanan: nominal
                  Text(
                    _formatRupiah(item.tagihan),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: lunas ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // DETAIL
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState:
                  isExpanded
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
              firstChild: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // baris judul
                    Row(
                      children: const [
                        Expanded(
                          child: Text(
                            'Pagu',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Tagihan',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Terbayar',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // baris nilai
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.bulanLabel,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _formatRupiah(item.tagihan),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _formatRupiah(item.sudahLunas ? item.terbayar : 0),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              secondChild: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  // kartu rekapitulasi
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rekapitulasi Biaya Periode Ini',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
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
        ],
      ),
    );
  }

  // item rekapitulasi
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

  // format nominal ke rupiah
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
