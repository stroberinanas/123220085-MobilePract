import '../models/clothes_model.dart';
import 'create_page.dart';
import 'detail_page.dart';
import 'edit_page.dart';
import '../services/clothes_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Clothes Data"), centerTitle: true),
      body: Padding(padding: EdgeInsets.all(20), child: _clothesContainer()),
    );
  }

  Widget _clothesContainer() {
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
      future: UserApi.getClothes(),
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
            kita perlu mengonversi data JSON tersebut ke dalam 
            model Dart (UsersModel) untuk memudahkan pengolahan data.
            Setelah itu, hasil konversinya disimpan ke dalam variabel bernama "response".

            Baris 2:
            Setelah dikonversi, tampilkan data tadi di widget bernama "_userlist()"
            dengan mengirimkan data tadi sebagai parameternya.

            Kenapa yg dikirim "response.data" bukan "response" aja?
            Karena kalau kita lihat di dokumentasi API, bentuk response-nya itu kaya gini:
            {
              "status": ...
              "message": ...
              "data": [
                {
                  "id": 1,
                  "name": "rafli",
                  "email": "rafli@gmail.com",
                  "gender": "Male",
                  "createdAt": "2025-04-29T13:17:17.000Z",
                  "updatedAt": "2025-04-29T13:17:17.000Z"
                },
                ...
              ]
            }

            Nah, kita itu cuman mau ngambil properti "data" doang, 
            kita gamau ngambil properti "status" dan "message",
            makanya yg kita kirim ke Widget _userlist itu response.data
          */
          ClothesModel response = ClothesModel.fromJson(snapshot.data!);
          return _clothesList(context, response.data!);
        }
        // Jika masih loading, tampilkan loading screen di tengah layar
        else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _clothesList(BuildContext context, List<Clothes> clothess) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const CreatePage()));
          },
          child: const Text("Create New Clothes"),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.builder(
            itemCount: clothess.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final clothes = clothess[index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DetailPage(id: clothes.id!),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 233, 184, 222),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clothes.name!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("Rp ${clothes.price}"),
                      Text(
                        clothes.category ?? "",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      Text("⭐ ${clothes.rating}"),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10, // <- Beri jarak antar widget sebanyak 8dp
                        children: [
                          // Tombol edit
                          ElevatedButton(
                            onPressed: () {
                              /*
                          Pindah ke halaman EditUserPage() (edit_user_page.dart)
                          Karena kita mau mengubah user yg dipilih berdasarkan id-nya, 
                          maka beri parameter berupa id yg dipilih
                        */
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (BuildContext context) =>
                                          EditPage(id: clothes.id!),
                                ),
                              );
                            },
                            child: Text("Edit"),
                          ),
                          // Tombol delete
                          ElevatedButton(
                            onPressed: () {
                              /*
                          Karena kita mau menghapus user berdasarkan id-nya, maka
                          jalankan fungsi _deleteUser() dengan memberi
                          parameter berupa id yg dipilih
                        */
                              _deleteClothes(clothes.id!);
                            },
                            child: Text("Delete"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Fungsi untuk menghapus user ketika tombol "Delete Clothes" diklik
  void _deleteClothes(int id) async {
    try {
      /*
        Lakukan pemanggilan API delete, setelah itu
        simpan ke dalam variabel bernama "response"
      */
      final response = await UserApi.deleteClothes(id);

      /*
        Jika response status "Success", 
        maka tampilkan snackbar yg bertuliskan "Clothes Deleted"
      */
      if (response["status"] == "Success") {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Clothes Deleted")));

        // Refresh tampilan (Supaya data yg dihapus ilang dari layar)
        setState(() {});
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
}
