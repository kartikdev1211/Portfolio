import 'package:flutter/material.dart';

class HoverGlowButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const HoverGlowButton({super.key, required this.text, required this.onTap});

  @override
  State<HoverGlowButton> createState() => HoverGlowButtonState();
}

class HoverGlowButtonState extends State<HoverGlowButton> {
  bool isHovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: isHovering
              ? [
                  const BoxShadow(
                    color: Color(0xFF00F5A0),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: ElevatedButton(
          onPressed: widget.onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00F5A0),
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            widget.text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
