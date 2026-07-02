import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';

class UniversitiesScreen extends StatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  State<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
  final _controller = TextEditingController(text: 'Dominican Republic');
  bool _loading = false;
  String? _error;
  List<dynamic> _universities = [];

  Future<void> _search() async {
    final country = _controller.text.trim();
    if (country.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
      _universities = [];
    });
    try {
      final data = await ApiService.getUniversities(country);
      setState(() => _universities = data);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void initState() {
    super.initState();
    _search();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Universidades por país')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'País (en inglés)',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _loading ? null : _search,
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_loading) const CircularProgressIndicator(),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (!_loading && _error == null)
              Expanded(
                child: ListView.builder(
                  itemCount: _universities.length,
                  itemBuilder: (context, index) {
                    final u = _universities[index] as Map<String, dynamic>;
                    final domains = (u['domains'] as List?)?.join(', ') ?? '';
                    final webPages = (u['web_pages'] as List?) ?? [];
                    final webPage =
                        webPages.isNotEmpty ? webPages.first.toString() : '';
                    return Card(
                      child: ListTile(
                        title: Text(u['name']?.toString() ?? ''),
                        subtitle: Text('Dominio: $domains\n$webPage'),
                        isThreeLine: true,
                        trailing: webPage.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.open_in_new),
                                onPressed: () => _open(webPage),
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
