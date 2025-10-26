import 'package:flutter/material.dart';
import '/models/profile.dart';

class ProfileListTile extends StatelessWidget {
  final Profile profile;
  final VoidCallback onEdit;    // panggil fungsi untuk keperluan edit Profile
  final VoidCallback onDelete;  // panggil fungsi untuk keperluan hapus Profile

  const ProfileListTile({
    super.key,
    required this.profile,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        // untuk gambar Profile
        backgroundImage: profile.imageByte != null
            ? MemoryImage(profile.imageByte!)
            : null,
        // jika belum ada gambar yang terpilih, secara defaultnya akan menggunakan seperti berikut
        child: profile.imageByte == null
            ? const Icon(Icons.person)
            : null,
      ),
      title: Text(profile.profileName),
      subtitle: Text(profile.description),
      onTap: onEdit, // fungsi "edit" berjalan setelah tap pada Profile yang tersusun dalam ListTile
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete, // fungsi "hapus" berjalan saat memilih icon
      ),
    );
  }
}