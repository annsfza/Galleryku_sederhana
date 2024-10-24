import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore

class ImageGrid extends StatelessWidget {
  final List<QueryDocumentSnapshot> docs;

  ImageGrid({required this.docs});

  @override
  Widget build(BuildContext context) {
    // Kelompokkan gambar berdasarkan tanggal
    Map<String, List<QueryDocumentSnapshot>> groupedDocs = {};
    for (var doc in docs) {
      Timestamp timestamp = doc['uploaded_at'];
      DateTime dateTime = timestamp.toDate();
      String dateKey = '${dateTime.day}/${dateTime.month}/${dateTime.year}';

      if (!groupedDocs.containsKey(dateKey)) {
        groupedDocs[dateKey] = [];
      }
      groupedDocs[dateKey]!.add(doc);
    }

    return ListView.builder(
      itemCount: groupedDocs.keys.length,
      itemBuilder: (context, index) {
        String dateKey = groupedDocs.keys.elementAt(index);
        List<QueryDocumentSnapshot> images = groupedDocs[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan tanggal di atas kelompok gambar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                dateKey, // Menampilkan tanggal
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            // Menampilkan gambar dalam grid
            GridView.builder(
              shrinkWrap: true, // Agar grid bisa dibungkus dalam Column
              physics: NeverScrollableScrollPhysics(), // Nonaktifkan scrolling pada grid
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Jumlah kolom
              ),
              itemCount: images.length,
              itemBuilder: (context, imageIndex) {
                String imageUrl = images[imageIndex]['url'];

                return Card(
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                  elevation: 2,
                  margin: EdgeInsets.all(4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
