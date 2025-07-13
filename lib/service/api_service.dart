import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/perpus.dart';

class ApiService {
  static const String baseUrl = "http://10.213.37.1:8000/api/perpustakaan";

  /// Ambil semua data perpustakaan
  static Future<List<Perpustakaan>> fetchPerpustakaan() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['success'] == true && data['data'] is List) {
        List list = data['data'];
        return list.map((e) => Perpustakaan.fromJson(e)).toList();
      } else {
        throw Exception('Format data tidak sesuai');
      }
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  /// Tambah data perpustakaan
  static Future<Map<String, dynamic>> tambahPerpustakaan(Perpustakaan p) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(p.toJson()),
    );
    final jsonRes = jsonDecode(res.body);
    return {
      'success': res.statusCode == 201,
      'message': jsonRes['success'] == true ? 'Berhasil ditambahkan' : (jsonRes['message'] ?? 'Gagal')
    };
  }

  /// Update data perpustakaan
  static Future<Map<String, dynamic>> updatePerpustakaan(int id, Perpustakaan p) async {
    final res = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(p.toJson()),
    );
    final jsonRes = jsonDecode(res.body);
    return {
      'success': res.statusCode == 200,
      'message': jsonRes['success'] == true ? 'Berhasil diupdate' : (jsonRes['message'] ?? 'Gagal')
    };
  }

  /// Hapus data perpustakaan
  static Future<Map<String, dynamic>> deletePerpustakaan(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/$id'));
    return {
      'success': res.statusCode == 200,
      'message': 'Berhasil dihapus'
    };
  }
}
