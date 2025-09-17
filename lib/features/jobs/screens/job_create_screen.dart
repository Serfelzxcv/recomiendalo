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
  bool _isRemote = false; // por defecto presencial

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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Sección: Detalles
            Text("Detalles del trabajo",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),

            AppTextField(
              label: 'Título',
              hint: 'Ej: Necesito maestro melaminero',
              controller: _titleController,
            ),
            const SizedBox(height: 20),

            AppTextField(
              label: 'Descripción',
              hint: 'Describe lo que necesitas con detalle',
              controller: _descriptionController,
              maxLines: 4,
            ),
            const SizedBox(height: 28),

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
            const SizedBox(height: 28),

            /// Sección: Ubicación
            Text("Ubicación",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),

            AppCheckbox(
              label: 'Trabajo remoto (no requiere ubicación)',
              value: _isRemote,
              onChanged: (val) => setState(() => _isRemote = val ?? false),
            ),
            const SizedBox(height: 16),

            if (!_isRemote) ...[
              AppTextField(
                label: 'Ubicación',
                hint: 'Ej: San Juan de Lurigancho, Lima',
                controller: _locationController,
              ),
              const SizedBox(height: 28),
            ],

            /// Sección: Presupuesto
            Text("Presupuesto y pago",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),

            AppTextField(
              label: 'Presupuesto estimado (S/)',
              hint: 'Ej: 150',
              controller: _budgetController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

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
            const SizedBox(height: 28),

            /// Sección: Extras
            Text("Extras",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),

            AppImagePicker(
              label: 'Imágenes de referencia (opcional)',
              onImagesSelected: (files) {
                // por ahora solo demo
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${files.length} imágenes seleccionadas')),
                );
              },
            ),
            const SizedBox(height: 40),

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
