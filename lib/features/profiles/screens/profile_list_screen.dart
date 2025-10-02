import 'package:flutter/material.dart';
import 'package:recomiendalo/features/profiles/models/profile_model.dart';
import 'package:recomiendalo/features/profiles/screens/profile_detail_screen.dart';
import 'package:recomiendalo/shared/widgets/app_scaffold.dart';
import 'package:recomiendalo/shared/widgets/app_drawer.dart';

// 🔹 Perfiles de prueba
final mockProfiles = [
  ProfileModel(
    id: "1",
    userId: "u1",
    name: "José Albañil",
    role: "Albañil",
    description: "Especialista en construcción y remodelación.",
    avatarUrl: null,
    gallery: [
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/301",
    ],
    rating: 4.5,
  ),
  ProfileModel(
    id: "2",
    userId: "u1",
    name: "Ferretería San Juan",
    role: "Ferretería",
    description: "Herramientas y materiales de calidad.",
    avatarUrl: null,
    gallery: [
      "https://picsum.photos/200/302",
      "https://picsum.photos/200/303",
    ],
    rating: 5,
  ),
];

class ProfileListScreen extends StatelessWidget {
  const ProfileListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      drawer: AppDrawer(
        mode: UserMode.colaborator, // 👈 luego lo hacemos dinámico
        onToggleMode: () => Navigator.of(context).pop(),
      ),
      appBar: AppBar(title: const Text("Mis Perfiles")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockProfiles.length,
        itemBuilder: (context, index) {
          final profile = mockProfiles[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: profile.avatarUrl != null
                    ? NetworkImage(profile.avatarUrl!)
                    : null,
                child: profile.avatarUrl == null
                    ? Text(profile.name[0])
                    : null,
              ),
              title: Text(profile.name),
              subtitle: Row(
                children: [
                  Text(profile.role),
                  const SizedBox(width: 8),
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  Text(profile.rating.toStringAsFixed(1)),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileDetailScreen(profile: profile),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
