import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/model.dart';
import '../../../utils/http/http_weather.dart';

class HomeController extends GetxController {
  final WeatherService weatherService;
  HomeController({required this.weatherService});

  var weather = Rxn<Weather>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isUsingLocation = true.obs; // true = pakai lokasi device
  Timer? _clockTimer;
  var currentTime = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _startClock();
    loadCachedWeather();

    // langsung coba fetch by location:
    fetchWeatherByLocation();
  }

  void _startClock() {
    currentTime.value = _formatNow();
    _clockTimer = Timer.periodic(Duration(seconds: 1), (_) {
      currentTime.value = _formatNow();
    });
  }

  String _formatNow() {
    final now = DateTime.now();
    // kembalikan format lokal jam:menit:detik
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  Future<void> fetchWeatherByLocation() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      // check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        throw Exception(
          'Lokasi tidak diizinkan. Mohon aktifkan permission lokasi.',
        );
      }

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final w = await weatherService.fetchByCoords(pos.latitude, pos.longitude);
      weather.value = w;
      await _cacheWeather(w);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchWeatherByCity(String city) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final w = await weatherService.fetchByCity(city);
      weather.value = w;
      isUsingLocation.value = false;
      await _cacheWeather(w);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _cacheWeather(Weather w) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString('cached_weather', jsonEncode(w.toJson()));
  }

  Future<void> loadCachedWeather() async {
    final sp = await SharedPreferences.getInstance();
    final s = sp.getString('cached_weather');
    if (s != null) {
      final map = jsonDecode(s) as Map<String, dynamic>;
      weather.value = Weather(
        kota: map['name'],
        suhu: (map['suhu'] as num).toDouble(),
        description: map['description'],
        icon: map['icon'],
        timestamp: map['dt'],
      );
    }
  }

  void logout() {
    Get.offAllNamed('/login');
  }

  @override
  void onClose() {
    _clockTimer?.cancel();
    super.onClose();
  }
}
