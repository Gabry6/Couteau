import 'package:flutter/material.dart';
import '../services/api_service.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
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
      final data = await ApiService.predictGender(name);
      setState(() => _result = data);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gender = _result?['gender'] as String?;
    final isMale = gender == 'male';
    final bgColor = _result == null
        ? Colors.white
        : (isMale ? Colors.blue.shade100 : Colors.pink.shade100);

    return Scaffold(
      appBar: AppBar(title: const Text('Predicción de género')),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: bgColor,
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
              label: const Text('Predecir'),
            ),
            const SizedBox(height: 24),
            if (_loading) const CircularProgressIndicator(),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_result != null && _error == null)
              Column(
                children: [
                  Icon(
                    isMale ? Icons.male : Icons.female,
                    size: 96,
                    color: isMale ? Colors.blue : Colors.pink,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_result!['name']}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Género: ${gender ?? "desconocido"}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  if (_result!['probability'] != null)
                    Text(
                      'Probabilidad: ${((_result!['probability'] as num) * 100).toStringAsFixed(1)}%',
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
