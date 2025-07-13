import 'package:flutter/material.dart';
import '../model/perpus.dart';
import '../service/api_service.dart';
import 'edit_perpus_screen.dart';
import 'tambah_perpus_screen.dart';
import 'detail_perpus_screen.dart';

class ListPerpustakaanScreen extends StatefulWidget {
  const ListPerpustakaanScreen({super.key});

  @override
  State<ListPerpustakaanScreen> createState() => _ListPerpustakaanScreenState();
}

class _ListPerpustakaanScreenState extends State<ListPerpustakaanScreen> {
  late Future<List<Perpustakaan>> perpustakaanList;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      perpustakaanList = ApiService.fetchPerpustakaan();
    });
  }

  Future<void> _deletePerpus(int id) async {
    final result = await ApiService.deletePerpustakaan(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
      ),
    );
    if (result['success']) _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Perpustakaan"),
        backgroundColor: Colors.pink,
      ),
      body: FutureBuilder<List<Perpustakaan>>(
        future: perpustakaanList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.pink));
          } else if (snapshot.hasError) {
            return const Center(child: Text("Gagal memuat data"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada data perpustakaan"));
          } else {
            final list = snapshot.data!;
            return RefreshIndicator(
              onRefresh: () async => _loadData(),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final perpus = list[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.pink,
                        child: Icon(Icons.local_library, color: Colors.white),
                      ),
                      title: Text(perpus.nama),
                      subtitle: Text(perpus.alamat),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditPerpustakaanScreen(perpus: perpus),
                                ),
                              );
                              if (result == true) _loadData();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Hapus Data"),
                                  content: const Text("Yakin ingin menghapus data ini?"),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
                                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus")),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                _deletePerpus(perpus.id!);
                              }
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPerpustakaanScreen(perpus: perpus),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TambahPerpustakaanScreen()),
          );
          if (result == true) _loadData();
        },
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
