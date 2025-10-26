import 'package:hive/hive.dart';

part 'user.g.dart';
// menghubungkan dengan file Hive, hasil generate otomatis dari command: flutter packages pub run build_runner build
// setiap kali "user.dart" mengalami perubahan, harus mengulangi command sebelumnya

// Hive memiliki format sendiri dalam mendefinisikan modelnya
@HiveType(typeId: 0) // typeId akan berbeda untuk setiap model
class User { // deklarasi Field format Hive menggunakan index dari 0 dan seterusnya
  // Variable
  @HiveField(0)
  final String username;
  @HiveField(1)
  final String password;
  @HiveField(2)
  final bool notif;

  // Constructor
  User({
    required this.username,
    required this.password,
    this.notif = true,
  });
}