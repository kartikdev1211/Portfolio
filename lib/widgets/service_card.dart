import 'package:flutter/material.dart';

class ServiceCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isMobile;

  const ServiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.isMobile,
  });

  @override
  State<ServiceCard> createState() => ServiceCardState();
}

class ServiceCardState extends State<ServiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: widget.isMobile ? double.infinity : 280,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(_isHovered ? 0.08 : 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered
                ? const Color(0xFF00D9F5).withOpacity(0.5)
                : Colors.white.withOpacity(0.1),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              transform: Matrix4.translationValues(0, _isHovered ? -10 : 0, 0),
              child: Icon(
                widget.icon,
                size: 50,
                color: const Color(0xFF00D9F5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
