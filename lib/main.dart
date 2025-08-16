import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'app.dart';
import 'features/personalization/weather/controller/home_controller.dart';
import 'features/utils/http/http_weather.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {}

  final weatherService = WeatherService();
  Get.put<WeatherService>(weatherService);

  Get.lazyPut<HomeController>(
    () => HomeController(weatherService: Get.find()),
    fenix: true,
  );

  runApp(const App());
}
