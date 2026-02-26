import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recomiendalo/shared/models/user_mode.dart';
import 'package:recomiendalo/core/router/app_routes.dart';

import 'package:recomiendalo/shared/widgets/app_scaffold.dart';
import 'package:recomiendalo/shared/widgets/primary_button.dart';
import 'package:recomiendalo/shared/widgets/inputs/app_text_field.dart';
import 'package:recomiendalo/shared/widgets/inputs/app_dropdown.dart';
import 'package:recomiendalo/shared/widgets/inputs/app_checkbox.dart';
import 'package:recomiendalo/shared/widgets/inputs/app_image_picker.dart';
import 'package:recomiendalo/shared/widgets/app_drawer.dart';
import 'package:recomiendalo/shared/widgets/inputs/app_tags_input.dart';
import 'package:recomiendalo/shared/providers/user_mode_provider.dart';
import 'package:recomiendalo/shared/widgets/secondary_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recomiendalo/features/jobs/models/job_model.dart';

class JobCreateScreen extends ConsumerStatefulWidget {
  final JobModel? jobToEdit;

  const JobCreateScreen({super.key, this.jobToEdit});

  @override
  ConsumerState<JobCreateScreen> createState() => _JobCreateScreenState();
}

class _JobCreateScreenState extends ConsumerState<JobCreateScreen> {
  static const String _jobsImagesBucket = 'private_images';

  int _step = 0;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();
  final _locationController = TextEditingController();

  String? _category;
  String? _paymentMethod;
  bool _isRemote = false;
  List<File> _images = [];
  List<String> _existingImages = [];
  Map<String, String> _signedImageUrls = {};
  List<String> _tags = [];
  bool _isPublishing = false;
  bool get _isEditing => widget.jobToEdit != null;

  @override
  void initState() {
    super.initState();
    final job = widget.jobToEdit;
    if (job == null) return;

    _titleController.text = job.title;
    _descriptionController.text = job.description;
    _budgetController.text = job.budget?.toString() ?? '';
    _locationController.text = job.location;
    _category = job.category;
    _paymentMethod = job.paymentMethod;
    _isRemote = job.isRemote;
    _tags = List<String>.from(job.tags);
    _existingImages = List<String>.from(job.images);
    Future.microtask(_refreshExistingImagePreviews);
  }

  Future<void> _refreshExistingImagePreviews() async {
    if (_existingImages.isEmpty) {
      if (!mounted) return;
      setState(() => _signedImageUrls = {});
      return;
    }

    final storage = Supabase.instance.client.storage.from(_jobsImagesBucket);
    final signedUrls = <String, String>{};

    for (final imagePath in _existingImages) {
      final trimmed = imagePath.trim();
      if (trimmed.isEmpty) continue;

      final isRemote =
          trimmed.startsWith('http://') || trimmed.startsWith('https://');
      if (isRemote) {
        signedUrls[trimmed] = trimmed;
        continue;
      }

      try {
        final signedUrl = await storage.createSignedUrl(trimmed, 60 * 60);
        signedUrls[trimmed] = signedUrl;
      } catch (_) {
        // Si la ruta no existe o no se puede firmar, se ignora en preview.
      }
    }

    if (!mounted) return;
    setState(() => _signedImageUrls = signedUrls);
  }

  String _buildStoragePath({required String userId, required File file}) {
    final fileName = file.path.split('/').last;
    final safeName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final now = DateTime.now().millisecondsSinceEpoch;
    return 'jobs/$userId/$now-$safeName';
  }

  Future<List<String>> _uploadNewImages(String userId) async {
    if (_images.isEmpty) return const [];

    final storage = Supabase.instance.client.storage.from(_jobsImagesBucket);
    final uploadedPaths = <String>[];

    for (final file in _images) {
      final path = _buildStoragePath(userId: userId, file: file);
      await storage.upload(path, file, fileOptions: const FileOptions());
      uploadedPaths.add(path);
    }

    return uploadedPaths;
  }

