import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../personalization/weather/models/model.dart';

class WeatherService {
  final String apiKey;
  final http.Client client;

  WeatherService({http.Client? client})
    : apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '',
      client = client ?? http.Client();

  Future<Weather> fetchByCoords(double lat, double lon) async {
    final uri = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'appid': apiKey,
      'units': 'metric', // langsung celcius
    });

    final resp = await client.get(uri).timeout(const Duration(seconds: 10));
    if (resp.statusCode == 200) {
      final json = jsonDecode(resp.body);
      return Weather.fromJson(json);
    } else {
      throw Exception('Failed to fetch weather: ${resp.statusCode}');
    }
  }

  Future<Weather> fetchByCity(String city) async {
    final uri = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'q': city,
      'appid': apiKey,
      'units': 'metric',
    });
    final resp = await client.get(uri).timeout(const Duration(seconds: 10));
    if (resp.statusCode == 200) {
      return Weather.fromJson(jsonDecode(resp.body));
    } else if (resp.statusCode == 404) {
      throw Exception('City not found');
    } else {
      throw Exception('Server error: ${resp.statusCode}');
    }
  }
}
