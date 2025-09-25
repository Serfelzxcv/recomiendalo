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
  final List<File> _files = [];

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> picked = await picker.pickMultiImage();

    if (picked.isNotEmpty) {
      setState(() {
        final newFiles = picked.map((x) => File(x.path)).toList();
        _files.addAll(newFiles);
        widget.onImagesSelected(_files);
      });
    }
  }

  void _removeImage(File file) {
    setState(() {
      _files.remove(file);
      widget.onImagesSelected(_files);
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Imágenes', style: t.titleMedium),
        const SizedBox(height: 6),
        Text(widget.label, style: t.labelSmall?.copyWith(color: Colors.grey[600])),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // Miniaturas
            ..._files.map((file) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      file,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: () => _removeImage(file),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              );
            }),
            // Botón +
            GestureDetector(
              onTap: _pickImages,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade100,
                ),
                child: const Icon(Icons.add, size: 30, color: Colors.grey),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
