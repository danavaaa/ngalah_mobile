import 'package:flutter/material.dart';

class SisdaDashboardScreen extends StatelessWidget {
  const SisdaDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF0C4E1A);

    return Scaffold(
      backgroundColor: Colors.white,

      // AppBar
      appBar: AppBar(
        backgroundColor: green,
        elevation: 0,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          //   HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            color: green,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white70,
                  child: Icon(Icons.person, size: 45, color: green),
                ),
                const SizedBox(width: 15),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "21010101",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "Darut Taqwa",
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

                const Spacer(),
                const Icon(Icons.edit, color: Colors.white, size: 28),
              ],
            ),
          ),

          // CARD SALDO & TAGIHAN
          Row(
            children: [
              // SALDO
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 15, left: 15, right: 7.5),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E6C3E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: const [
                      Text(
                        "Saldo",
                        style: TextStyle(color: Colors.white, fontSize: 15),
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

              // TAGIHAN
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 15, right: 15, left: 7.5),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E6C3E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: const [
                      Text(
                        "Tagihan",
                        style: TextStyle(color: Colors.white, fontSize: 15),
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

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
