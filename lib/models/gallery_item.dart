// lib/models/gallery_item.dart
class GalleryItem {
  final String id;
  final String imageUrl;

  GalleryItem({required this.id, required this.imageUrl});

  factory GalleryItem.fromMap(Map<String, dynamic> data, String id) {
    return GalleryItem(
      id: id,
      imageUrl: data['url'],
    );
  }
}
