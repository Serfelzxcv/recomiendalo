import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AppImagePicker extends StatefulWidget {
  final String label;
  final void Function(List<File>) onImagesSelected;

  const AppImagePicker({
    super.key,
    required this.label,
    required this.onImagesSelected,
  });

  @override
  State<AppImagePicker> createState() => _AppImagePickerState();
}

class _AppImagePickerState extends State<AppImagePicker> {
  List<File> _images = [];

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _images = pickedFiles.map((f) => File(f.path)).toList();
      });
      widget.onImagesSelected(_images);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickImages,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey.shade100,
            ),
            height: 150,
            width: double.infinity,
            child: _images.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_outlined, size: 40, color: colors.primary),
                      const SizedBox(height: 8),
                      const Text("Toca para seleccionar imágenes"),
                    ],
                  )
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _images[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
