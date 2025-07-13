class Perpustakaan {
  final int? id;
  final String nama;
  final String alamat;
  final String noTelpon;
  final String tipe;
  final double latitude;
  final double longitude;

  Perpustakaan({
    this.id,
    required this.nama,
    required this.alamat,
    required this.noTelpon,
    required this.tipe,
    required this.latitude,
    required this.longitude,
  });

  factory Perpustakaan.fromJson(Map<String, dynamic> json) {
    return Perpustakaan(
      id: json['id'],
      nama: json['nama'] ?? '',
      alamat: json['alamat'] ?? '',
      noTelpon: json['no_telpon'] ?? '',
      tipe: json['tipe'] ?? '',
      latitude: (json['latitude'] is double)
          ? json['latitude']
          : double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: (json['longitude'] is double)
          ? json['longitude']
          : double.tryParse(json['longitude'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'alamat': alamat,
      'no_telpon': noTelpon,
      'tipe': tipe,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
