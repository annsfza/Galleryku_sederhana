import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi untuk upload gambar ke Firebase Storage dan menyimpan metadata ke Firestore
  Future<void> uploadImage(File imageFile) async {
    try {
      // Buat referensi penyimpanan
      String fileName = DateTime.now().millisecondsSinceEpoch.toString(); // Unique file name
      Reference storageRef = _storage.ref().child('gallery/$fileName');

      // Upload gambar ke Storage
      UploadTask uploadTask = storageRef.putFile(imageFile);
      await uploadTask;

      // Mendapatkan URL download dari gambar yang di-upload
      String downloadUrl = await storageRef.getDownloadURL();

      // Menyimpan URL gambar dan waktu upload ke Firestore
      await _firestore.collection('gallery').add({
        'url': downloadUrl,
        'uploaded_at': Timestamp.now(), // Menyimpan timestamp saat upload
      });
      print("Gambar berhasil di-upload dan URL disimpan.");
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  // Mendapatkan Stream dari gambar di Firestore
  Stream<QuerySnapshot> getGalleryImages() {
    return _firestore.collection('gallery').orderBy('uploaded_at', descending: true).snapshots();
  }
}
