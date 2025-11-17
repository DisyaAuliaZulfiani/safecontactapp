// lib/providers/contact_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart'; 
import '../models/contact.dart'; // Pastikan path ini benar!

// Inisialisasi UUID untuk membuat ID unik
const uuid = Uuid();

class ContactNotifier extends StateNotifier<List<Contact>> {
  ContactNotifier() : super([
    // Contoh Data Awal (Sesuai Desain Baru)
    Contact(id: uuid.v4(), name: 'Ambulance', phoneNumber: '118', notes: 'Layanan Ambulans Nasional', isEmergency: true, category: 'Layanan Darurat'),
    Contact(id: uuid.v4(), name: 'Polisi', phoneNumber: '110', notes: 'Layanan Kepolisian', isEmergency: true, category: 'Layanan Darurat'),
    Contact(id: uuid.v4(), name: 'Pemadam', phoneNumber: '113', notes: 'Layanan Pemadam Kebakaran', isEmergency: true, category: 'Layanan Darurat'),
    Contact(id: uuid.v4(), name: 'Ayah', phoneNumber: '0812xxxxxx', notes: 'Kontak Utama Keluarga', isEmergency: false, category: 'Keluarga'),
  ]);

  // CREATE (Tambah Kontak Baru)
  void addContact(
    String name, 
    String phoneNumber, 
    String notes, 
    String category, 
    bool isEmergency,
  ) {
    final newContact = Contact(
      id: uuid.v4(), // Membuat ID unik
      name: name,
      phoneNumber: phoneNumber,
      notes: notes,
      isEmergency: isEmergency,
      category: category,
    );
    state = [...state, newContact];
  }

  // UPDATE (Edit Kontak yang Sudah Ada)
  void updateContact(Contact updatedContact) {
    state = [
      for (final contact in state)
        if (contact.id == updatedContact.id)
          updatedContact
        else
          contact,
    ];
  }

  // DELETE (Hapus Kontak)
  void deleteContact(String contactId) {
    state = state.where((contact) => contact.id != contactId).toList();
  }
}

final contactProvider = StateNotifierProvider<ContactNotifier, List<Contact>>((ref) {
  return ContactNotifier();
});