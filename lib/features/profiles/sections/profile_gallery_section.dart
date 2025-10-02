import 'package:flutter/material.dart';

class ProfileGallerySection extends StatelessWidget {
  final List<String> gallery;

  const ProfileGallerySection({super.key, required this.gallery});

  @override
  Widget build(BuildContext context) {
    if (gallery.isEmpty) {
      return const Center(child: Text("No hay imágenes aún"));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: gallery.length,
      itemBuilder: (context, index) {
        return Image.network(gallery[index], fit: BoxFit.cover);
      },
    );
  }
}
