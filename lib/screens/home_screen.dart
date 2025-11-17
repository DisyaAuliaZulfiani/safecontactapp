// screens/home_screen.dart (FINAL - DENGAN PDAM)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/contact.dart'; 
import '../providers/contact_provider.dart';
import 'add_edit_screen.dart'; 
import 'detail_screen.dart'; 

// Warna Konstanta
const Color primaryColor = Color(0xFF00796B); 
const Color accentColor = Color(0xFFD32F2F); 
const Color surfaceColor = Color(0xFFFAFAFA); 

// Mengubah menjadi ConsumerStatefulWidget untuk mengimplementasikan animasi
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  // Animasi Controller
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  String _currentFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _makeCall(BuildContext context, String phoneNumber) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Memanggil $phoneNumber...'),
        backgroundColor: primaryColor,
      ),
    );
  }

  // --- Widget 1: Service Grid Card ---
  Widget _buildServiceCard(BuildContext context, IconData icon, String label, Color color, String phoneNumber) {
    return InkWell(
      onTap: () => _makeCall(context, phoneNumber), 
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: 80,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget 2: Filter Chip ---
  Widget _buildFilterChip(String label) {
    final isSelected = _currentFilter == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ActionChip(
        label: Text(label),
        backgroundColor: isSelected ? primaryColor : surfaceColor,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isSelected ? BorderSide.none : const BorderSide(color: Colors.grey, width: 0.5)
        ),
        onPressed: () {
          setState(() {
            _currentFilter = label;
          });
        },
      ),
    );
  }

  // --- Widget 3: Contact Card ---
  Widget _buildContactCard(BuildContext context, Contact contact, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        color: surfaceColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailScreen(contact: contact),
            ));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Row(
              children: [
                // Icon Avatar
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor.withOpacity(0.1),
                  ),
                  child: Icon(
                    contact.isEmergency ? Icons.local_hospital : Icons.person,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(width: 15),
                // Nama & Nomor
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Text(
                        contact.phoneNumber,
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                // Tombol Panggil Kecil
                IconButton(
                  icon: const Icon(Icons.call, color: accentColor),
                  onPressed: () => _makeCall(context, contact.phoneNumber),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- BUILD METHOD ---
  @override
  Widget build(BuildContext context) {
    final rawContacts = ref.watch(contactProvider);
    final filteredContacts = rawContacts.where((contact) {
      if (_currentFilter == 'Semua') {
        return true;
      }
      return contact.category == _currentFilter;
    }).toList();


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('SafeContact', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.grey),
            onPressed: () { /* TODO: Settings */ },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Akses Cepat Saat Darurat',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),

            // --- Tombol Panggil Darurat DENGAN ANIMASI ---
            ScaleTransition(
              scale: _scaleAnimation,
              child: SizedBox(
                width: double.infinity,
                height: 100,
                child: ElevatedButton.icon(
                  onPressed: () => _makeCall(context, '112'),
                  icon: const Icon(Icons.notifications_active_outlined, size: 30),
                  label: const Text(
                    'PANGGIL DARURAT',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor, 
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5, 
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // --- GRID LAYANAN UMUM (DENGAN PLN & PDAM) ---
            const Text(
              'Layanan Umum',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6, // <-- DITAMBAH: Jumlah item menjadi 6
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  // Tambahkan data nomor telepon ke setiap item
                  final data = [
                    {'icon': Icons.local_police, 'label': 'Polisi', 'color': Colors.blue.shade700, 'phone': '110'},
                    {'icon': Icons.local_hospital, 'label': 'Ambulans', 'color': accentColor, 'phone': '118'},
                    {'icon': Icons.fire_truck, 'label': 'Pemadam', 'color': Colors.orange.shade700, 'phone': '113'},
                    {'icon': Icons.water_drop, 'label': 'PDAM', 'color': Colors.blue.shade400, 'phone': '1500'}, // BARU: PDAM
                    {'icon': Icons.electrical_services, 'label': 'PLN', 'color': Colors.amber.shade700, 'phone': '123'}, 
                    {'icon': Icons.warning_amber, 'label': 'Bencana', 'color': primaryColor, 'phone': '112'},
                  ][index];
                  
                  // Panggil _buildServiceCard dengan argumen phoneNumber
                  return _buildServiceCard(
                    context, 
                    data['icon'] as IconData, 
                    data['label'] as String, 
                    data['color'] as Color,
                    data['phone'] as String,
                  );
                },
              ),
            ),
            const SizedBox(height: 30),

            // --- FILTER KATEGORI (Horizontal Scroll) ---
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFilterChip('Semua'), 
                  _buildFilterChip('Layanan Darurat'),
                  _buildFilterChip('Keluarga'),
                  _buildFilterChip('Teman'),
                  _buildFilterChip('Lainnya'),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // --- Bagian Daftar Kontak (Sudah Difilter) ---
            Text(
              'Daftar Kontak (${filteredContacts.length})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = filteredContacts[index];
                return _buildContactCard(context, contact, ref);
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      // --- Floating Action Button (FAB) ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AddEditScreen(), 
          ));
        },
        backgroundColor: accentColor,
        elevation: 6,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}