import 'package:flutter/material.dart';
import '../model/cat.dart';

class CatDetailPage extends StatelessWidget {
  final Cat cat; // Data kucing yang akan ditampilkan
  const CatDetailPage({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cat.name), // Menampilkan nama kucing sebagai judul AppBar
        backgroundColor: Colors.green, // Mengatur warna AppBar menjadi hijau
      ),
      body: SingleChildScrollView(
        // Memungkinkan halaman di-scroll jika kontennya panjang
        child: Center(
          // Menempatkan konten di tengah layar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .center, // Semua elemen dalam column dipusatkan
            children: [
              // Bagian gambar kucing
              Image.network(
                cat.pictureUrl, // Menampilkan gambar kucing dari URL
                width: double.infinity, // Gambar memenuhi lebar layar
                height: 250, // Tinggi gambar diatur 250 pixel
                fit: BoxFit.cover, // Gambar akan menyesuaikan tanpa terdistorsi
              ),
              const SizedBox(height: 16), // Jarak antara gambar dan teks
              Padding(
                padding: const EdgeInsets.all(
                    16.0), // Memberikan padding pada konten
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green[50], // Latar belakang hijau muda
                    borderRadius: BorderRadius.circular(
                        12), // Membuat sudut elemen melengkung
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(
                            0.2), // Warna bayangan dengan transparansi
                        spreadRadius: 2, // Seberapa jauh bayangan menyebar
                        blurRadius: 5, // Seberapa kabur bayangan
                        offset: Offset(0, 3), // Posisi bayangan (x=0, y=3)
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.all(16.0), // Padding dalam container
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Teks diatur sejajar ke kiri
                    children: [
                      // Judul di tengah
                      Center(
                        child: Text(
                          cat.name, // Menampilkan nama kucing
                          style: const TextStyle(
                            fontSize: 24, // Ukuran font 24px
                            fontWeight: FontWeight.bold, // Font bold
                            color: Colors.green, // Warna teks hijau
                          ),
                        ),
                      ),
                      const SizedBox(
                          height: 16), // Jarak antara judul dan tabel

                      // Tabel untuk detail kucing
                      Table(
                        columnWidths: const {
                          0: FixedColumnWidth(
                              110), // Lebar kolom pertama tetap 110px
                          1: FlexColumnWidth(), // Kolom kedua fleksibel menyesuaikan sisa lebar
                        },
                        children: [
                          TableRow(
                            children: [
                              const Text("Breed",
                                  style: TextStyle(
                                      fontWeight: FontWeight
                                          .bold)), // Label "Breed" bold
                              Text(cat.breed), // Data ras kucing
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text("Color",
                                  style: TextStyle(
                                      fontWeight: FontWeight
                                          .bold)), // Label "Color" bold
                              Text(cat.color), // Data warna kucing
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text("Age",
                                  style: TextStyle(
                                      fontWeight:
                                          FontWeight.bold)), // Label "Age" bold
                              Text("${cat.age} years old"), // Data umur kucing
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text("Sex",
                                  style: TextStyle(
                                      fontWeight:
                                          FontWeight.bold)), // Label "Sex" bold
                              Text(cat.sex), // Data jenis kelamin kucing
                            ],
                          ),
                          if (cat.vaccines
                              .isNotEmpty) // Jika kucing memiliki data vaksin
                            TableRow(
                              children: [
                                const Text("Vaccines",
                                    style: TextStyle(
                                        fontWeight: FontWeight
                                            .bold)), // Label "Vaccines" bold
                                Text(cat.vaccines.join(
                                    ", ")), // Menampilkan daftar vaksin dipisah dengan koma
                              ],
                            ),
                          TableRow(
                            children: [
                              const Text("Characteristics",
                                  style: TextStyle(
                                      fontWeight: FontWeight
                                          .bold)), // Label "Characteristics" bold
                              Text(cat.characteristics.join(
                                  ", ")), // Menampilkan karakteristik kucing
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text("Background",
                                  style: TextStyle(
                                      fontWeight: FontWeight
                                          .bold)), // Label "Background" bold
                              Text(cat
                                  .background), // Menampilkan latar belakang kucing
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
