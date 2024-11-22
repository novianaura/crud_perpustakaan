import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookListPage extends StatefulWidget{
  const BookListPage({super.key});

  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage>{
  //buat variabel untuk menyimpan daftar buku
  List<Map<String, dynamic>> buku = [];

  @override
void initState() {
  super.initState();
  fetchBuku(); //memanggil fungsi untuk fetch data buku
}
//fungsi untuk mengambil data buku dari supabase
Future<void> fetchBuku() async{
  final response = await Supabase.instance.client
  .from('buku')
  .select();

  setState(() {
    buku = List<Map<String, dynamic>>.from(response);
  });
}

@override
Widget build(BuildContext context){
  return Scaffold(
    appBar: AppBar(
      title: const Text('Daftar'),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: fetchBuku,
        ),
      ],
    ),

    body: buku.isEmpty
    ? const Center(child: CircularProgressIndicator()) //untuk menampilkan loading
    : ListView.builder( //untuk membuat tampilan list
      itemCount: buku.length,
      itemBuilder: (context, index){
        final book = buku [index];
        return ListTile(
          title: Text(book['judul'] ?? 'No title', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black,)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(book['penulis'] ?? 'No author', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
              Text(book['deskripsi'] ?? 'No Description', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black))
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue,),
                onPressed: (){
                  //arahkan ke halaman editbookpage dengan mengirimkan 
                  // Navigator.push(
                  //   // context,
                  //   // MaterialPageRoute(
                  //   //   builder: (context) => EditBookPage(book: book),
                  //   // ),
                  //   ) .then((_){
                  //     fetchBuku();
                  //   });
                }
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: (){

                  showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: const Text('Delete Book'),
                        content: const Text('Are you sure you want to delete book'),
                        actions: [
                          TextButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: (){
                              // await deleteBook(buku['id']);
                              Navigator.of(context).pop();
                            }, 
                            child: const Text('Delete'),
                          )
                        ]
                      );
                    }
                  );
                }
              )
            ],
          ),
        );
      }
    ),
  );
}
}