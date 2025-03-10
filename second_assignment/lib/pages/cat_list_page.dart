import 'package:flutter/material.dart';
import '../pages/cat_detail_page.dart';
import '../model/cat.dart';

class CatListPage extends StatelessWidget {
  final List<Cat> cats;
  const CatListPage({super.key, required this.cats});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cat List", style: TextStyle(color: Colors.green)),
        backgroundColor: Colors.white,
        elevation: 0, // Remove shadow
      ),
      body: Container(
        color: const Color.fromARGB(255, 196, 220, 198),
        child: GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemCount: cats.length,
          itemBuilder: (context, index) {
            final cat = cats[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CatDetailPage(cat: cat),
                  ),
                );
              },
              child: CatCard(cat: cat),
            );
          },
        ),
      ),
    );
  }
}

class CatCard extends StatefulWidget {
  final Cat cat;
  const CatCard({super.key, required this.cat});

  @override
  _CatCardState createState() => _CatCardState();
}

class _CatCardState extends State<CatCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              child: Image.network(
                widget.cat.pictureUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center titles and info
              children: [
                Text(
                  widget.cat.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${widget.cat.age} years old",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 215, 107, 143),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.cat.breed,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      widget.cat.sex == "M" ? Icons.male : Icons.female,
                      color: Colors.green,
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite;
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
