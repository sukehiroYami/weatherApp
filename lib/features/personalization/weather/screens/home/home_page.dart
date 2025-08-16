import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../authentications/screens/login/login.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controller/home_controller.dart';

class HomePage extends StatelessWidget {
  final HomeController c = Get.find();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.background),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Obx(() {
            if (c.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (c.errorMessage.value.isNotEmpty) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    c.errorMessage.value,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final w = c.weather.value;
            if (w == null) {
              return Center(
                child: ElevatedButton.icon(
                  onPressed: c.fetchWeatherByLocation,
                  icon: const Icon(Icons.my_location),
                  label: const Text('Gunakan Lokasi Saat Ini'),
                ),
              );
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(Sizes.defaultSpace),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 48),

                      // buat transparan
                      Card(
                        color: Colors.white.withOpacity(0),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // kota
                              Text(
                                (w.kota.isNotEmpty)
                                    ? w.kota
                                    : 'Unknown location',
                                style: const TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              // suhu
                              Text(
                                (w.suhu != null)
                                    ? '${w.suhu!.toStringAsFixed(1)}°'
                                    : '—',
                                style: const TextStyle(
                                  fontSize: 60,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                (w.description.isNotEmpty)
                                    ? w.description
                                    : '-',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white70,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 20),

                              // lokasi tombol
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: c.fetchWeatherByLocation,
                                    icon: const Icon(Icons.my_location),
                                    label: const Text(
                                      'Lokasi',
                                      style: TextStyle(
                                        fontSize: Sizes.fontSizeSm,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.withOpacity(
                                        0,
                                      ),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // search kota
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      final city = await openCityInputDialog(
                                        context,
                                      );
                                      if (city != null &&
                                          city.trim().isNotEmpty) {
                                        c.fetchWeatherByCity(city.trim());
                                      }
                                    },
                                    icon: const Icon(Icons.search),
                                    label: const Text(
                                      'Cari Kota',
                                      style: TextStyle(
                                        fontSize: Sizes.fontSizeSm,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white.withOpacity(
                                        0,
                                      ),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          // tombol logout
          Positioned(
            left: 20,
            bottom: 15,
            child: IconButton(
              onPressed: () {
                Get.offAll(() => const LoginScreen());
              },
              icon: const Icon(Iconsax.logout, color: Colors.white, size: 32),
            ),
          ),
        ],
      ),
    );
  }

  // aksi setelah button di klik
  Future<String?> openCityInputDialog(BuildContext context) {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cari Kota'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(hintText: 'Masukkan nama kota'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ctrl.text),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
