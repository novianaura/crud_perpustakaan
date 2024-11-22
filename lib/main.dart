import 'package:crud_perpustakaan/home_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://uezkmdwwfooeovfksllw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVlemttZHd3Zm9vZW92ZmtzbGx3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE3MjY2MjcsImV4cCI6MjA0NzMwMjYyN30.oG_ra3vg9-Gqij1cH_54H4dSSAV9eKXQ0jz7QcZYs6c',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

@override
Widget build(BuildContext context){
  return const MaterialApp(
    title: 'Perpustakaan',
    home: BookListPage (),
    debugShowCheckedModeBanner: false,
  );
}
}