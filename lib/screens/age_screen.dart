import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AgeScreen extends StatefulWidget {
  const AgeScreen({super.key});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  final _controller = TextEditingController();
  bool _loading = false;
  String? _error;
  Map<String, dynamic>? _result;

  Future<void> _search() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });
    try {
      final data = await ApiService.predictAge(name);
      setState(() => _result = data);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  // Clasificación por edad
  (String, IconData, Color) _classify(int age) {
    if (age < 18) {
      return ('Joven', Icons.child_care, Colors.green);
    } else if (age < 60) {
      return ('Adulto', Icons.person, Colors.blue);
    } else {
      return ('Anciano', Icons.elderly, Colors.deepPurple);
    }
  }

  @override
  Widget build(BuildContext context) {
    final age = _result?['age'] as int?;

    return Scaffold(
      appBar: AppBar(title: const Text('Predicción de edad')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nombre de la persona',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _loading ? null : _search,
              icon: const Icon(Icons.search),
              label: const Text('Predecir edad'),
            ),
            const SizedBox(height: 24),
            if (_loading) const CircularProgressIndicator(),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_result != null && _error == null && age != null)
              Builder(builder: (context) {
                final (label, icon, color) = _classify(age);
                return Column(
                  children: [
                    Icon(icon, size: 96, color: color),
                    const SizedBox(height: 12),
                    Text('${_result!['name']}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('Edad estimada: $age años',
                        style: const TextStyle(fontSize: 18)),
                    Text(label,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: color)),
                  ],
                );
              }),
            if (_result != null && age == null)
              const Text('No se pudo estimar la edad para ese nombre.'),
          ],
        ),
      ),
    );
  }
}
