import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/firebase/firebase_service.dart';
import 'package:myapp/widgets/image_grid.dart';
import 'package:myapp/widgets/bar_menu.dart';
import 'package:myapp/widgets/album_grid.dart'; // Tambahkan AlbumGrid

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final FirebaseService firebaseService = FirebaseService();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Gallery' : 'Album'),
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
          return _selectedIndex == 0
              ? ImageGrid(docs: docs) // Tampilan default: menampilkan grid biasa
              : AlbumGrid(docs: docs); // Tampilan album berdasarkan tanggal
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
