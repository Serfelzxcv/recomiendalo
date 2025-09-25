import 'package:flutter/material.dart';

class AppTagsInput extends StatefulWidget {
  final String label;
  final List<String> initialTags;
  final void Function(List<String>) onChanged;

  const AppTagsInput({
    super.key,
    required this.label,
    this.initialTags = const [],
    required this.onChanged,
  });

  @override
  State<AppTagsInput> createState() => _AppTagsInputState();
}

class _AppTagsInputState extends State<AppTagsInput> {
  final TextEditingController _controller = TextEditingController();
  late List<String> _tags;

  @override
  void initState() {
    super.initState();
    _tags = List.from(widget.initialTags);
  }

  void _addTag(String tag) {
    if (tag.trim().isEmpty) return;
    if (_tags.contains(tag)) return;
    setState(() {
      _tags.add(tag.trim());
      _controller.clear();
      widget.onChanged(_tags);
    });
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
      widget.onChanged(_tags);
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: t.labelMedium),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: colors.outline.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Chips existentes
              ..._tags.map((tag) {
                return Chip(
                  label: Text(tag),
                  backgroundColor: colors.surfaceVariant,
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () => _removeTag(tag),
                );
              }),
              // Input + botón
              SizedBox(
                width: 120,
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: 'Agregar...',
                  ),
                  onSubmitted: _addTag,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle),
                color: colors.primary,
                onPressed: () => _addTag(_controller.text),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
