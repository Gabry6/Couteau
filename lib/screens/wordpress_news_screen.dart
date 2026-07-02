import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';

/// Sitio WordPress usado como fuente de noticias.
/// IMPORTANTE (tarea): publica esta URL en el foro del curso:
/// https://aulavirtual.itla.edu.do/mod/forum/view.php?id=101978
const String kWordpressSite = 'https://wptavern.com';

class WordpressNewsScreen extends StatefulWidget {
  const WordpressNewsScreen({super.key});

  @override
  State<WordpressNewsScreen> createState() => _WordpressNewsScreenState();
}

class _WordpressNewsScreenState extends State<WordpressNewsScreen> {
  bool _loading = true;
  String? _error;
  List<dynamic> _posts = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await ApiService.getWordpressPosts(siteBaseUrl: kWordpressSite);
      setState(() => _posts = data);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  String _stripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticias WordPress')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Image.network(
                  '$kWordpressSite/favicon.ico',
                  height: 32,
                  width: 32,
                  errorBuilder: (c, e, s) => const Icon(Icons.public, size: 32),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    kWordpressSite,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
              ],
            ),
          ),
          if (_loading) const CircularProgressIndicator(),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final p = _posts[index] as Map<String, dynamic>;
                final title = _stripHtml(p['title']?['rendered'] ?? '');
                final excerpt = _stripHtml(p['excerpt']?['rendered'] ?? '');
                final link = p['link']?.toString() ?? '';
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(excerpt, maxLines: 4, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => _open(link),
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('Visitar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
