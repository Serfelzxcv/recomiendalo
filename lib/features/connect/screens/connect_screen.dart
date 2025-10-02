import 'package:flutter/material.dart';
import 'package:recomiendalo/shared/widgets/app_scaffold.dart';
import 'package:recomiendalo/shared/widgets/app_drawer.dart';
import 'package:recomiendalo/features/connect/widgets/connect_button.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({super.key});

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  String query = "";
  String situation = "";
  bool showResults = false;

  // 🔹 Resultados hardcodeados para búsqueda directa
  final List<Map<String, String>> searchResults = [
    {"name": "Carlos Ramírez", "skill": "Electricista domiciliario"},
    {"name": "Luis Torres", "skill": "Mantenimiento eléctrico"},
    {"name": "Pedro Gutiérrez", "skill": "Instalación de cableado"},
  ];

  // 🔹 Resultados hardcodeados para IA
  final List<Map<String, String>> aiResults = [
    {"name": "Chef María López", "skill": "Bocaditos, catering"},
    {"name": "Chef Juan Pérez", "skill": "Pastelería y bocaditos"},
    {"name": "Cocinera Ana Torres", "skill": "Comida casera y rápida"},
  ];

  List<Map<String, String>> currentResults = [];

  void _searchFromCategory() {
    setState(() {
      currentResults = searchResults;
      showResults = true;
    });
  }

  void _searchFromAI() {
    setState(() {
      currentResults = aiResults;
      showResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            // 🔹 Búsqueda directa por categoría
            Text("Busca un profesional",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Ejem: "Electricista"',
                      prefixIcon: const Icon(Icons.search, color: Colors.teal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) => query = value,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 140, // ancho fijo para que no se expanda infinito
                  child: ConnectButton(
                    text: "Buscar",
                    onPressed: _searchFromCategory,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // 🔹 Sección AI
            Row(
              children: [
                const Icon(Icons.smart_toy_outlined,
                    color: Colors.teal, size: 32),
                const SizedBox(width: 8),
                Text("Describe tu necesidad",
                    style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),

            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    "Ejemplo: Tengo una reunión mañana y necesito cocineras o chefs...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (val) => situation = val,
            ),
            const SizedBox(height: 12),

            ConnectButton(
              text: "Buscar profesionales",
              onPressed: _searchFromAI,
            ),

            // 🔹 Resultados sugeridos
            if (showResults) ...[
              const SizedBox(height: 24),
              Text("Resultados sugeridos:",
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Column(
                children: currentResults.map((pro) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(pro["name"]!),
                      subtitle: Text(pro["skill"]!),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("Abrir perfil de ${pro['name']}..."),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
