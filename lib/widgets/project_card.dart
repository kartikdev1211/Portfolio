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
    return LayoutBuilder(
      builder: (context, constraints) {
        final parentWidth = constraints.maxWidth;

        // Responsive sizing based on actual screen width
        double cardPadding;
        double titleFontSize;
        double descFontSize;
        double techFontSize;
        double iconSize;
        double iconIconSize;
        double spacing;
        double borderRadius;

        if (parentWidth < 400) {
          // Extra small mobile
          cardPadding = 16;
          titleFontSize = 16;
          descFontSize = 12;
          techFontSize = 10;
          iconSize = 45;
          iconIconSize = 22;
          spacing = 14;
          borderRadius = 14;
        } else if (parentWidth < 600) {
          // Small mobile
          cardPadding = 20;
          titleFontSize = 18;
          descFontSize = 13;
          techFontSize = 11;
          iconSize = 50;
          iconIconSize = 24;
          spacing = 16;
          borderRadius = 16;
        } else if (parentWidth < 900) {
          // Large mobile / small tablet
          cardPadding = 22;
          titleFontSize = 19;
          descFontSize = 13.5;
          techFontSize = 11;
          iconSize = 55;
          iconIconSize = 26;
          spacing = 20;
          borderRadius = 18;
        } else if (parentWidth < 1200) {
          // Tablet
          cardPadding = 24;
          titleFontSize = 20;
          descFontSize = 14;
          techFontSize = 11;
          iconSize = 58;
          iconIconSize = 28;
          spacing = 22;
          borderRadius = 19;
        } else {
          // Desktop
          cardPadding = 30;
          titleFontSize = 24;
          descFontSize = 15;
          techFontSize = 12;
          iconSize = 60;
          iconIconSize = 30;
          spacing = 24;
          borderRadius = 20;
        }

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: constraints.maxWidth,
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
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
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

                // Title
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: spacing * 0.5),

                // Description
                Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: descFontSize,
                    color: Colors.white.withOpacity(0.7),
                    height: 1.6,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: spacing - 4),

                // Tech tags
                Wrap(
                  spacing: parentWidth < 600 ? 6 : 8,
                  runSpacing: parentWidth < 600 ? 6 : 8,
                  children: widget.tech.map((tech) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: parentWidth < 600 ? 10 : 12,
                        vertical: parentWidth < 600 ? 5 : 6,
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
      },
    );
  }
}
