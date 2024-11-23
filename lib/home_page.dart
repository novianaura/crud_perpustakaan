import 'package:crud_perpustakaan/insert.dart'; // Mengimport halaman untuk menambah buku.
import 'package:flutter/material.dart'; // Mengimport library Flutter untuk widget UI.
import 'package:supabase_flutter/supabase_flutter.dart'; // Mengimport library Supabase untuk menghubungkan dengan database.

// Membuat kelas BookListPage yang merupakan StatefulWidget,
// digunakan untuk menampilkan daftar buku.
class BookListPage extends StatefulWidget {
  const BookListPage({super.key}); // Konstruktor dengan kunci untuk widget ini.

  @override
  _BookListPageState createState() => _BookListPageState(); // Membuat state untuk widget ini.
}

// Kelas state untuk BookListPage yang berisi logika dan data.
class _BookListPageState extends State<BookListPage> {
  // Buat variabel untuk menyimpan daftar buku
  List<Map<String, dynamic>> buku = [];

  // Method ini dipanggil ketika widget pertama kali dibuat.
  @override
  void initState() {
    super.initState(); // Memanggil implementasi initState bawaan StatefulWidget.
    fetchBooks(); // Panggil fungsi untuk mengambil data buku dari Supabase.
  }

  // Fungsi untuk mengambil data buku dari Supabase
  Future<void> fetchBooks() async {
    final response = await Supabase.instance.client
        .from('buku') // Mengambil data dari tabel 'buku'.
        .select(); 
    setState(() {
      buku = List<Map<String, dynamic>>.from(response); // Menyimpan hasil query ke dalam list buku.
    });
  }

  // Method untuk membangun UI tampilan.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Buku'), // Menampilkan judul aplikasi di app bar.
        actions: [
          // Tombol untuk me-refresh data buku.
          IconButton(
            icon: const Icon(Icons.refresh), // Ikon refresh.
            onPressed: fetchBooks, // Tombol untuk refresh, memanggil fetchBooks.
          ),
        ],
      ),
      // Menampilkan data buku jika ada, jika kosong akan menampilkan loading.
      body: buku.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Menampilkan indikator loading saat data belum ada.
          : ListView.builder( // Menggunakan ListView.builder untuk menampilkan daftar buku.
              itemCount: buku.length, // Menentukan jumlah item berdasarkan panjang data buku.
              itemBuilder: (context, index) {
                final book = buku[index]; // Mengambil data buku berdasarkan index.
                return ListTile(
                  title: Text(
                    book['judul'] ?? 'No Title', // Menampilkan judul buku atau 'No Title' jika kosong.
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Menyusun elemen subtitle secara vertikal.
                    children: [
                      Text(
                        book['penulis'] ?? 'No Author', // Menampilkan penulis atau 'No Author' jika kosong.
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        book['deskripsi'] ?? 'No Description', // Menampilkan deskripsi atau 'No Description' jika kosong.
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min, // Menyusun tombol edit dan delete secara horizontal.
                    children: [
                      // Tombol untuk mengedit buku.
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue), 
                        onPressed: () {
                          // Arahkan ke halaman EditBooks untuk mengedit buku (dalam kode ini tombol belum berfungsi).
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => EditBookPage(book: book),
                          //   ),
                          // ).then((_) {
                          //   fetchBooks(); // Refresh data setelah kembali dari halaman edit.
                          // });
                        },
                      ),
                      // Tombol untuk menghapus buku.
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red), // Ikon delete.
                        onPressed: () {
                          // Menampilkan dialog konfirmasi untuk menghapus buku.
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete Book'), // Judul dialog.
                                content: const Text('Are you sure you want to delete this book?'), // Pesan konfirmasi penghapusan.
                                actions: [
                                  // Tombol untuk membatalkan penghapusan.
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Menutup dialog jika tombol 'Cancel' ditekan.
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  // Tombol untuk mengonfirmasi penghapusan.
                                  TextButton(
                                    onPressed: () async {
                                      // Fungsi penghapusan buku (belum diimplementasikan).
                                      // await deletedBook(book['id']);
                                      Navigator.of(context).pop(); // Menutup dialog setelah penghapusan.
                                    },
                                    child: const Text('Delete'),
                                  )
                                ],
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                );
              },
            ),
      // FloatingActionButton untuk menambahkan buku baru ada tombol +
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman AddBookPage untuk menambah buku baru.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBookPage(),
            ),
          );
        },
        child: const Icon(Icons.add), // Ikon untuk menambah buku.
        tooltip: 'Tambah Buku', // untuk tombol tambah buku.
      ),
    );
  }
}