import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/perpus.dart';

class DetailPerpustakaanScreen extends StatelessWidget {
  final Perpustakaan perpus;

  const DetailPerpustakaanScreen({super.key, required this.perpus});

  Future<void> _openGoogleMaps(double lat, double lng, BuildContext context) async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak dapat membuka Google Maps'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.label_important, color: Colors.pink),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black54)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Perpustakaan"),
        backgroundColor: Colors.pink[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const Icon(Icons.local_library, size: 80, color: Colors.pink),
                      const SizedBox(height: 10),
                      Text(
                        perpus.nama,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 30, thickness: 1),
                _buildInfo("Alamat", perpus.alamat),
                _buildInfo("No Telepon", perpus.noTelpon),
                _buildInfo("Tipe", perpus.tipe),
                _buildInfo("Latitude", perpus.latitude.toString()),
                _buildInfo("Longitude", perpus.longitude.toString()),
                const Spacer(),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => _openGoogleMaps(perpus.latitude, perpus.longitude, context),
                    icon: const Icon(Icons.map_outlined),
                    label: const Text("Buka di Google Maps"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
