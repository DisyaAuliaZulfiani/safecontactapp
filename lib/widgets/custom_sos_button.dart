import 'package:flutter/material.dart';

// Custom Widget: Tombol SOS dengan animasi Scaling (untuk menarik perhatian)
class CustomSOSButton extends StatefulWidget {
  final VoidCallback onPressed;

  const CustomSOSButton({super.key, required this.onPressed});

  @override
  State<CustomSOSButton> createState() => _CustomSOSButtonState();
}

class _CustomSOSButtonState extends State<CustomSOSButton> with SingleTickerProviderStateMixin {
  // Controller untuk animasi
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true); // Animasi berulang

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Penggunaan ScaleTransition untuk menerapkan animasi
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Material(
        // Desain melingkar dan bayangan yang bagus
        elevation: 12,
        shape: const CircleBorder(),
        color: const Color(0xFFD32F2F), // Merah Cerah
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(100),
          child: Container(
            width: 150,
            height: 150,
            alignment: Alignment.center,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.gpp_bad, color: Colors.white, size: 50),
                Text(
                  'SOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}