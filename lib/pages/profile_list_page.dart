import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/models/profile.dart';
import '/pages/profile_add-edit_page.dart';
import '/pages/login_page.dart';
import '/widgets/profile_list_tile.dart';

class ProfileListPage extends StatefulWidget {
  const ProfileListPage({super.key});

  @override
  State<ProfileListPage> createState() => _ProfileListPageState();
}

class _ProfileListPageState extends State<ProfileListPage> {
  late final Box<Profile> profileBox;

  @override
  void initState() {
    super.initState();
    profileBox = Hive.box<Profile>('profiles');
  }

  void _addProfile() { // untuk menambahkan profile, halamannya disamakan dengan jika ingin edit Profile
    Navigator.push(    // jadi halaman untuk ADD dan EDIT sama, namun EDIT akan memunculkan data sesuai dengan Profile yang dipilih
      context,
      MaterialPageRoute(builder: (context) => const AddEditProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar User Persona'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      // ValueListenableBuilder = dalam kasus sekarang, akan memunculkan teks jika belum ada Profile yang terdaftar
      body: ValueListenableBuilder(
        valueListenable: profileBox.listenable(),
        builder: (context, Box<Profile> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text('Belum ada Profile yang terdaftar :('),
            );
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final profile = box.getAt(index) as Profile; // mengakses Profile sesuai angka index-nya

              // mengambil widget dan menjalankan aplikasi dalam tahap ingin mengedit Profile
              return ProfileListTile(
                profile: profile,
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditProfilePage(profileIndex: index),
                    ),
                  );
                },
                onDelete: () {
                  // Dialog dan Snackbar untuk penghapusan sebuah Profile
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      // Dialog: memunculkan notifikasi untuk memastikan aksi dari user
                      return AlertDialog(
                        title: const Text('Hapus Permanen'),
                        content: const Text('Anda yakin? Data Profile tidak bisa didapatkan kembali'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Balik'),
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                            onPressed: () {
                              // hapus Profile sesuai indexnya dalam box Hive
                              box.deleteAt(index);
                              // tutup Dialog
                              Navigator.of(dialogContext).pop();
                              // Snackbar: menunjukkan bahwa Profile sungguh sudah dihapus
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Profile berhasil dihapuskan')),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProfile,
        tooltip: 'Tambah Profile',
        child: const Icon(Icons.add),
      ),
    );
  }
}