import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialIconButton extends StatefulWidget {
  final IconData icon;
  final String url;
  final String label;

  const SocialIconButton({
    super.key,
    required this.icon,
    required this.url,
    required this.label,
  });

  @override
  State<SocialIconButton> createState() => SocialIconButtonState();
}

class SocialIconButtonState extends State<SocialIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Tooltip(
        message: widget.label,
        child: GestureDetector(
          onTap: () async {
            final uri = Uri.parse(widget.url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _isHovered
                  ? const Color(0xFF00F5A0).withOpacity(0.15)
                  : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isHovered
                    ? const Color(0xFF00F5A0)
                    : Colors.white.withOpacity(0.2),
                width: 2,
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: const Color(0xFF00F5A0).withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 300),
              scale: _isHovered ? 1.1 : 1.0,
              child: Icon(
                widget.icon,
                color: _isHovered ? const Color(0xFF00F5A0) : Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
