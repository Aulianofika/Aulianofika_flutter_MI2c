import 'package:flutter/material.dart';
import '../model/perpus.dart';
import '../service/api_service.dart';

class EditPerpustakaanScreen extends StatefulWidget {
  final Perpustakaan perpus;

  const EditPerpustakaanScreen({super.key, required this.perpus});

  @override
  State<EditPerpustakaanScreen> createState() => _EditPerpustakaanScreenState();
}

class _EditPerpustakaanScreenState extends State<EditPerpustakaanScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _alamatController;
  late TextEditingController _telponController;
  late TextEditingController _tipeController;
  late TextEditingController _latController;
  late TextEditingController _longController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.perpus.nama);
    _alamatController = TextEditingController(text: widget.perpus.alamat);
    _telponController = TextEditingController(text: widget.perpus.noTelpon);
    _tipeController = TextEditingController(text: widget.perpus.tipe);
    _latController = TextEditingController(text: widget.perpus.latitude.toString());
    _longController = TextEditingController(text: widget.perpus.longitude.toString());
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    double? lat = double.tryParse(_latController.text);
    double? long = double.tryParse(_longController.text);

    if (lat == null || long == null) {
      _showMessage('Latitude dan Longitude harus berupa angka', isError: true);
      return;
    }

    final updatedPerpus = Perpustakaan(
      id: widget.perpus.id,
      nama: _namaController.text,
      alamat: _alamatController.text,
      noTelpon: _telponController.text,
      tipe: _tipeController.text,
      latitude: lat,
      longitude: long,
    );

    setState(() => _isLoading = true);
    final result = await ApiService.updatePerpustakaan(widget.perpus.id!, updatedPerpus);
    setState(() => _isLoading = false);

    _showMessage(result['message'], isError: !result['success']);
    if (result['success']) Navigator.pop(context, true);
  }

  void _showMessage(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.pink,
      ),
    );
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
        title: const Text("Edit Perpustakaan"),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFFFF0F6),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.pink))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInput("Nama Perpustakaan", Icons.library_books, _namaController),
              _buildInput("Alamat", Icons.location_on, _alamatController, maxLines: 2),
              _buildInput("No Telepon", Icons.phone, _telponController),
              _buildInput("Tipe", Icons.category, _tipeController),
              _buildInput("Latitude", Icons.explore, _latController, keyboardType: TextInputType.number),
              _buildInput("Longitude", Icons.explore_outlined, _longController, keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.save),
                  label: const Text("Simpan Perubahan"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
    );
  }
}
