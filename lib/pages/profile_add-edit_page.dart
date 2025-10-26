import 'dart:typed_data'; // untuk penggunaan tipe data Uint8List

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/models/profile.dart';
import 'package:image_picker/image_picker.dart';

class AddEditProfilePage extends StatefulWidget {
  final int? profileIndex; // index/counter untuk membantu mengetahui jika Profile bersifat baru atau sedang dimodifikasi
  const AddEditProfilePage({super.key, this.profileIndex});

  @override
  State<AddEditProfilePage> createState() => _AddEditProfilePageState();
}

class _AddEditProfilePageState extends State<AddEditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();


  final _imagePicker = ImagePicker();
  Uint8List? _selectedImageBytes;

  late final Box<Profile> profileBox;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    profileBox = Hive.box<Profile>('profiles');

    // untuk keperluan membuat Profile-nya, dipastikan dulu sedang berada dalam mode EDIT
    if (widget.profileIndex != null) {
      _isEditMode = true;
      // membentuk Profile
      final profile = profileBox.getAt(widget.profileIndex!);
      if (profile != null) {
        _nameController.text = profile.profileName;
        _descController.text = profile.description;
        _selectedImageBytes = profile.imageByte;
      }
    }
  }

  void _pickImage() async {
  final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    // kondisi jika user balik / tidak jadi memilih gambar
    if (pickedFile == null) {
      return;
    }
    // ketentuan file yang ingin dapat diterima
    final validMimeTypes = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];

    if (validMimeTypes.contains(pickedFile.mimeType)) { // jika sesuai ketentuan
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
      });
    } else { // jika TIDAK sesuai ketentuan
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Maaf, hanya dapat menerima file bertipe JPEG, PNG, WEBP, atau GIF.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final newProfile = Profile(
        profileName: _nameController.text,
        description: _descController.text,
        imageByte: _selectedImageBytes,
      );
      if (_isEditMode) {
        // UPDATE
        profileBox.putAt(widget.profileIndex!, newProfile);
      } else {
        // CREATE
        profileBox.add(newProfile);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditMode ? 'Profile tersimpan :D' : 'Profile baru terdaftarkan :>'),
        ),
      );
      Navigator.pop(context); // balik ke halaman sebelumnya
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Profile' : 'Add Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 24),
              CircleAvatar(
                radius: 50,
                backgroundImage: _selectedImageBytes != null
                    ? (MemoryImage(_selectedImageBytes!)) // untuk perizinan dan pengaksesan file komputer
                    : null,
                child: _selectedImageBytes == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
              const SizedBox(height: 16),
              Row( // membuat 2 tombol untuk memilih dan menghilangkan gambar Profile
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _pickImage, // memanggil fungsi
                    child: const Text('Pilih Gambar Profile'),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedImageBytes = null;
                      });
                    },
                    child: const Text(
                      'Hilangkan Gambar',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '*Nama Profile'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inputkan nama Profile';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: '*Deskripsi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inputkan deskripsi Profile';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Simpan Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}