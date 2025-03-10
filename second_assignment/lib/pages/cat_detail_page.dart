import 'package:flutter/material.dart';
import '../model/cat.dart';

class CatDetailPage extends StatelessWidget {
  final Cat cat;
  const CatDetailPage({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cat.name),
        backgroundColor: Colors.green, // Set AppBar color to green
      ),
      body: SingleChildScrollView(
        child: Center(
          // Center the content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image section
              Image.network(
                cat.pictureUrl,
                width: double.infinity,
                height: 250, // Set a fixed height for the image
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16), // Space between image and text
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green[50], // Light green background
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Centered title
                      Center(
                        child: Text(
                          cat.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green, // Text color
                          ),
                        ),
                      ),
                      const SizedBox(
                          height: 16), // Space between title and table
                      // Table for details
                      Table(
                        columnWidths: const {
                          0: FixedColumnWidth(
                              110), // Fixed width for the first column
                          1: FlexColumnWidth(), // Flexible width for the second column
                        },
                        children: [
                          TableRow(
                            children: [
                              const Text("Breed",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(cat.breed),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text("Color",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(cat.color),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text("Age",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text("${cat.age} years old"),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text("Sex",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(cat.sex),
                            ],
                          ),
                          if (cat.vaccines.isNotEmpty)
                            TableRow(
                              children: [
                                const Text("Vaccines",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(cat.vaccines.join(", ")),
                              ],
                            ),
                          TableRow(
                            children: [
                              const Text("Characteristics",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(cat.characteristics.join(", ")),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text("Background",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(cat.background),
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
