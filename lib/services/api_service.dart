import 'dart:convert';
import 'package:http/http.dart' as http;

/// Centraliza todas las llamadas HTTP de la app.
class ApiService {
  // 2. Predicción de género -----------------------------------------------
  static Future<Map<String, dynamic>> predictGender(String name) async {
    final uri = Uri.parse('https://api.genderize.io/?name=$name');
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Error consultando genderize.io (${res.statusCode})');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // 3. Predicción de edad ---------------------------------------------------
  static Future<Map<String, dynamic>> predictAge(String name) async {
    final uri = Uri.parse('https://api.agify.io/?name=$name');
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Error consultando agify.io (${res.statusCode})');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // 4. Universidades por país -----------------------------------------------
  static Future<List<dynamic>> getUniversities(String country) async {
    final uri = Uri.parse(
        'https://adamix.net/proxy.php?country=${Uri.encodeComponent(country)}');
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Error consultando universidades (${res.statusCode})');
    }
    return jsonDecode(res.body) as List<dynamic>;
  }

  // 5. Clima en RD (Open-Meteo, sin API key) --------------------------------
  static Future<Map<String, dynamic>> getWeatherSantoDomingo() async {
    // Coordenadas de Santo Domingo, RD
    const lat = 18.4861;
    const lon = -69.9312;
    final uri = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon'
        '&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m'
        '&daily=temperature_2m_max,temperature_2m_min,weather_code'
        '&timezone=America%2FSanto_Domingo');
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Error consultando clima (${res.statusCode})');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // 6. Pokémon ---------------------------------------------------------------
  static Future<Map<String, dynamic>> getPokemon(String name) async {
    final uri =
        Uri.parse('https://pokeapi.co/api/v2/pokemon/${name.toLowerCase().trim()}');
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Pokémon no encontrado (${res.statusCode})');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // 7. Noticias de un sitio WordPress (REST API estándar) --------------------
  // Ejemplo usado: https://wptavern.com  (tiene la REST API pública habilitada)
  // IMPORTANTE: publica el API que uses en el foro del curso.
  static Future<List<dynamic>> getWordpressPosts({
    String siteBaseUrl = 'https://wptavern.com',
  }) async {
    final uri = Uri.parse(
        '$siteBaseUrl/wp-json/wp/v2/posts?per_page=3&_embed');
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Error consultando WordPress (${res.statusCode})');
    }
    return jsonDecode(res.body) as List<dynamic>;
  }
}