  void _nextStep() {
    if (_step < 2) setState(() => _step++);
  }

  void _prevStep() {
    if (_step > 0) setState(() => _step--);
  }

  String? _validateStep(int step) {
    if (step == 0) {
      if (_titleController.text.trim().isEmpty) return 'Ingresa un título';
      if (_descriptionController.text.trim().isEmpty) {
        return 'Ingresa una descripción';
      }
      if ((_category ?? '').trim().isEmpty) return 'Selecciona una categoría';
    }
    if (step == 1 && !_isRemote && _locationController.text.trim().isEmpty) {
      return 'Ingresa una ubicación o marca trabajo remoto';
    }
    return null;
  }

  Future<void> _handleMainAction() async {
    if (_isPublishing) return;

    final validationError = _validateStep(_step);
    if (validationError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(validationError)));
      return;
    }

    if (_step < 2) {
      _nextStep();
      return;
    }

    await _saveJob();
  }

  Future<void> _saveJob() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Debes iniciar sesión para editar'
                : 'Debes iniciar sesión para publicar',
          ),
        ),
      );
      return;
    }

    final budgetText = _budgetController.text.trim();
    final normalizedBudget = budgetText.replaceAll(',', '.');
    final parsedBudget = normalizedBudget.isEmpty
        ? null
        : double.tryParse(normalizedBudget);

    if (budgetText.isNotEmpty && parsedBudget == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Presupuesto inválido')));
      return;
    }

    final now = DateTime.now().toUtc().toIso8601String();

    setState(() => _isPublishing = true);
    try {
      final uploadedImagePaths = await _uploadNewImages(user.id);
      final imagePaths = [..._existingImages, ...uploadedImagePaths];

      final payload = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': (_category ?? '').trim(),
        'location': _isRemote ? '' : _locationController.text.trim(),
        'budget': parsedBudget,
        'payment_method': _paymentMethod,
        'is_remote': _isRemote,
        'tags': _tags,
        'images': imagePaths,
        'updated_at': now,
      };

      if (_isEditing) {
        await Supabase.instance.client
            .from('jobs')
            .update(payload)
            .eq('id', widget.jobToEdit!.id)
            .eq('person_id', user.id);
      } else {
        await Supabase.instance.client.from('jobs').insert({
          'person_id': user.id,
          ...payload,
          'created_at': now,
        });
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Trabajo actualizado correctamente'
                : 'Trabajo publicado correctamente',
          ),
        ),
      );
      context.go(AppRoutes.home);
    } on StorageException catch (e, st) {
      debugPrint(
        '[JobCreateScreen._saveJob][StorageException] message=${e.message} statusCode=${e.statusCode} error=${e.error}',
      );
      debugPrintStack(stackTrace: st);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al subir imágenes: ${e.message}')));
    } on PostgrestException catch (e, st) {
      debugPrint(
        '[JobCreateScreen._saveJob][PostgrestException] message=${e.message} code=${e.code} details=${e.details} hint=${e.hint}',
      );
      debugPrintStack(stackTrace: st);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e, st) {
      debugPrint('[JobCreateScreen._saveJob][Exception] $e');
      debugPrintStack(stackTrace: st);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Error al editar el trabajo'
                : 'Error al publicar el trabajo',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isPublishing = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    _locationController.dispose();
    super.dispose();
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
        appBar: AppBar(
          title: Text(_isEditing ? 'Editar trabajo' : 'Publicar trabajo'),
        ),
        body: const Center(
          child: Text(
            '⚠️ Solo los empleadores pueden publicar trabajos',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    // ✅ Flujo normal para empleadores
    return AppScaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar trabajo' : 'Publicar trabajo'),
      ),
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
                    child: PrimaryButton(text: 'Atrás', onPressed: _prevStep),
                  ),
                if (_step > 0) const SizedBox(width: 12),
                Expanded(
                  child: SecondaryButton(
                    text: _isPublishing
                        ? (_isEditing ? 'Guardando...' : 'Publicando...')
                        : (_step < 2
                              ? 'Siguiente'
                              : (_isEditing ? 'Actualizar' : 'Publicar')),
                    onPressed: _isPublishing ? null : _handleMainAction,
                    loading: _isPublishing,
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
                  DropdownMenuItem(
                    value: 'Carpintería',
                    child: Text('Carpintería'),
                  ),
                  DropdownMenuItem(
                    value: 'Electricidad',
                    child: Text('Electricidad'),
                  ),
                  DropdownMenuItem(value: 'Limpieza', child: Text('Limpieza')),
                  DropdownMenuItem(value: 'Otros', child: Text('Otros')),
                ],
              ),
              const SizedBox(height: 20),

              AppTagsInput(
                label: 'Etiquetas del trabajo',
                key: ValueKey(_isEditing ? widget.jobToEdit!.id : 'new-job'),
                initialTags: _tags,
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
                  DropdownMenuItem(
                    value: 'Transferencia',
                    child: Text('Transferencia'),
                  ),
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
                  style: t.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.65),
                  ),
                ),
              ],
              const SizedBox(height: 28),

              AppImagePicker(
                label: 'Selecciona una o más imágenes de referencia (opcional)',
                initialImages: _existingImages,
                signedImageUrls: _signedImageUrls,
                key: ValueKey(
                  _isEditing ? 'img-${widget.jobToEdit!.id}' : 'img-new',
                ),
                onImagesSelected: (files, existingImages) {
                  setState(() {
                    _images = files;
                    _existingImages = existingImages;
                  });
                  _refreshExistingImagePreviews();
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
              _SummaryItem(
                label: 'Descripción',
                value: _descriptionController.text,
              ),
              _SummaryItem(label: 'Categoría', value: _category ?? '—'),
              _SummaryItem(label: 'Etiquetas', value: _tags.join(', ')),
              _SummaryItem(
                label: 'Modalidad',
                value: _isRemote ? 'Remoto' : 'Presencial',
              ),
              if (!_isRemote)
                _SummaryItem(
                  label: 'Ubicación',
                  value: _locationController.text,
                ),
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
              Text(
                'Imágenes',
                style: t.titleMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: 8),

              if (_images.isEmpty && _existingImages.isEmpty)
                Text('Sin imágenes', style: t.bodyMedium)
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._existingImages.map(
                      (image) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildImagePreview(image),
                      ),
                    ),
                    ..._images.map(
                      (file) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          file,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 12),
              Text(
                'Así lo verá el colaborador cuando entre al detalle del trabajo.',
                style: t.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildImagePreview(String path) {
    final signed = _signedImageUrls[path];
    if (signed != null && signed.isNotEmpty) {
      return Image.network(
        signed,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (_, error, stackTrace) => const _BrokenImage(),
      );
    }

    final isRemote = path.startsWith('http://') || path.startsWith('https://');
    if (isRemote) {
      return Image.network(
        path,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (_, error, stackTrace) => const _BrokenImage(),
      );
    }

    if (!File(path).existsSync()) {
      return const _BrokenImage();
    }

    return Image.file(
      File(path),
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      errorBuilder: (_, error, stackTrace) => const _BrokenImage(),
    );
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
      final inactive = colors.onSurface.withValues(alpha: 0.25);
      final inactiveIcon = colors.onSurface.withValues(alpha: 0.55);
      return Column(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: active ? colors.primary : inactive,
            child: Icon(
              active ? Icons.check : Icons.circle,
              size: active ? 14 : 8,
              color: active ? colors.onPrimary : inactiveIcon,
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
          color: filled
              ? colors.primary
              : colors.outline.withValues(alpha: 0.35),
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
        border: Border.all(color: colors.outline.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: t.labelMedium?.copyWith(
              color: colors.onSurface.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 4),
          Text(value.isEmpty ? '—' : value, style: t.bodyMedium),
        ],
      ),
    );
  }
}

class _BrokenImage extends StatelessWidget {
  const _BrokenImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.broken_image_outlined,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
      ),
    );
  }
}
