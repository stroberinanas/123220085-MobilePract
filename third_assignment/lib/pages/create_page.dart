import '../models/clothes_model.dart';
import '../pages/home_page.dart';
import '../services/clothes_service.dart';
import 'package:flutter/material.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  /* 
    Controller dipake buat mengelola input teks dari TextField.
    Di sini kita bikin controller buat input name sama email.
    Buat input gender, hasilnya cukup kita simpan ke dalam string biasa karena kita make radio button
  */
  final name = TextEditingController();
  final price = TextEditingController();
  final category = TextEditingController();
  final brand = TextEditingController();
  final sold = TextEditingController();
  final rating = TextEditingController();
  final stock = TextEditingController();
  final yearReleased = TextEditingController();
  final material = TextEditingController();

  // Fungsi untuk membuat user ketika tombol "Create Clothes" diklik
  Future<void> _createClothes(BuildContext context) async {
    try {
      // Validasi field kosong
      if (name.text.isEmpty ||
          price.text.isEmpty ||
          category.text.isEmpty ||
          brand.text.isEmpty ||
          sold.text.isEmpty ||
          rating.text.isEmpty ||
          stock.text.isEmpty ||
          yearReleased.text.isEmpty ||
          material.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Semua field wajib diisi!")),
        );
        return;
      }

      // Coba parsing angka (dengan tryParse agar tidak crash)
      int? parsedPrice = int.tryParse(price.text.trim());
      int? parsedSold = int.tryParse(sold.text.trim());
      int? parsedStock = int.tryParse(stock.text.trim());
      int? parsedYear = int.tryParse(yearReleased.text.trim());
      double? parsedRating = double.tryParse(rating.text.trim());

      // Cek parsing berhasil
      if (parsedPrice == null ||
          parsedSold == null ||
          parsedStock == null ||
          parsedYear == null ||
          parsedRating == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Pastikan input angka valid untuk Price, Sold, Stock, Year Released, dan Rating",
            ),
          ),
        );
        return;
      }

      // Validasi rating (0–5)
      if (parsedRating < 0 || parsedRating > 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Rating harus di antara 0 sampai 5")),
        );
        return;
      }

      // Validasi yearReleased (2018–2025)
      final int currentYear = DateTime.now().year;
      if (parsedYear < 2018 || parsedYear > currentYear) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Year Released harus antara 2018 dan $currentYear"),
          ),
        );
        return;
      }

      // Buat objek Clothes
      Clothes newClothes = Clothes(
        name: name.text.trim(),
        price: parsedPrice,
        category: category.text.trim(),
        brand: brand.text.trim(),
        sold: parsedSold,
        rating: parsedRating,
        stock: parsedStock,
        yearReleased: parsedYear,
        material: material.text.trim(),
      );

      /*
        Lakukan pemanggilan API create, setelah itu
        simpan ke dalam variabel bernama "response"
      */
      final response = await UserApi.createClothes(newClothes);

      /*
        Jika response status "Success", 
        maka tampilkan snackbar yg bertuliskan "Berhasil menambah user baru"
      */
      if (response["status"] == "Success") {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("New Clothes Added")));

        // Pindah ke halaman sebelumnya
        Navigator.pop(context);

        // Untuk merefresh tampilan (menampilkan user baru ke dalam daftar)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const HomePage(),
          ),
        );
      } else {
        // Jika response status "Error", maka kode akan dilempar ke bagian catch
        throw Exception(response["message"]);
      }
    } catch (error) {
      /*
        Jika user gagal menghapus, 
        maka tampilkan snackbar dengan tulisan "Gagal: error-nya apa"
      */
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: $error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Clothes"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // Buat input nama user
            TextField(
              /*
                Ngasi tau kalau ini input buat name, jadi segala hal yg kita ketikan 
                bakalan disimpan ke dalam variabel "name" yg udah kita bikin di atas
              */
              controller: name,
              decoration: const InputDecoration(
                labelText: "Name", // <- Ngasi label
                border: OutlineInputBorder(), // <- Ngasi border di form-nya
              ),
            ),
            const SizedBox(height: 16), // <- Ngasi jarak antar widget
            // Buat input email user
            TextField(
              /*
                Ngasi tau kalau ini input buat email, jadi segala hal yg kita ketikan 
                bakalan disimpan ke dalam variabel "email" yg udah kita bikin di atas
              */
              controller: price,
              decoration: const InputDecoration(
                labelText: "Price", // <- Ngasi label
                border: OutlineInputBorder(), // <- Ngasi border di form-nya
              ),
            ),
            const SizedBox(height: 16), // <- Ngasi jarak antar widget
            TextField(
              /*
                Ngasi tau kalau ini input buat email, jadi segala hal yg kita ketikan 
                bakalan disimpan ke dalam variabel "email" yg udah kita bikin di atas
              */
              controller: category,
              decoration: const InputDecoration(
                labelText: "Category", // <- Ngasi label
                border: OutlineInputBorder(), // <- Ngasi border di form-nya
              ),
            ),
            const SizedBox(height: 16), // <- Ngasi jarak antar widget
            TextField(
              /*
                Ngasi tau kalau ini input buat email, jadi segala hal yg kita ketikan 
                bakalan disimpan ke dalam variabel "email" yg udah kita bikin di atas
              */
              controller: brand,
              decoration: const InputDecoration(
                labelText: "Brand", // <- Ngasi label
                border: OutlineInputBorder(), // <- Ngasi border di form-nya
              ),
            ),
            const SizedBox(height: 16), // <- Ngasi jarak antar widget
            TextField(
              /*
                Ngasi tau kalau ini input buat email, jadi segala hal yg kita ketikan 
                bakalan disimpan ke dalam variabel "email" yg udah kita bikin di atas
              */
              controller: sold,
              decoration: const InputDecoration(
                labelText: "Sold", // <- Ngasi label
                border: OutlineInputBorder(), // <- Ngasi border di form-nya
              ),
            ),
            const SizedBox(height: 16), // <- Ngasi jarak antar widget
            TextField(
              /*
                Ngasi tau kalau ini input buat email, jadi segala hal yg kita ketikan 
                bakalan disimpan ke dalam variabel "email" yg udah kita bikin di atas
              */
              controller: rating,
              decoration: const InputDecoration(
                labelText: "Rating", // <- Ngasi label
                border: OutlineInputBorder(), // <- Ngasi border di form-nya
              ),
            ),
            const SizedBox(height: 16), // <- Ngasi jarak antar widget
            TextField(
              /*
                Ngasi tau kalau ini input buat email, jadi segala hal yg kita ketikan 
                bakalan disimpan ke dalam variabel "email" yg udah kita bikin di atas
              */
              controller: stock,
              decoration: const InputDecoration(
                labelText: "Stock", // <- Ngasi label
                border: OutlineInputBorder(), // <- Ngasi border di form-nya
              ),
            ),
            const SizedBox(height: 16), // <- Ngasi jarak antar widget
            TextField(
              /*
                Ngasi tau kalau ini input buat email, jadi segala hal yg kita ketikan 
                bakalan disimpan ke dalam variabel "email" yg udah kita bikin di atas
              */
              controller: yearReleased,
              decoration: const InputDecoration(
                labelText: "Year Released", // <- Ngasi label
                border: OutlineInputBorder(), // <- Ngasi border di form-nya
              ),
            ),
            const SizedBox(height: 16), // <- Ngasi jarak antar widget
            TextField(
              /*
                Ngasi tau kalau ini input buat email, jadi segala hal yg kita ketikan 
                bakalan disimpan ke dalam variabel "email" yg udah kita bikin di atas
              */
              controller: material,
              decoration: const InputDecoration(
                labelText: "Material", // <- Ngasi label
                border: OutlineInputBorder(), // <- Ngasi border di form-nya
              ),
            ),
            const SizedBox(height: 16), // <- Ngasi jarak antar widget
            // Tombol buat bikin user baru
            ElevatedButton(
              onPressed: () {
                // Jalankan fungsi _createClothes() ketika tombol diklik
                _createClothes(context);
              },
              child: const Text("Add Clothes"),
            ),
          ],
        ),
      ),
    );
  }
}
