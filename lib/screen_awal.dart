import 'package:flutter/material.dart';
import 'homescreen.dart';

class ScreenAwal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple, 
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'BOOKSTORE',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                // Gambar di tengah
                Image.asset(
                  'assets/karakter.png', 
                ),
                SizedBox(height: 40),
              
                Container(
                  padding: EdgeInsets.all(50), // Jarak di sekitar tombol
                  decoration: BoxDecoration(
                    color: Colors.pink[100], // Warna kotak latar belakang
                    borderRadius: BorderRadius.circular(40), // Sudut membulat kotak
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Menggunakan Navigator.push untuk berpindah halaman
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                      backgroundColor: Color.fromARGB(255, 250, 88, 247), // Warna tombol
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Lets Gooo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
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
}