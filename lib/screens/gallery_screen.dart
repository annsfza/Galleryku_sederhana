import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:image_picker/image_picker.dart'; // Untuk memilih gambar
import 'package:myapp/firebase/firebase_service.dart'; // Firebase service
import 'package:myapp/widgets/image_grid.dart'; // Grid untuk menampilkan gambar
import 'package:myapp/widgets/bar_menu.dart'; // BarMenu widget

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final FirebaseService firebaseService = FirebaseService();
  int _selectedIndex = 0;

  // Fungsi untuk mengatur indeks yang dipilih
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    // Aksi berdasarkan item yang dipilih
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
        titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        backgroundColor: Colors.black,
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
          return ImageGrid(docs: docs);
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
      bottomNavigationBar: BarMenu(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
