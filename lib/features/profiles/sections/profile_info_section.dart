import 'package:flutter/material.dart';
import 'package:recomiendalo/features/profiles/models/profile_model.dart';

class ProfileInfoSection extends StatelessWidget {
  final ProfileModel profile;

  const ProfileInfoSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          "Sobre ${profile.name}",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(profile.description),

        const SizedBox(height: 20),
        const Divider(),

        Text(
          "Datos de contacto",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: const [
            Icon(Icons.phone, size: 18),
            SizedBox(width: 8),
            Text("987 654 321"), // 🔹 mock, luego se hace dinámico
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: const [
            Icon(Icons.email, size: 18),
            SizedBox(width: 8),
            Text("correo@ejemplo.com"),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: const [
            Icon(Icons.location_on, size: 18),
            SizedBox(width: 8),
            Text("Lima, Perú"),
          ],
        ),
      ],
    );
  }
}
