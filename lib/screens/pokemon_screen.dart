import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/api_service.dart';

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final _controller = TextEditingController(text: 'pikachu');
  final _player = AudioPlayer();
  bool _loading = false;
  String? _error;
  Map<String, dynamic>? _pokemon;

  Future<void> _search() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
      _pokemon = null;
    });
    try {
      final data = await ApiService.getPokemon(name);
      setState(() => _pokemon = data);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _playCry(String url) async {
    await _player.play(UrlSource(url));
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sprite = _pokemon?['sprites']?['front_default'] as String?;
    final cry = _pokemon?['cries']?['latest'] as String?;
    final abilities = (_pokemon?['abilities'] as List?) ?? [];
    final baseExp = _pokemon?['base_experience'];

    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nombre del Pokémon',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _loading ? null : _search,
              icon: const Icon(Icons.search),
              label: const Text('Buscar'),
            ),
            const SizedBox(height: 16),
            if (_loading) const CircularProgressIndicator(),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_pokemon != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (sprite != null) Image.network(sprite, height: 150),
                      Text(
                        (_pokemon!['name'] as String).toUpperCase(),
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text('Experiencia base: $baseExp'),
                      const SizedBox(height: 8),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Habilidades:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      ...abilities.map((a) => Text(
                          '• ${a['ability']?['name'] ?? ''}')),
                      const SizedBox(height: 16),
                      if (cry != null)
                        ElevatedButton.icon(
                          onPressed: () => _playCry(cry),
                          icon: const Icon(Icons.volume_up),
                          label: const Text('Reproducir sonido'),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
