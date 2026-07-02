import 'package:flutter/material.dart';
import '../services/api_service.dart';

// Interpretación simplificada de los weather_code de Open-Meteo (estándar WMO)
String _describeWeatherCode(int code) {
  if (code == 0) return 'Cielo despejado';
  if (code <= 3) return 'Parcialmente nublado';
  if (code <= 48) return 'Neblina';
  if (code <= 57) return 'Llovizna';
  if (code <= 67) return 'Lluvia';
  if (code <= 77) return 'Nieve';
  if (code <= 82) return 'Chubascos';
  if (code <= 99) return 'Tormenta';
  return 'Sin datos';
}

IconData _iconForCode(int code) {
  if (code == 0) return Icons.wb_sunny;
  if (code <= 3) return Icons.cloud;
  if (code <= 48) return Icons.foggy;
  if (code <= 67) return Icons.grain;
  if (code <= 82) return Icons.beach_access;
  return Icons.thunderstorm;
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _data;

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
      final data = await ApiService.getWeatherSantoDomingo();
      setState(() => _data = data);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = _data?['current'] as Map<String, dynamic>?;
    final daily = _data?['daily'] as Map<String, dynamic>?;
    final code = current?['weather_code'] as int?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima en Santo Domingo, RD'),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : _error != null
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(_error!,
                        style: const TextStyle(color: Colors.red)),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(DateTime.now().toString().split(' ').first,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey)),
                        const SizedBox(height: 8),
                        Icon(_iconForCode(code ?? 0),
                            size: 96, color: Colors.orange),
                        const SizedBox(height: 8),
                        Text(_describeWeatherCode(code ?? 0),
                            style: const TextStyle(fontSize: 22)),
                        const SizedBox(height: 16),
                        Text(
                          '${current?['temperature_2m']}°C',
                          style: const TextStyle(
                              fontSize: 48, fontWeight: FontWeight.bold),
                        ),
                        Text(
                            'Humedad: ${current?['relative_humidity_2m']}% · '
                            'Viento: ${current?['wind_speed_10m']} km/h'),
                        const SizedBox(height: 16),
                        if (daily != null)
                          Text(
                            'Máx: ${(daily['temperature_2m_max'] as List).first}°C   '
                            'Mín: ${(daily['temperature_2m_min'] as List).first}°C',
                            style: const TextStyle(fontSize: 18),
                          ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
