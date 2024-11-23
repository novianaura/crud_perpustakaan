import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crud_perpustakaan/home_page.dart';


class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  // GlobalKey digunakan untuk validasi form
  final _formKey = GlobalKey<FormState>(); //form key untuk id(primary key)
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _penulisController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();


  Future<void> _addBook() async {
    // Memastikan form sudah valid sebelum data dikirim
    if (_formKey.currentState!.validate()) {
      final title = _judulController.text; // Mendapatkan judul buku
      final author = _penulisController.text; // Mendapatkan penulis buku
      final description = _deskripsiController.text; // Mendapatkan deskripsi buku

      try {
        // Mengirim data ke Supabase dengan kolom yang sesuai dengan nama tabel 'buku'
        final response = await Supabase.instance.client
            .from('buku') // Nama tabel di Supabase
            .insert({
              'judul': title, 
              'penulis': author,
              'deskripsi': description, 
            })
            .select(); // Memastikan data dikirim
            
        // Jika berhasil, tampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Buku berhasil ditambahkan')),
        );

        // Kosongkan input field setelah data berhasil dikirim
        _judulController.clear();
        _penulisController.clear();
        _deskripsiController.clear();

        // Navigasi kembali ke halaman utama (HomePage)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BookListPage()), // Navigasi ke halaman daftar buku
        );
      } catch (e) {
        // Jika terjadi error, tampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error occurred: $e'), // Menampilkan error jika terjadi masalah
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Buku'), // Judul halaman
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding di sekitar form
        child: Form(
          key: _formKey, // GlobalKey untuk form validation
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Menjaga lebar form full
            children: [
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(labelText: 'Judul'), // Label untuk input
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong'; // Validasi jika judul kosong
                  }
                  return null;
                },
              ),

              // Input field untuk penulis buku
              TextFormField(
                controller: _penulisController,
                decoration: const InputDecoration(labelText: 'Penulis'), // Label untuk input
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Penulis tidak boleh kosong'; 
                  }
                  return null;
                },
              ),
              // Input field untuk deskripsi buku
              TextFormField(
                controller: _deskripsiController,
                decoration: const InputDecoration(labelText: 'Deskripsi'), // Label untuk input
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong'; 
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20), 
              // Tombol untuk menyimpan buku
              ElevatedButton(
                onPressed: _addBook, // Fungsi yang dipanggil ketika tombol ditekan
                child: const Text('Tambah Buku'), 
              ),
            ],
          ),
        ),
      ),
    );
  }
}