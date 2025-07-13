import 'package:flutter/material.dart';
import '../model/perpus.dart';
import '../service/api_service.dart';

class TambahPerpustakaanScreen extends StatefulWidget {
  const TambahPerpustakaanScreen({super.key});

  @override
  State<TambahPerpustakaanScreen> createState() => _TambahPerpustakaanScreenState();
}

class _TambahPerpustakaanScreenState extends State<TambahPerpustakaanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _telponController = TextEditingController();
  final _tipeController = TextEditingController();
  final _latController = TextEditingController();
  final _longController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    double? lat = double.tryParse(_latController.text);
    double? long = double.tryParse(_longController.text);

    if (lat == null || long == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Latitude dan Longitude harus berupa angka'), backgroundColor: Colors.red),
      );
      return;
    }

    final perpus = Perpustakaan(
      nama: _namaController.text,
      alamat: _alamatController.text,
      noTelpon: _telponController.text,
      tipe: _tipeController.text,
      latitude: lat,
      longitude: long,
    );

    setState(() => _isLoading = true);
    final result = await ApiService.tambahPerpustakaan(perpus);
    setState(() => _isLoading = false);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil ditambahkan'), backgroundColor: Colors.pink),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${result['message']}'), backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildInput(String label, IconData icon, TextEditingController controller,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.pink),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (val) => val == null || val.isEmpty ? "$label tidak boleh kosong" : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Perpustakaan"),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF3E5F5),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.pink))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInput("Nama Perpustakaan", Icons.library_books, _namaController),
              _buildInput("Alamat", Icons.location_on, _alamatController, maxLines: 3),
              _buildInput("No Telepon", Icons.phone, _telponController, keyboardType: TextInputType.phone),
              _buildInput("Tipe (Swasta / Negeri)", Icons.category, _tipeController),
              _buildInput("Latitude", Icons.explore_outlined, _latController, keyboardType: TextInputType.number),
              _buildInput("Longitude", Icons.explore, _longController, keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.save),
                  label: const Text("Simpan"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
