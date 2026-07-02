import 'package:flutter/material.dart';
import 'screens/gender_screen.dart';
import 'screens/age_screen.dart';
import 'screens/universities_screen.dart';
import 'screens/weather_screen.dart';
import 'screens/pokemon_screen.dart';
import 'screens/wordpress_news_screen.dart';
import 'screens/about_screen.dart';

void main() {
  runApp(const ToolboxApp());
}

class ToolboxApp extends StatelessWidget {
  const ToolboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ITLA Toolbox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepOrange,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class _ToolItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget Function() screenBuilder;
  const _ToolItem(this.title, this.subtitle, this.icon, this.screenBuilder);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_ToolItem>[
      _ToolItem('Predicción de género', 'genderize.io', Icons.wc,
          () => const GenderScreen()),
      _ToolItem('Predicción de edad', 'agify.io', Icons.cake,
          () => const AgeScreen()),
      _ToolItem('Universidades', 'por país', Icons.school,
          () => const UniversitiesScreen()),
      _ToolItem('Clima en RD', 'Santo Domingo hoy', Icons.wb_sunny,
          () => const WeatherScreen()),
      _ToolItem('Pokédex', 'PokeAPI', Icons.catching_pokemon,
          () => const PokemonScreen()),
      _ToolItem('Noticias WordPress', 'últimas 3 publicaciones',
          Icons.newspaper, () => const WordpressNewsScreen()),
      _ToolItem('Acerca de', 'contacto y perfil', Icons.person,
          () => const AboutScreen()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Caja de Herramientas ITLA')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Foto de una caja de herramientas
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              'https://images.unsplash.com/photo-1581147036324-c1c9c7b6e5f3?w=800&q=80',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 180,
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child: const Icon(Icons.handyman, size: 64),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Esta app reúne varias herramientas útiles en un solo lugar.',
            textAlign: TextAlign.center,
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Card(
                child: ListTile(
                  leading: CircleAvatar(child: Icon(item.icon)),
                  title: Text(item.title),
                  subtitle: Text(item.subtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => item.screenBuilder()),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
