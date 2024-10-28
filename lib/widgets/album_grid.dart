import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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

        return GestureDetector(
          onTap: () {
            _showImageDialog(context, images);
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateKey, // Judul album berdasarkan tanggal
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  // Menampilkan jumlah gambar pada tanggal ini
                  Text(
                    '${images.length} Images',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showImageDialog(BuildContext context, List<QueryDocumentSnapshot> images) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: double.infinity,
            height: 600, // Atur tinggi sesuai kebutuhan
            child: PhotoViewGallery.builder(
              itemCount: images.length,
              builder: (context, index) {
                String imageUrl = images[index]['url'];
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(imageUrl),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              },
              scrollPhysics: BouncingScrollPhysics(),
              backgroundDecoration: BoxDecoration(color: Colors.black),
              pageController: PageController(),
              onPageChanged: (index) {
                _showImageDetails(context, images[index]);
              },
            ),
          ),
        );
      },
    );
  }

  void _showImageDetails(BuildContext context, QueryDocumentSnapshot image) {
    String description = image['description'] ?? 'No description available'; // Misalnya, deskripsi gambar
    Timestamp timestamp = image['uploaded_at'];
    DateTime uploadedAt = timestamp.toDate();
    String uploadedAtString = '${uploadedAt.day}/${uploadedAt.month}/${uploadedAt.year}';

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Image Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Uploaded At: $uploadedAtString'),
              SizedBox(height: 4),
              Text('Description: $description'),
            ],
          ),
        );
      },
    );
  }
}