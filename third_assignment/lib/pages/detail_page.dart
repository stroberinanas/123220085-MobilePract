import 'package:asisten_tpm_8/models/clothes_model.dart';
import 'package:asisten_tpm_8/services/clothes_service.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final int id;

  const DetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Clothes Detail"), centerTitle: true),
      body: Padding(padding: EdgeInsets.all(20), child: _clothesDetail()),
    );
  }

  Widget _clothesDetail() {
    /*
      FutureBuilder adalah widget yang membantu menangani proses asynchronous
      Proses async adalah proses yang membutuhkan waktu. (ex: mengambil data dari API)

      FutureBuilder itu butuh 2 properti, yaitu future dan builder.
      Properti future adalah proses async yg akan dilakukan.
      Properti builder itu tampilan yg akan ditampilkan berdasarkan proses future tadi.
      
      Properti builder itu pada umumnya ada 2 status, yaitu hasError dan hasData.
      Status hasError digunakan untuk mengecek apakah terjadi kesalahan (misal: jaringan error).
      Status hasData digunakan untuk mengecek apakah data sudah siap.
    */
    return FutureBuilder(
      future: UserApi.getClothesById(id),
      builder: (context, snapshot) {
        // Jika error (gagal memanggil API), maka tampilkan teks error
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error.toString()}");
        }
        // Jika berhasil memanggil API
        else if (snapshot.hasData) {
          /*
            Baris 1:
            Untuk mengambil response dari API, kita bisa mengakses "snapshot.data"
            Nah, snapshot.data tadi itu bentuknya masih berupa Map<String, dynamic>.

            Untuk memudahkan pengolahan data, 
            kita perlu mengonversi data JSON tersebut ke dalam model Dart (Clothes).
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


            Baris 2:
            Setelah dikonversi, tampilkan data tadi di widget bernama "_user()"
            dengan mengirimkan data tadi sebagai parameternya.
          */
          Clothes clothes = Clothes.fromJson(snapshot.data!["data"]);
          return _clothes(clothes);
        }
        // Jika masih loading, tampilkan loading screen di tengah layar
        else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _clothes(Clothes clothes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Name : ${clothes.name!}",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text("Price : Rp ${clothes.price}", style: TextStyle(fontSize: 14)),
        Text(
          "Category : ${clothes.category ?? '-'}",
          style: TextStyle(fontSize: 14),
        ),
        Text("Brand : ${clothes.brand ?? '-'}", style: TextStyle(fontSize: 14)),
        Text("Sold : ${clothes.sold ?? 0}", style: TextStyle(fontSize: 14)),
        Text(
          "Rating : ${clothes.rating?.toStringAsFixed(1) ?? '0.0'}",
          style: TextStyle(fontSize: 14),
        ),
        Text("Stock : ${clothes.stock ?? 0}", style: TextStyle(fontSize: 14)),
        Text(
          "Year Released : ${clothes.yearReleased ?? '-'}",
          style: TextStyle(fontSize: 14),
        ),
        Text(
          "Material: ${clothes.material ?? '-'}",
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
