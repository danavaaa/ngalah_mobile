import 'package:flutter/material.dart';

const Color kGreen = Color(0xFF0C4E1A);
const Color kCardGreen = Color(0xFF2E6C3E);
const Color kLightTile = Color(0xFFE3F6E7);

class SisdaDashboardScreen extends StatelessWidget {
  const SisdaDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: kGreen,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text('Ngalah Mobile', style: TextStyle(fontSize: 16)),
        centerTitle: false,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              color: kGreen,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FOTO PROFIL
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: Icon(Icons.person, size: 45, color: kGreen),
                    ),
                  ),
                  const SizedBox(width: 15),

                  // DATA SISWA
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "21010101",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "DARUT TAQWA",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "085123456789",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // ICON EDIT PROFIL
                  const Icon(Icons.edit, color: Colors.white, size: 26),
                ],
              ),
            ),

            // CARD UTAMA
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
              decoration: BoxDecoration(
                color: kGreen,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // SALDO & TAGIHAN
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 110,
                          decoration: BoxDecoration(
                            color: kCardGreen,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Saldo",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.info_outline,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                "Rp. 2.000.000",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 110,
                          decoration: BoxDecoration(
                            color: kCardGreen,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Tagihan",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.info_outline,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                "Rp. 1.200.000",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // MENU 4 FITUR DI DALAM CARD
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _topMenuItem(
                          Icons.add_box_outlined,
                          "Isi Saldo",
                        ),
                      ),
                      Expanded(
                        child: _topMenuItem(Icons.receipt_long, "Riwayat"),
                      ),
                      Expanded(
                        child: _topMenuItem(Icons.payments_outlined, "Bayar"),
                      ),
                      Expanded(
                        child: _topMenuItem(Icons.description_outlined, "Pagu"),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // GRID 8 FITUR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 20,
                crossAxisSpacing: 15,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 0.8,
                children: [
                  _featureItem(Icons.school, "Pendidikan"),
                  _featureItem(Icons.access_time, "Absensi"),
                  _featureItem(Icons.article, "Raport"),
                  _featureItem(Icons.campaign, "Pengumuman"),
                  _featureItem(Icons.bed, "Perizinan"),
                  _featureItem(Icons.restaurant_menu, "Kupon Makan"),
                  _featureItem(Icons.account_balance_wallet, "Tarik Tunai"),
                  _featureItem(Icons.manage_accounts, "Atur Uang Saku"),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      // BOTTOM NAV BAR SEDERHANA
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kGreen,
        type: BottomNavigationBarType.fixed,
        currentIndex: 2, // SISDA sedang aktif
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: const TextStyle(fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'BERANDA'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'BACAAN'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'SISDA'),
          BottomNavigationBarItem(icon: Icon(Icons.group_add), label: 'PPDB'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'SETTING'),
        ],
        onTap: (index) {},
      ),
    );
  }

  // WIDGET 4 MENU
  Widget _topMenuItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 30, color: Colors.white),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // WIDGET GRID 8 FITUR
  static Widget _featureItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: kLightTile,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, size: 32, color: kGreen),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: kGreen,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
