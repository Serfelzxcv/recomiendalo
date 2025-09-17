import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recomiendalo/shared/widgets/app_scaffold.dart';
import 'package:recomiendalo/shared/widgets/primary_button.dart';
import 'package:recomiendalo/shared/widgets/inputs/app_text_field.dart';
import 'package:recomiendalo/shared/widgets/inputs/app_dropdown.dart';
import 'package:recomiendalo/shared/widgets/inputs/app_checkbox.dart';
import 'package:recomiendalo/shared/widgets/inputs/app_image_picker.dart';

class JobCreateScreen extends StatefulWidget {
  const JobCreateScreen({super.key});

  @override
  State<JobCreateScreen> createState() => _JobCreateScreenState();
}

class _JobCreateScreenState extends State<JobCreateScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();
  final _locationController = TextEditingController();

  String? _category;
  String? _paymentMethod;
  bool _isRemote = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text("Publicar trabajo"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: 'Título',
              hint: 'Ej: Necesito maestro melaminero',
              controller: _titleController,
            ),
            const SizedBox(height: 16),

            AppTextField(
              label: 'Descripción',
              hint: 'Describe lo que necesitas con detalle',
              controller: _descriptionController,
              maxLines: 4,
            ),
            const SizedBox(height: 16),

            AppDropdown<String>(
              label: 'Categoría',
              value: _category,
              onChanged: (val) => setState(() => _category = val),
              items: const [
                DropdownMenuItem(value: 'Carpintería', child: Text('Carpintería')),
                DropdownMenuItem(value: 'Electricidad', child: Text('Electricidad')),
                DropdownMenuItem(value: 'Limpieza', child: Text('Limpieza')),
                DropdownMenuItem(value: 'Otros', child: Text('Otros')),
              ],
            ),
            const SizedBox(height: 16),

            AppTextField(
              label: 'Ubicación',
              hint: 'Ej: San Juan de Lurigancho, Lima',
              controller: _locationController,
            ),
            const SizedBox(height: 8),

            AppCheckbox(
              label: 'Trabajo remoto / no presencial',
              value: _isRemote,
              onChanged: (val) => setState(() => _isRemote = val ?? false),
            ),
            const SizedBox(height: 16),

            AppTextField(
              label: 'Presupuesto estimado (S/)',
              hint: 'Ej: 150',
              controller: _budgetController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            AppDropdown<String>(
              label: 'Método de pago',
              value: _paymentMethod,
              onChanged: (val) => setState(() => _paymentMethod = val),
              items: const [
                DropdownMenuItem(value: 'Yape', child: Text('Yape')),
                DropdownMenuItem(value: 'Plin', child: Text('Plin')),
                DropdownMenuItem(value: 'Transferencia', child: Text('Transferencia')),
                DropdownMenuItem(value: 'Efectivo', child: Text('Efectivo')),
              ],
            ),
            const SizedBox(height: 16),

            AppImagePicker(
              label: 'Imagen de referencia (opcional)',
              onImageSelected: (file) {
                // por ahora solo demo
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Imagen seleccionada')),
                );
              },
            ),
            const SizedBox(height: 24),

            PrimaryButton(
              text: 'Publicar trabajo',
              onPressed: () {
                // Simulación de guardado (hardcoded)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Trabajo publicado: ${_titleController.text}',
                    ),
                  ),
                );
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
