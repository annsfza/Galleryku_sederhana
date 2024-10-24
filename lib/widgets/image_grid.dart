import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore

class ImageGrid extends StatelessWidget {
  final List<QueryDocumentSnapshot> docs;

  ImageGrid({required this.docs});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Dua kolom untuk grid
      ),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        String imageUrl = docs[index]['url']; // URL gambar dari Firestore
        return Image.network(imageUrl); // Menampilkan gambar dari URL
      },
    );
  }
}
