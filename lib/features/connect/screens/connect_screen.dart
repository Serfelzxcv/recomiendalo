import 'package:flutter/material.dart';
import 'package:recomiendalo/shared/widgets/app_scaffold.dart';
import 'package:recomiendalo/shared/widgets/app_drawer.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({super.key});

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  String query = "";

  final List<Map<String, dynamic>> categories = [
    {"title": "Gasfiteros", "icon": Icons.water_damage_outlined},
    {"title": "Electricistas", "icon": Icons.bolt_outlined},
    {"title": "Carpinteros", "icon": Icons.chair_outlined},
    {"title": "Albañiles", "icon": Icons.construction_outlined},
    {"title": "Pintores", "icon": Icons.format_paint_outlined},
    {"title": "Cerrajeros", "icon": Icons.lock_outline},
    {"title": "Mecánicos", "icon": Icons.build_circle_outlined},
    {"title": "Jardineros", "icon": Icons.grass_outlined},
  ];

  final List<Map<String, dynamic>> trendingCategories = [
    {"title": "Gasfiteros", "icon": Icons.water_damage_outlined},
    {"title": "Electricistas", "icon": Icons.bolt_outlined},
    {"title": "Albañiles", "icon": Icons.construction_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    // 🔹 Filtramos categorías por el query del buscador
    final filteredCategories = categories
        .where((c) =>
            c["title"].toString().toLowerCase().contains(query.toLowerCase()))
        .toList();

    return AppScaffold(
      drawer: AppDrawer(
        mode: UserMode.employer,
        onToggleMode: () => Navigator.of(context).pop(),
      ),
      appBar: AppBar(
        title: const Text("Conectar con trabajadores"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Search Box
            TextField(
              decoration: InputDecoration(
                hintText: "Buscar categoría...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() => query = value);
              },
            ),
            const SizedBox(height: 20),

            // 🔹 Categorías más concurridas
            Text(
              "Categorías más concurridas",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: trendingCategories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = trendingCategories[index];
                  return GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Abrir lista de ${item['title']}")),
                      );
                    },
                    child: Container(
                      width: 120,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item["icon"], size: 32, color: Colors.teal),
                          const SizedBox(height: 8),
                          Text(
                            item["title"],
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Todas las categorías (grid filtrado por búsqueda)
            Text(
              "Todas las categorías",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final item = filteredCategories[index];
                return GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Abrir lista de ${item['title']}")),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item["icon"], size: 48, color: Colors.teal),
                        const SizedBox(height: 12),
                        Text(item["title"],
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
