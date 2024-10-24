import 'dart:io'; // Untuk mengakses File
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:image_picker/image_picker.dart'; // Untuk memilih gambar
import 'package:myapp/firebase/firebase_service.dart'; // Firebase service
import 'package:myapp/widgets/image_grid.dart'; // Grid untuk menampilkan gambar

class GalleryScreen extends StatelessWidget {
  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firebaseService.getGalleryImages(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading images'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

          return ImageGrid(docs: docs); // Widget untuk menampilkan gambar dalam grid
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final picker = ImagePicker();
          XFile? result = await picker.pickImage(source: ImageSource.gallery);

          if (result != null) {
            File imageFile = File(result.path);
            await firebaseService.uploadImage(imageFile);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
