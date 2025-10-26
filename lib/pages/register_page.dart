import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/models/user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  // untuk keperluan validasi data login
  final _formKey = GlobalKey<FormState>();

  void _register() async { // menggunakan async karena adanya proses yang harus dijalankan terlebih dahulu
                            // contohnya "await userBox.add(newUser);" harus selesai sebelum notifikasi tentang selesai penyimpanan data
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;
      // variabel untuk Hive mengakses "box" untuk 'users'
      final userBox = Hive.box<User>('users');

      // Cek jika user sudah ada dalam database
      bool userExists = userBox.values.any((user) => user.username == username);

      if (userExists) {
        // Snackbar: jika username sudah pernah terdaftar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maaf, username sudah pernah didaftarkan.')),
        );
      } else {
        // jika username belum pernah terdaftar, maka membuat User baru
        final newUser = User(username: username, password: password);
        // data User baru dimasukkan dalam "box" Hive
        await userBox.add(newUser);

        // Snackbar: jika username baru terdaftar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data User baru berhasil ditambahkan.')),
        );
        // keperluan navigasi ke halaman sebelumnya
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                // Validasi username (jika kosong)
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                // Validasi password (jika kosong)
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Konfirmasi Password'),
                obscureText: true,
                // Validasi konfirmasi password (jika berbeda dengan password awal)
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords tidak sama';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}