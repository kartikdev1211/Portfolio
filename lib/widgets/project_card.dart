import 'package:flutter/material.dart';

class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final List<String> tech;
  final bool isMobile;

  const ProjectCard({
    required this.title,
    required this.description,
    required this.tech,
    required this.isMobile,
  });

  @override
  State<ProjectCard> createState() => ProjectCardState();
}

class ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: widget.isMobile ? double.infinity : 350,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(_isHovered ? 0.08 : 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered
                ? const Color(0xFF00F5A0).withOpacity(0.5)
                : Colors.white.withOpacity(0.1),
            width: 2,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: const Color(0xFF00F5A0).withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00F5A0), Color(0xFF00D9F5)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.phone_android,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.description,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white.withOpacity(0.7),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.tech.map((tech) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00F5A0).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF00F5A0).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    tech,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF00F5A0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
