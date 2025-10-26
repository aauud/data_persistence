# data_persistence

Tugas Semester 5 Mata Kuliah Mobile Programming Pertemuan 10. 
Flutter project yang mengambil tema "Settings & Profile".
Fitur utamanya adalah data_persistence; data masih tersimpan dalam program bahkan setelah sebuah sesi diakhiri.

## Spesifikasi Wajib
- Aplikasi wajib memiliki minimal dua layar (halaman) --> total halaman = 4
- Data tetap tersimpan meskipun aplikasi tertutup. --> untuk Data User dan Profile. 
- Pengguna dapat melakukan minimal 3 operasi CRUD (tambah, edit, hapus). --> ketiga itu diimplementasi terhadap Profile
- Desain antarmuka sederhana dan mudah digunakan.
- Setiap data yang ditampilkan menggunakan ListView / GridView --> digunakan ListView untuk menampilkan daftar Profile
- Jika memungkinkan, tampilkan notifikasi/snackbar untuk konfirmasi aksi. --> akan muncul saat ingin menghapus sebuah Profile

## Komponen Wajib (dan contoh implementasinya)
- Penyimpanan Data; SQLite atau Hive --> Menggunakan Hive
- State Management; Stateful widget / Provider sederhana --> Menggunakan Stateful widget
- UI Widget; ListView, TextField, ElevatedButton, Dialog, Snackbar --> Ada semua, namun "TextField" yang digunakan spesifiknya adalah "TextFormField"
- Validasi; Minimal validasi input form --> Ada dalam form Registrasi, Login, dan Profile
- Dokumentasi; README + komentar kode penting

## Deskripsi

Program terinspirasi dari materi "User Persona" dalam mata kuliah Software Development.
"User Persona" merujuk pada interaksi unik persona sesuai sifat dan kebiasaannya. 
Contohnya, "Persona" yang suka menghemat lebih berkemungkinan menggunakan filter "Harga terendah" dalam situs-situs toko online.

Program memungkinkan User untuk membuat dan mengelola banyak User Persona (program lebih sering menyebutkannya sebagai "Profile".
Input wajib Profile adalah nama dan deskripsinya, dengan tambahan dapat memilih gambar profile dari file komputer.
User Persona ini dapat digunakan untuk keperluan seperti dalam Software Development atau oleh orang-orang yang gemar menciptakan karakter fiksi dan hendak mendaftarkannya.

## Alur Pembuatan Program

### 0. Setup Project
Lakukan "New Flutter Project" dan seterusnya hingga dapat melakukan coding.
### 1. pubspec.yaml
Tambahkan fitur DB Hive,
dalam "dependencies":
hive_flutter: ^1.1.0
path_provider: ^2.1.1
dan "dev_dependencies":
hive_generator: ^2.0.1
build_runner: ^2.3.3
Setelah ini, lakukan 'pub get'.
### 2. lib/
Membuat 3 sub-directory: models, pages, widgets.
### 3. lib/models/: User, Profile
"user.dart" menyimpan data login user, "profile.dart" menyimpan data user persona.
Masing-masing diisi variabel dan constructor mengikuti format Hive.
Untuk mengintegrasikan Hive, harus menjalankan di terminal: 'flutter packages pub run build_runner build' untuk membentuk adapter (pengenal struktur model).
Setelah itu harus menyesuaikan/perbarui isi main() (main.dart).
### 4. lib/pages/: Registrasi, Login, Profile List, Profile Add-Edit
"register_page.dart" untuk halaman form registrasi yang meminta input username, password, dan konfirmasi password.
"login_page.dart" untuk halaman form login yang meminta input username dan password yang sudah terdaftar. Ini sudah menerapkan data_persistence, di mana data user dapat digunakan bahkan setelah aplikasi ditutup.
"profile_list_page.dart" untuk mendaftarkan semua Profile yang pernah dibuat oleh User. Jika sudah ada yang terdaftar, muncul juga opsi untuk menghapusnya.
"profile_add-edit_page" untuk halaman saat menambahkan atau mengedit data Profile. Terinspirasi dengan backend code Website Development yang terkadang menyamakan halaman "tambah" dan "edit" akibat kemiripan formnya.
### 5. lib/widgets/: Profile (ListTile)
"profile_list_tile.dart" menyimpan widget penyusun data Profile yang memudahkan pemanggilannya dalam beberapa tempat sesuai kebutuhan.
### 6. Tambahan
"image_picker" harus menambahkan pada pubspec.yaml dan juga "app/src/main/AndroidManifest.xml"

## Alur Penggunaan Program

0. Lakukan registrasi; Input username, password, dan konfirmasi password.
1. Lakukan login; Input username dan password yang terdaftar.
2. Tambahkan Profile; Pilih tombol "+" di bawah kanan. Input nama, deskripsi, dan gambar (opsional) Profile
3. Edit Profile; Pilih Profile yang muncul setelah penambahan. Dapat lakukan pengeditan terhadap nama, deskripsi, dan gambar Profile. 
4. Hapus Profile; Pilih tombol hapus/buang yang terdapat pada sisi kanan Profile. Akan muncul pesan konfirmasi terlebih dahulu sebelum penghapusan Profile secara permanen.
5. Lakukan logout; Pilih tombol logout pada ujung kanan atas.