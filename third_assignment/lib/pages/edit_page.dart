import '../models/clothes_model.dart';
import '../pages/home_page.dart';
import '../services/clothes_service.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  final int id;
  const EditPage({super.key, required this.id});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
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

  bool _isDataLoaded = false;

  // Fungsi untuk mengupdate user ketika tombol "Update Clothes" diklik
  Future<void> _updateClothes(BuildContext context) async {
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

      // Coba parsing angka
      int? parsedPrice = int.tryParse(price.text.trim());
      int? parsedSold = int.tryParse(sold.text.trim());
      int? parsedStock = int.tryParse(stock.text.trim());
      int? parsedYear = int.tryParse(yearReleased.text.trim());
      double? parsedRating = double.tryParse(rating.text.trim());

      if (parsedPrice == null ||
          parsedSold == null ||
          parsedStock == null ||
          parsedYear == null ||
          parsedRating == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pastikan input angka valid")),
        );
        return;
      }

      if (parsedRating < 0 || parsedRating > 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Rating harus di antara 0 sampai 5")),
        );
        return;
      }

      final int currentYear = DateTime.now().year;
      if (parsedYear < 2018 || parsedYear > currentYear) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Year Released harus antara 2018 dan $currentYear"),
          ),
        );
        return;
      }

      /*
        Karena kita mau mengedit user, maka kita juga perlu data yg baru.
        Disini kita mengambil data nama, email, & gender yang dah diisi pada form,
        Terus datanya itu disimpan ke dalam variabel "updatedClothes" dengan tipe data Clothes.
      */

      Clothes updatedClothes = Clothes(
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
        Lakukan pemanggilan API update, setelah itu
        simpan ke dalam variabel bernama "response"
      */
      final response = await UserApi.updateClothes(updatedClothes, widget.id);

      /*
        Jika response status "Success", 
        maka tampilkan snackbar yg bertuliskan "Berhasil mengubah user [nama_user]"
      */
      if (response["status"] == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${updatedClothes.name} Updated")),
        );

        // Pindah ke halaman sebelumnya
        Navigator.pop(context);

        // Untuk merefresh tampilan (menampilkan data user yg telah diedit ke dalam daftar)
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
      appBar: AppBar(title: Text("Update Clothes"), centerTitle: true),
      body: Padding(padding: const EdgeInsets.all(20), child: _clothesEdit()),
    );
  }

  Widget _clothesEdit() {
    return FutureBuilder(
      future: UserApi.getClothesById(widget.id),
      builder: (context, snapshot) {
        // Jika error (gagal memanggil API), maka tampilkan teks error
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error.toString()}");
        }
        // Jika berhasil memanggil API (ada datanya)
        else if (snapshot.hasData) {
          /*
            Jika data belum pernah di-load sama sekali (baru pertama kali),
            maka program akan masuk ke dalam percabangan ini.

            Mengapa perlu dicek? Karena setiap kali layar mengupdate state menggunakan setState(),
            Widget ini akan terus dijalankan berulang-ulang.
            Untuk mencegah pengambilan data berulang-ulang, kita perlu mengecek
            apakah data sudah pernah diambil atau belum.
          */
          if (!_isDataLoaded) {
            // Jika data baru pertama kali di-load, ubah menjadi true
            _isDataLoaded = true;

            /*
              Baris 1:
              Untuk mengambil response dari API, kita bisa mengakses "snapshot.data"
              Nah, snapshot.data tadi itu bentuknya masih berupa Map<String, dynamic>.

              Untuk memudahkan pengolahan data, 
              kita perlu mengonversi data JSON tersebut ke dalam model Dart (Clothes),
              makanya kita pake method Clothes.fromJSON() buat mengonversinya.
              Setelah itu, hasil konversinya disimpan ke dalam variabel bernama "user".
              
              Kenapa yg kita simpan "snapshot.data["data"]" bukan "snapshot.data" aja?
              Karena kalau kita lihat di dokumentasi API, bentuk response-nya itu kaya gini:
              {
                "status": ...
                "message": ...
                "data": {
                  "id": 1,
                  "name": "rafli",
                  "email": "rafli@gmail.com",
                  "gender": "Male",
                  "createdAt": "2025-04-29T13:17:17.000Z",
                  "updatedAt": "2025-04-29T13:17:17.000Z"
                },
              }

              Nah, kita itu cuman mau ngambil properti "data" doang, 
              kita gamau ngambil properti "status" dan "message",
              makanya yg kita simpan ke variabel user itu response.data["data"]

              Baris 2-4
              Setelah mendapatkan data user yg dipilih,
              masukkan data tadi sebagai nilai default pada tiap-tiap input

              Baris 5:
              Setelah dikonversi, tampilkan data tadi di widget bernama "_user()"
              dengan mengirimkan data tadi sebagai parameternya.
            */

            Clothes clothes = Clothes.fromJson(snapshot.data!["data"]);
            name.text = clothes.name!;
            price.text = clothes.price!.toString();
            category.text = clothes.category!;
            brand.text = clothes.brand!;
            sold.text = clothes.sold!.toString();
            rating.text = clothes.rating!.toString();
            stock.text = clothes.stock!.toString();
            yearReleased.text = clothes.yearReleased!.toString();
            material.text = clothes.material!;
          }

          return _clothesEditForm(context);
        }
        // Jika masih loading, tampilkan loading screen di tengah layar
        else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _clothesEditForm(BuildContext context) {
    return ListView(
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
            // Jalankan fungsi _updateClothes() ketika tombol diklik
            _updateClothes(context);
          },
          child: const Text("Update Clothes"),
        ),
      ],
    );
  }
}
