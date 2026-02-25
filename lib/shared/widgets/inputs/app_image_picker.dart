import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AppImagePicker extends StatefulWidget {
  final String label;
  final List<String> initialImages;
  final void Function(List<File> files, List<String> existingImages)
  onImagesSelected;

  const AppImagePicker({
    super.key,
    required this.label,
    this.initialImages = const [],
    required this.onImagesSelected,
  });

  @override
  State<AppImagePicker> createState() => _AppImagePickerState();
}

class _AppImagePickerState extends State<AppImagePicker> {
  final List<File> _files = [];
  late List<String> _existingImages;

  @override
  void initState() {
    super.initState();
    _existingImages = List<String>.from(widget.initialImages);
  }

  void _emitChange() {
    widget.onImagesSelected(
      List<File>.from(_files),
      List<String>.from(_existingImages),
    );
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> picked = await picker.pickMultiImage();

    if (picked.isNotEmpty) {
      setState(() {
        final newFiles = picked.map((x) => File(x.path)).toList();
        _files.addAll(newFiles);
        _emitChange();
      });
    }
  }

  void _removeImage(File file) {
    setState(() {
      _files.remove(file);
      _emitChange();
    });
  }

  void _removeExistingImage(String image) {
    setState(() {
      _existingImages.remove(image);
      _emitChange();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Imágenes', style: t.titleMedium),
        const SizedBox(height: 6),
        Text(
          widget.label,
          style: t.labelSmall?.copyWith(
            color: colors.onSurface.withValues(alpha: 0.68),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._existingImages.map((image) {
              final isRemote = image.startsWith('http://') ||
                  image.startsWith('https://');
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: isRemote
                        ? Image.network(
                            image,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, error, stackTrace) =>
                                _errorTile(colors),
                          )
                        : Image.file(
                            File(image),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, error, stackTrace) =>
                                _errorTile(colors),
                          ),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: () => _removeExistingImage(image),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.scrim.withValues(alpha: 0.45),
                        ),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
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
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.scrim.withValues(alpha: 0.45),
                        ),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
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
                  border: Border.all(
                    color: colors.outline.withValues(alpha: 0.5),
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: colors.surface.withValues(alpha: 0.8),
                ),
                child: Icon(
                  Icons.add,
                  size: 30,
                  color: colors.onSurface.withValues(alpha: 0.55),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _errorTile(ColorScheme colors) {
    return Container(
      width: 80,
      height: 80,
      color: colors.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.broken_image_outlined,
        color: colors.onSurface.withValues(alpha: 0.6),
      ),
    );
  }
}
