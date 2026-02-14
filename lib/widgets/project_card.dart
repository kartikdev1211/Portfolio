import 'package:flutter/material.dart';

class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final List<String> tech;
  final bool isMobile;

  const ProjectCard({
    super.key,
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
    final width = MediaQuery.of(context).size.width;

    // Responsive breakpoints
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1200;

    // Responsive sizing
    double cardPadding = isMobile
        ? 20
        : isTablet
        ? 24
        : 30;
    double titleFontSize = isMobile
        ? 18
        : isTablet
        ? 20
        : 24;
    double descFontSize = isMobile
        ? 13
        : isTablet
        ? 14
        : 15;
    double techFontSize = isMobile
        ? 11
        : isTablet
        ? 11
        : 12;
    double iconSize = isMobile ? 50 : 60;
    double iconIconSize = isMobile ? 24 : 30;
    double spacing = isMobile ? 16 : 24;
    double borderRadius = isMobile ? 16 : 20;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isMobile ? double.infinity : null,
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(_isHovered ? 0.08 : 0.05),
          borderRadius: BorderRadius.circular(borderRadius),
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
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00F5A0), Color(0xFF00D9F5)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.phone_android,
                color: Colors.white,
                size: iconIconSize,
              ),
            ),
            SizedBox(height: spacing),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.description,
              style: TextStyle(
                fontSize: descFontSize,
                color: Colors.white.withOpacity(0.7),
                height: 1.6,
              ),
            ),
            SizedBox(height: spacing - 4),
            Wrap(
              spacing: isMobile ? 6 : 8,
              runSpacing: isMobile ? 6 : 8,
              children: widget.tech.map((tech) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 10 : 12,
                    vertical: isMobile ? 5 : 6,
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
                    style: TextStyle(
                      fontSize: techFontSize,
                      color: const Color(0xFF00F5A0),
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
