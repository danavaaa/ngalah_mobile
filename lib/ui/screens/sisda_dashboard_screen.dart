import 'package:flutter/material.dart';

class SisdaDashboardScreen extends StatelessWidget {
  const SisdaDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF0C4E1A);

    // Data Dummy profil
    const String nis = "21010101";
    const String namaSantri = "Darut Taqwa";
    const String nomorWa = "085123456789";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: green),

      body: Column(
        children: [
          // HEADER PROFIL SISDA
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: green,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Foto profil dummy
                const CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(width: 20),

                // Data Santri
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        nis,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        namaSantri,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        nomorWa,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),

                // Icon Edit
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, color: Colors.white, size: 30),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
