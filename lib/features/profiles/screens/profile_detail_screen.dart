import 'package:flutter/material.dart';
import 'package:recomiendalo/features/profiles/models/profile_model.dart';
import 'package:recomiendalo/features/profiles/sections/profile_gallery_section.dart';
import 'package:recomiendalo/features/profiles/sections/profile_info_section.dart';
import 'package:recomiendalo/features/profiles/sections/profile_references_section.dart';

class ProfileDetailScreen extends StatefulWidget {
  final ProfileModel profile;

  const ProfileDetailScreen({super.key, required this.profile});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil del trabajador"), // 🔹 Título más genérico
      ),
      body: Column(
        children: [
          // 🔹 Header con avatar, nombre y rating
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: profile.avatarUrl != null
                      ? NetworkImage(profile.avatarUrl!)
                      : null,
                  child: profile.avatarUrl == null
                      ? Text(profile.fullName[0], style: const TextStyle(fontSize: 28))
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.fullName, style: Theme.of(context).textTheme.titleLarge),
                      Text(profile.role),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          Text(profile.rating.toStringAsFixed(1)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🔹 TabBar con estilo tipo Instagram
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.grid_on)),       // Galería
              Tab(icon: Icon(Icons.reviews)),       // Referencias
              Tab(icon: Icon(Icons.info_outline)),  // Info
            ],
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ProfileGallerySection(gallery: profile.gallery),
                ProfileReferencesSection(profileId: profile.id),
                ProfileInfoSection(profile: profile),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
