import 'dart:typed_data'; // untuk penggunaan tipe data Uint8List
import 'package:hive/hive.dart';

// dari sisi dokumentasi, banyak yang sama dengan kasus "user.dart"

part 'profile.g.dart';
// menghubungkan dengan file Hive, hasil generate otomatis dari command: flutter packages pub run build_runner build
// setiap kali "profile.dart" mengalami perubahan, harus mengulangi command sebelumnya

@HiveType(typeId: 1) // typeId = 1 karena 0 sudah diambil model User
class Profile {
  // Variable
  @HiveField(0)
  final String profileName;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final Uint8List? imageByte; // keperluan gambar Profile, hanya untuk web (tidak bisa Android)

  // Constructor
  Profile({
    required this.profileName,
    required this.description,
    this.imageByte,
  });
}