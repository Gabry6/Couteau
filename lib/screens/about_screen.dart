import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ------------------------------------------------------------------
// TODO (Gabry): reemplaza estos datos con tu información real antes
// de compilar el APK final. La foto debe estar en assets/icon/icon.png
// (la misma que uses para el ícono de la app).
// ------------------------------------------------------------------
const String kFullName = 'Carlos Gabriel Thomas C.';
const String kCareer = 'Desarrollo de Aplicaciones Móviles - ITLA';
const String kMatricula = '2023-1296';
const String kEmail = '2023-1296@itla.edu.do';
const String kPhone = '+1 849-650-6650';
const String kGithub = 'https://github.com/Gabry6/Couteau';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: CircleAvatar(
              radius: 70,
              backgroundImage: const AssetImage('assets/icon/icon.png'),
              onBackgroundImageError: (_, __) {},
              child: const Icon(Icons.person, size: 60),
            ),
          ),
          const SizedBox(height: 16),
          Text(kFullName,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(kCareer,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Text('Matrícula: $kMatricula',
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Correo'),
                  subtitle: Text(kEmail),
                  onTap: () => _open('mailto:$kEmail'),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('Teléfono'),
                  subtitle: Text(kPhone),
                  onTap: () => _open('tel:$kPhone'),
                ),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text('Código en GitHub'),
                  subtitle: Text(kGithub),
                  onTap: () => _open(kGithub),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Disponible para oportunidades de práctica / trabajo en desarrollo móvil.',
            textAlign: TextAlign.center,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
