import 'package:flutter/material.dart';

const Color kGreen = Color(0xFF0C4E1A);
const Color kCardGreen = Color(0xFF2E6C3E);

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
                    backgroundColor: Colors.white70,
                    child: Icon(Icons.person, size: 45, color: kGreen),
                  ),
                  const SizedBox(width: 15),

                  // DATA SISWA
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "21010101",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "DARUT TAQWA",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "085123456789",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // ICON EDIT PROFIL
                  const Icon(Icons.edit, color: Colors.white, size: 30),
                ],
              ),
            ),
            // CARD UTAMA
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(15, 15, 15, 10),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              decoration: BoxDecoration(
                color: kGreen,
                borderRadius: BorderRadius.circular(18),
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
                            children: const [
                              Text(
                                "Saldo",
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 6),
                              Text(
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
                            children: const [
                              Text(
                                "Tagihan",
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 6),
                              Text(
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

                  const SizedBox(height: 25),

                  // 4 FITUR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _menuItem(Icons.add_circle_outline, "Isi Saldo"),
                      ),
                      Expanded(child: _menuItem(Icons.receipt_long, "Riwayat")),
                      Expanded(
                        child: _menuItem(Icons.payments_outlined, "Bayar"),
                      ),
                      Expanded(
                        child: _menuItem(Icons.description_outlined, "Pagu"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET MENU ITEM
  Widget _menuItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 32, color: Colors.white),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
