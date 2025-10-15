import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recomiendalo/shared/models/user_mode.dart';

import 'package:recomiendalo/shared/widgets/app_scaffold.dart';
import 'package:recomiendalo/shared/widgets/primary_button.dart';
import 'package:recomiendalo/shared/widgets/inputs/app_text_field.dart';
import 'package:recomiendalo/shared/widgets/inputs/app_dropdown.dart';
import 'package:recomiendalo/shared/widgets/inputs/app_checkbox.dart';
import 'package:recomiendalo/shared/widgets/inputs/app_image_picker.dart';
import 'package:recomiendalo/shared/widgets/app_drawer.dart';
import 'package:recomiendalo/shared/widgets/inputs/app_tags_input.dart';
import 'package:recomiendalo/shared/providers/user_mode_provider.dart';

class JobCreateScreen extends ConsumerStatefulWidget {
  const JobCreateScreen({super.key});

  @override
  ConsumerState<JobCreateScreen> createState() => _JobCreateScreenState();
}

class _JobCreateScreenState extends ConsumerState<JobCreateScreen> {
  int _step = 0;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();
  final _locationController = TextEditingController();

  String? _category;
  String? _paymentMethod;
  bool _isRemote = false;
  List<File> _images = [];
  List<String> _tags = [];

  void _nextStep() {
    if (_step < 2) setState(() => _step++);
  }

  void _prevStep() {
    if (_step > 0) setState(() => _step--);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    /// Escuchar el modo global desde Riverpod
    final modeState = ref.watch(userModeProvider);
    final mode = modeState.value ?? UserMode.employer;

    // ⚠️ Bloquear si es colaborador
    if (mode == UserMode.colaborator) {
      return AppScaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(title: const Text("Publicar trabajo")),
        body: const Center(
          child: Text(
            "⚠️ Solo los empleadores pueden publicar trabajos",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    // ✅ Flujo normal para empleadores
    return AppScaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Publicar trabajo')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            _StepHeader(current: _step, total: 3),
            const SizedBox(height: 20),

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                child: _buildStepContent(_step, t),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                if (_step > 0)
                  Expanded(
                    child: PrimaryButton(
                      text: 'Atrás',
                      onPressed: _prevStep,
                    ),
                  ),
                if (_step > 0) const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        if (_step < 2) {
                          _nextStep();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Trabajo publicado: ${_titleController.text}',
                              ),
                            ),
                          );
                          context.pop();
                        }
                      },
                      child: Text(_step < 2 ? 'Siguiente' : 'Publicar'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(int step, TextTheme t) {
    switch (step) {
      case 0:
        return SingleChildScrollView(
          key: const ValueKey('step1'),
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Detalles del trabajo', style: t.titleLarge),
              const SizedBox(height: 20),

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
              const SizedBox(height: 24),

              AppDropdown<String>(
                label: 'Categoría',
                hint: 'Selecciona una categoría',
                value: _category,
                onChanged: (val) => setState(() => _category = val),
                items: const [
                  DropdownMenuItem(value: 'Carpintería', child: Text('Carpintería')),
                  DropdownMenuItem(value: 'Electricidad', child: Text('Electricidad')),
                  DropdownMenuItem(value: 'Limpieza', child: Text('Limpieza')),
                  DropdownMenuItem(value: 'Otros', child: Text('Otros')),
                ],
              ),
              const SizedBox(height: 20),

              AppTagsInput(
                label: 'Etiquetas del trabajo',
                initialTags: const [],
                onChanged: (tags) => setState(() => _tags = tags),
              ),
            ],
          ),
        );

      case 1:
        return SingleChildScrollView(
          key: const ValueKey('step2'),
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Presupuesto, pago y ubicación', style: t.titleLarge),
              const SizedBox(height: 20),

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

              Text('Ubicación', style: t.titleLarge),
              const SizedBox(height: 12),

              AppCheckbox(
                label: 'Trabajo remoto (no requiere ubicación)',
                value: _isRemote,
                onChanged: (val) => setState(() => _isRemote = val ?? false),
              ),
              const SizedBox(height: 12),

              if (!_isRemote) ...[
                AppTextField(
                  label: 'Ubicación',
                  hint: 'Ej: San Juan de Lurigancho, Lima',
                  controller: _locationController,
                ),
                const SizedBox(height: 8),
                Text(
                  'Indica distrito/ciudad para que el colaborador evalúe tiempos y costos.',
                  style: t.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
              const SizedBox(height: 28),

              AppImagePicker(
                label: 'Imágenes de referencia (opcional)',
                onImagesSelected: (files) {
                  setState(() => _images = files);
                },
              ),
            ],
          ),
        );

      default:
        return SingleChildScrollView(
          key: const ValueKey('step3'),
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Resumen', style: t.titleLarge),
              const SizedBox(height: 16),

              _SummaryItem(label: 'Título', value: _titleController.text),
              _SummaryItem(label: 'Descripción', value: _descriptionController.text),
              _SummaryItem(label: 'Categoría', value: _category ?? '—'),
              _SummaryItem(label: 'Etiquetas', value: _tags.join(', ')),
              _SummaryItem(
                label: 'Modalidad',
                value: _isRemote ? 'Remoto' : 'Presencial',
              ),
              if (!_isRemote)
                _SummaryItem(label: 'Ubicación', value: _locationController.text),
              _SummaryItem(
                label: 'Presupuesto',
                value: _budgetController.text.isEmpty
                    ? '—'
                    : 'S/ ${_budgetController.text}',
              ),
              _SummaryItem(
                label: 'Método de pago',
                value: _paymentMethod ?? '—',
              ),

              const SizedBox(height: 20),
              Text('Imágenes', style: t.titleMedium?.copyWith(color: Colors.grey[700])),
              const SizedBox(height: 8),

              if (_images.isEmpty)
                Text('Sin imágenes', style: t.bodyMedium)
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _images.map((file) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        file,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 12),
              Text(
                'Así lo verá el colaborador cuando entre al detalle del trabajo.',
                style: t.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        );
    }
  }
}

/// Header de pasos
class _StepHeader extends StatelessWidget {
  final int current;
  final int total;

  const _StepHeader({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    Widget dot(bool active, String text) {
      return Column(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: active ? colors.primary : Colors.grey[300],
            child: Icon(
              active ? Icons.check : Icons.circle,
              size: active ? 14 : 8,
              color: active ? colors.onPrimary : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(text, style: Theme.of(context).textTheme.labelMedium),
        ],
      );
    }

    Widget line(bool filled) {
      return Expanded(
        child: Container(
          height: 2,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          color: filled ? colors.primary : Colors.grey[300],
        ),
      );
    }

    return Row(
      children: [
        dot(current >= 0, 'Paso 1'),
        line(current >= 1),
        dot(current >= 1, 'Paso 2'),
        line(current >= 2),
        dot(current >= 2, 'Paso 3'),
      ],
    );
  }
}

/// Item resumen
class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: t.labelMedium?.copyWith(
                color: Colors.grey[600],
              )),
          const SizedBox(height: 4),
          Text(value.isEmpty ? '—' : value, style: t.bodyMedium),
        ],
      ),
    );
  }
}
