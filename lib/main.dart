/*
Mata Kuliah   : Mobile Programming
Nama          : Audelia Franetta
NIM           : 825230164
*/

// import utama
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import models
import '/models/user.dart';
import '/models/profile.dart';
// import pages
import '/pages/login_page.dart';

void main() async { // async = program tidak berhenti meskipun terdapat fitur yang sedang berproses

  WidgetsFlutterBinding.ensureInitialized(); // diperlukan untuk inisialisasi Hive sebelum runApp
  await Hive.initFlutter();                  // inisialisasi Hive; await = harus selesai sebelum dapat lanjut ke langkah berikut

  // memperkenalkan struktur class kepada Hive
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ProfileAdapter());

  // membuat tempat penyimpanan "box" / tabel database Hive
  await Hive.openBox<User>('users');
  await Hive.openBox<Profile>('profiles');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Settings & Profile App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}