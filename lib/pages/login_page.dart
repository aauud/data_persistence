import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/models/user.dart';
import '/pages/register_page.dart';
import '/pages/profile_list_page.dart';

// isi LoginPage mirip dengan RegisterPage dari sisi validasi dan penggunaan snackbar
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() { // tidak perlu async karena lebih fokus pada READ data daripada CREATE yang baru sehingga tidak ada fungsi yang perlu ditunggu
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;
      final userBox = Hive.box<User>('users');
      // validasi antara username dan password dari sebuah user yang terdaftar
      bool isAuthenticated = userBox.values.any(
        (user) => user.username == username && user.password == password,
      );
      // jika berhasil, maka muncul notif dan pindah halaman
      if (isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Berhasil')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileListPage()
          )
        );
      } else {
        // jika gagal login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username atau password kurang tepat')),
        );
      }
    }
  }

  void _toRegister() { // fungsi untuk pergi ke halaman register_page.dart
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _toRegister,
                child: const Text('Registrasi Akun Baru'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}