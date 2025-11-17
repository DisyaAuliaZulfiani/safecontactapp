// lib/screens/add_edit_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/contact.dart';
import '../providers/contact_provider.dart';

const Color primaryColor = Color(0xFF00796B); 
const Color accentColor = Color(0xFFD32F2F); 
const Color surfaceColor = Color(0xFFFAFAFA); 

class AddEditScreen extends ConsumerStatefulWidget {
  final Contact? contactToEdit; // Opsional: jika dalam mode edit

  const AddEditScreen({super.key, this.contactToEdit});

  @override
  ConsumerState<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends ConsumerState<AddEditScreen> {
  // Controller untuk input
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedCategory = 'Lainnya'; // State untuk dropdown
  bool _isEmergency = false; // State untuk checkbox/switch

  // Daftar kategori simulasi
  final List<String> _categories = ['Keluarga', 'Layanan Darurat', 'Teman', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    // Jika ada kontak untuk diedit, inisialisasi controller dengan data tersebut
    if (widget.contactToEdit != null) {
      final contact = widget.contactToEdit!;
      _nameController.text = contact.name;
      _phoneController.text = contact.phoneNumber;
      _notesController.text = contact.notes;
      _selectedCategory = contact.category;
      _isEmergency = contact.isEmergency;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveContact() {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      // Tampilkan error jika input kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan Nomor Telepon wajib diisi!'), backgroundColor: accentColor),
      );
      return;
    }

    final notifier = ref.read(contactProvider.notifier);

    if (widget.contactToEdit != null) {
      // MODE EDIT
      final updatedContact = widget.contactToEdit!.copyWith(
        name: _nameController.text,
        phoneNumber: _phoneController.text,
        notes: _notesController.text,
        category: _selectedCategory,
        isEmergency: _isEmergency,
      );
      notifier.updateContact(updatedContact);
    } else {
      // MODE TAMBAH BARU
      notifier.addContact(
        _nameController.text,
        _phoneController.text,
        _notesController.text,
        _selectedCategory,
        _isEmergency,
      );
    }
    Navigator.of(context).pop(); // Kembali ke Home Screen
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.contactToEdit != null;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Kontak' : 'Tambah Kontak', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detail Kontak',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Input Field: Nama Kontak
            _buildInputField('Nama Kontak', Icons.person, controller: _nameController),
            const SizedBox(height: 20),

            // Input Field: Nomor Telepon
            _buildInputField('Nomor Telepon', Icons.phone, controller: _phoneController, keyboardType: TextInputType.phone),
            const SizedBox(height: 20),
            
            // Input Field: Catatan Medis/Alamat
            _buildInputField('Catatan (Alamat/Penyakit)', Icons.notes, controller: _notesController, maxLines: 3),
            const SizedBox(height: 20),

            // Dropdown Kategori
            _buildDropdownField('Kategori', _selectedCategory, _categories, (newValue) {
              setState(() {
                _selectedCategory = newValue!;
              });
            }),
            const SizedBox(height: 20),
            
            // Switch Is Emergency
            SwitchListTile(
              title: const Text('Jadikan Kontak Darurat (Akses Cepat)'),
              value: _isEmergency,
              onChanged: (bool value) {
                setState(() {
                  _isEmergency = value;
                });
              },
              activeColor: primaryColor,
              tileColor: surfaceColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            
            const SizedBox(height: 40),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _saveContact,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // Ubah ke Primary untuk Save
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                ),
                child: Text(isEditing ? 'Perbarui Kontak' : 'Simpan Kontak', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom Widget Input Field yang Bersih
  Widget _buildInputField(String hint, IconData icon, {TextEditingController? controller, TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon, color: primaryColor),
      ),
    );
  }
  
  // Custom Widget Dropdown Field
  Widget _buildDropdownField(String hint, String currentValue, List<String> items, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          hintText: 'Pilih Kategori',
          border: InputBorder.none,
          isDense: true,
        ),
        value: currentValue,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}