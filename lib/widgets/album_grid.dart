import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlbumGrid extends StatelessWidget {
  final List<QueryDocumentSnapshot> docs;

  AlbumGrid({required this.docs});

  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                dateKey, // Judul album berdasarkan tanggal
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: images.length,
              itemBuilder: (context, imageIndex) {
                String imageUrl = images[imageIndex]['url'];

                return Card(
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
