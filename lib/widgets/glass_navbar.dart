import 'dart:ui';
import 'package:flutter/material.dart';

class GlassNavbar extends StatelessWidget {
  final VoidCallback onHome;
  final VoidCallback onAbout;
  final VoidCallback onSkills;
  final VoidCallback onProjects;
  const GlassNavbar({
    super.key,
    required this.onHome,
    required this.onAbout,
    required this.onSkills,
    required this.onProjects,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _NavItem(title: 'Home', onTap: onHome),
              _NavItem(title: 'About', onTap: onAbout),
              _NavItem(title: 'Skills', onTap: onSkills),
              _NavItem(title: 'Projects', onTap: onProjects),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  const _NavItem({required this.title, required this.onTap});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              color: isHovering ? const Color(0xFF00F5A0) : Colors.white70,
              fontWeight: FontWeight.w600,
            ),
            child: Text(widget.title),
          ),
        ),
      ),
    );
  }
}
