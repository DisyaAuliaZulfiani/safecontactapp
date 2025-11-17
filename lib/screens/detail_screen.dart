import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/contact.dart';
import 'add_edit_screen.dart'; // Untuk navigasi ke Edit Screen
import '../providers/contact_provider.dart'; // Import Provider untuk Delete

// Warna yang sudah kita definisikan sebelumnya
const Color primaryColor = Color(0xFF00796B); 
const Color accentColor = Color(0xFFD32F2F); 
const Color surfaceColor = Color(0xFFFAFAFA); 

class DetailScreen extends ConsumerWidget {
  final Contact contact;

  const DetailScreen({super.key, required this.contact});

  // Fungsi simulasi aksi Call
  void _makeCall(BuildContext context, String phoneNumber) {
    // Implementasi nyata menggunakan url_launcher.launchUrl(Uri.parse('tel:$phoneNumber'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Memanggil ${contact.name}: $phoneNumber...'),
        backgroundColor: primaryColor,
      ),
    );
  }

  // Fungsi DELETE dengan konfirmasi (UI/UX bagus)
  void _deleteContact(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Anda yakin ingin menghapus kontak ${contact.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal', style: TextStyle(color: primaryColor)),
          ),
          ElevatedButton(
            onPressed: () {
              // Panggil fungsi delete dari Riverpod Notifier
              ref.read(contactProvider.notifier).deleteContact(contact.id);
              
              Navigator.of(ctx).pop(); // Tutup dialog
              Navigator.of(context).pop(); // Kembali ke Home Screen
              
              // Tampilkan SnackBar feedback
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${contact.name} berhasil dihapus.'), backgroundColor: accentColor),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: accentColor),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail Kontak', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- Bagian Atas: Avatar dan Nama Kontak ---
            _buildHeaderAvatar(),
            const SizedBox(height: 10),

            Text(
              contact.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),

            Text(
              contact.phoneNumber,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 15),

            // Kategori Label (Sesuai Desain)
            Chip(
              label: Text(contact.category, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            ),
            const SizedBox(height: 40),

            // --- Bagian Tengah: Tombol Aksi ---
            _buildActionButtons(context, ref), // Menggunakan context dan ref
            const SizedBox(height: 30),

            const Divider(thickness: 1),
            const SizedBox(height: 20),

            // --- Bagian Bawah: Informasi Detail (Catatan) ---
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Catatan (Alamat/Kondisi Medis)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
              ),
            ),
            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                contact.notes.isNotEmpty ? contact.notes : "Tidak ada catatan tambahan.",
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // Widget untuk Avatar di Header
  Widget _buildHeaderAvatar() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: primaryColor.withOpacity(0.1),
        border: Border.all(color: primaryColor.withOpacity(0.3), width: 3),
      ),
      child: Icon(
        contact.isEmergency ? Icons.health_and_safety : Icons.person,
        size: 70,
        color: primaryColor,
      ),
    );
  }

  // Widget untuk Tombol Aksi (Call, Edit, Delete)
  Widget _buildActionButton(
      {required IconData icon, required String label, required Color color, required VoidCallback onPressed}) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  // Widget yang menggabungkan ketiga tombol aksi (membutuhkan context dan ref)
  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Tombol Call
        _buildActionButton(
          icon: Icons.call,
          label: 'Call',
          color: primaryColor,
          onPressed: () => _makeCall(context, contact.phoneNumber),
        ),
        // Tombol Edit
        _buildActionButton(
          icon: Icons.edit,
          label: 'Edit',
          color: primaryColor,
          onPressed: () {
            // Navigasi ke Add/Edit Screen
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddEditScreen(contactToEdit: contact),
            ));
          },
        ),
        // Tombol Delete
        _buildActionButton(
          icon: Icons.delete,
          label: 'Delete',
          color: accentColor,
          onPressed: () => _deleteContact(context, ref), // Panggil fungsi delete
        ),
      ],
    );
  }
}