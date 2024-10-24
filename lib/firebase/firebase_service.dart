import 'dart:io'; // Untuk mengakses file lokal
import 'package:firebase_storage/firebase_storage.dart'; // Untuk Firebase Storage
import 'package:cloud_firestore/cloud_firestore.dart'; // Untuk Firestore

class FirebaseService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi untuk mengupload gambar ke Firebase Storage
  Future<void> uploadImage(File imageFile) async {
    try {
      // Referensi lokasi penyimpanan di Firebase Storage
      String fileName = DateTime.now().toIso8601String();
      Reference storageRef = _storage.ref().child('gallery/$fileName');
      
      // Upload file ke Firebase Storage
      UploadTask uploadTask = storageRef.putFile(imageFile);
      await uploadTask;

      // Mendapatkan URL download dari gambar yang diupload
      String downloadUrl = await storageRef.getDownloadURL();

      // Menyimpan URL gambar ke Firestore
      await _firestore.collection('gallery').add({
        'url': downloadUrl,
        'uploaded_at': Timestamp.now(),
      });

      print("Gambar berhasil di-upload dan URL disimpan di Firestore.");
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  // Mendapatkan stream gambar dari Firestore
  Stream<QuerySnapshot> getGalleryImages() {
    return _firestore.collection('gallery').orderBy('uploaded_at', descending: true).snapshots();
  }
}
