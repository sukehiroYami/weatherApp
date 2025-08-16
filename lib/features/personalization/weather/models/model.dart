class Weather {
  final String kota;
  final double? suhu; // celsius (nullable kalo tidak ada)
  final String description;
  final String icon; // icon dari api
  final int timestamp;

  Weather({
    required this.kota,
    required this.suhu,
    required this.description,
    required this.icon,
    required this.timestamp,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    double? _toDouble(dynamic v) {
      if (v == null) return null;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v);
      if (v is num) return v.toDouble();
      return null;
    }

    final main = json['main'] as Map<String, dynamic>?;
    // sudah celcius
    final tempValue = _toDouble(main?['temp']);

    final weatherArr = json['weather'] as List<dynamic>?;
    final w = (weatherArr != null && weatherArr.isNotEmpty)
        ? weatherArr.first as Map<String, dynamic>
        : null;

    return Weather(
      kota: json['name']?.toString() ?? '',
      suhu: tempValue,
      description: w?['description']?.toString() ?? '',
      icon: w?['icon']?.toString() ?? '',
      timestamp: (json['dt'] is int)
          ? json['dt'] as int
          : int.tryParse(json['dt']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': kota,
    'temp': suhu,
    'description': description,
    'icon': icon,
    'dt': timestamp,
  };
}
