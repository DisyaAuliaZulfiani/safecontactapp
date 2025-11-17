// models/contact.dart
class Contact {
  final String id;
  final String name;
  final String phoneNumber;
  final String notes; // Informasi alamat/penyakit
  final bool isEmergency; // Untuk kontak yang perlu tombol cepat
  final String category; // PROPERTI BARU: Untuk label kontak (misal: Polisi, Keluarga)

  Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.notes = '',
    this.isEmergency = false,
    this.category = 'Lainnya', // Nilai default untuk kategori
  });

  // --- Serialisasi Data (JSON) ---

  // Konversi objek Contact menjadi Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'notes': notes,
      'isEmergency': isEmergency,
      'category': category,
    };
  }

  // Membuat objek Contact dari Map (JSON)
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      notes: json['notes'] as String? ?? '',
      isEmergency: json['isEmergency'] as bool? ?? false,
      category: json['category'] as String? ?? 'Lainnya',
    );
  }

  // --- Metode untuk membuat salinan, berguna saat update ---
  Contact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? notes,
    bool? isEmergency,
    String? category,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      notes: notes ?? this.notes,
      isEmergency: isEmergency ?? this.isEmergency,
      category: category ?? this.category,
    );
  }
}