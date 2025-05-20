import 'package:flutter/material.dart';
import '../pages/cat_detail_page.dart';
import '../model/cat.dart';

class CatListPage extends StatelessWidget {
  final List<Cat> cats; // Daftar kucing yang akan ditampilkan
  const CatListPage({super.key, required this.cats});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cat List",
            style: TextStyle(color: Colors.green)), // Judul AppBar
        backgroundColor: Colors.white, // Warna latar belakang putih
        elevation: 0, // Menghilangkan bayangan di AppBar
      ),
      body: Container(
        color: const Color.fromARGB(
            255, 196, 220, 198), // Warna latar belakang halaman
        child: GridView.builder(
          padding: const EdgeInsets.all(8.0), // Padding untuk grid
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Jumlah kolom dalam grid
            crossAxisSpacing: 8, // Jarak antar kolom
            mainAxisSpacing: 8, // Jarak antar baris
            childAspectRatio: 0.8, // Rasio ukuran item
          ),
          itemCount: cats.length, // Jumlah item sesuai daftar kucing
          itemBuilder: (context, index) {
            final cat = cats[index]; // Mengambil data kucing berdasarkan indeks

            return GestureDetector(
              onTap: () {
                // Saat kartu kucing ditekan
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CatDetailPage(cat: cat), // Pindah ke halaman detail
                  ),
                );
              },
              child: CatCard(cat: cat), // Menampilkan kartu kucing
            );
          },
        ),
      ),
    );
  }
}

class CatCard extends StatefulWidget {
  final Cat cat; // Data kucing yang akan ditampilkan di kartu
  const CatCard({super.key, required this.cat});

  @override
  _CatCardState createState() => _CatCardState();
}

class _CatCardState extends State<CatCard> {
  bool isFavorite = false; // Status apakah kucing difavoritkan atau tidak

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(5.0), // Membuat sudut kartu lebih melengkung
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Konten di tengah kartu
        children: [
          Expanded(
            child: ClipRRect(
              child: Image.network(
                widget.cat.pictureUrl, // Menampilkan gambar kucing dari URL
                fit: BoxFit.contain, // Menyesuaikan ukuran gambar
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0), // Padding dalam kartu
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Menjaga teks tetap di tengah
              children: [
                Text(
                  widget.cat.name, // Nama kucing
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green, // Warna hijau untuk nama
                  ),
                ),
                const SizedBox(height: 4), // Jarak antar elemen
                Text(
                  "${widget.cat.age} years old", // Usia kucing
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 215, 107, 143), // Warna pink tua
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.cat.breed, // Ras kucing
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey, // Warna abu-abu
                    fontStyle: FontStyle.italic, // Italic untuk teks ras
                  ),
                ),
                const SizedBox(height: 8), // Jarak antar elemen
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Membuat ikon terpisah di ujung
                  children: [
                    Icon(
                      widget.cat.sex == "M"
                          ? Icons.male
                          : Icons.female, // Ikon sesuai jenis kelamin
                      color: Colors.green, // Warna ikon hijau
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border, // Ikon hati (favorit)
                        color: isFavorite
                            ? Colors.red
                            : Colors
                                .grey, // Warna ikon berubah jika difavoritkan
                      ),
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite; // Toggle status favorit
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
