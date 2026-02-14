// ignore_for_file: deprecated_member_use, unused_field

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freelance_portfolio/widgets/glass_navbar.dart';
import 'package:freelance_portfolio/widgets/project_card.dart';
import 'package:freelance_portfolio/widgets/social_buttons.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final homeKey = GlobalKey();
  final projectsKey = GlobalKey();
  final aboutKey = GlobalKey();
  final skillsKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  final double heroHeight = 900;
  final double sectionHeight = 600;

  late AnimationController _fadeController;
  late AnimationController _floatController;
  late AnimationController _pulseController;
  late AnimationController _staggerController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _pulseAnimation;

  // Scroll-based animations
  bool _aboutVisible = false;
  bool _skillsVisible = false;
  bool _projectsVisible = false;

  // Track if animations have been triggered manually
  bool _aboutTriggered = false;
  bool _skillsTriggered = false;
  bool _projectsTriggered = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _staggerController.forward();

    // Add scroll listener for scroll-triggered animations
    _scrollController.addListener(_onScroll);

    // Trigger initial check after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  void _onScroll() {
    _checkVisibility();
  }

  void _checkVisibility() {
    if (!mounted) return;

    final scrollPosition = _scrollController.offset;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate section positions
    final aboutPosition = _getSectionPosition(aboutKey);
    final skillsPosition = _getSectionPosition(skillsKey);
    final projectsPosition = _getSectionPosition(projectsKey);

    setState(() {
      // Trigger animation when section is 20% into viewport
      final triggerOffset = screenHeight * 0.8;

      if (aboutPosition != null &&
          scrollPosition + triggerOffset > aboutPosition &&
          !_aboutVisible) {
        _aboutVisible = true;
        _aboutTriggered = true;
      }

      if (skillsPosition != null &&
          scrollPosition + triggerOffset > skillsPosition &&
          !_skillsVisible) {
        _skillsVisible = true;
        _skillsTriggered = true;
      }

      if (projectsPosition != null &&
          scrollPosition + triggerOffset > projectsPosition &&
          !_projectsVisible) {
        _projectsVisible = true;
        _projectsTriggered = true;
      }
    });
  }

  double? _getSectionPosition(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return null;

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;

    return renderBox.localToGlobal(Offset.zero).dy + _scrollController.offset;
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _floatController.dispose();
    _pulseController.dispose();
    _staggerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;

    // Trigger animations immediately when clicking navbar
    if (key == aboutKey && !_aboutVisible) {
      setState(() => _aboutVisible = true);
    } else if (key == skillsKey && !_skillsVisible) {
      setState(() => _skillsVisible = true);
    } else if (key == projectsKey && !_projectsVisible) {
      setState(() => _projectsVisible = true);
    }

    // Scroll to section
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Responsive breakpoints
    final isMobile = width < 600;

    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          _buildAnimatedBackground(),

          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // ================= HERO =================
                _buildHeroSection(isMobile),

                // ================= ABOUT =================
                _buildAboutSection(isMobile),

                // ================= SKILLS =================
                _buildSkillsSection(isMobile),

                // ================= PROJECTS =================
                _buildProjectsSection(isMobile),

                // ================= FOOTER =================
                _buildFooter(isMobile),
              ],
            ),
          ),

          // ================= NAVBAR =================
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: Center(
              child: GlassNavbar(
                onHome: () => scrollToSection(homeKey),
                onAbout: () => scrollToSection(aboutKey),
                onSkills: () => scrollToSection(skillsKey),
                onProjects: () => scrollToSection(projectsKey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(bool isMobile) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600 && width < 1200;
    final isDesktop = width >= 1200;

    final horizontalPadding = isMobile
        ? 24.0
        : isTablet
        ? 60.0
        : 100.0;
    final verticalPadding = isMobile ? 60.0 : 100.0;
    final descFontSize = isMobile
        ? 14.0
        : isTablet
        ? 16.0
        : 18.0;
    final statsSpacing = isDesktop ? 60.0 : 40.0;

    return AnimatedOpacity(
      opacity: _aboutVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: _aboutVisible ? Offset.zero : const Offset(0, 0.1),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
        child: Container(
          key: aboutKey,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.15)),
          child: Column(
            children: [
              // Header - centered like Projects
              _buildSectionHeader('About Me', 'Experience & Background'),
              SizedBox(height: isMobile ? 40 : 50),

              // ABOUT TEXT - centered with fade-in
              _buildStaggeredItem(
                delay: 0,
                visible: _aboutVisible,
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Text(
                      "I'm a Flutter Developer and Software Engineer with a strong foundation in data structures and cross-platform mobile development. I build scalable, production-ready Flutter applications using Firebase, REST APIs, and modern state management like BLoC and Provider. I have experience working in fast-paced startup environments, delivering clean, high-performance, and user-focused mobile apps while collaborating with designers, backend engineers, and product teams.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: descFontSize,
                        color: Colors.white.withOpacity(0.75),
                        height: 1.7,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: isMobile ? 40 : 50),

              // STATS - centered with staggered animation
              _buildStaggeredItem(
                delay: 200,
                visible: _aboutVisible,
                child: Center(
                  child: Wrap(
                    spacing: isMobile ? 40 : statsSpacing,
                    runSpacing: isMobile ? 20 : 30,
                    alignment: WrapAlignment.center,
                    children: [
                      _aboutStat('2+', 'Years Experience'),
                      _aboutStat('10+', 'Apps & Projects'),
                      _aboutStat('3', 'Companies Worked With'),
                      _aboutStat('1', 'Live Play Store App'),
                    ],
                  ),
                ),
              ),

              SizedBox(height: isMobile ? 50 : 60),

              // EXPERIENCE TIMELINE - staggered
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    children: [
                      _buildStaggeredItem(
                        delay: 300,
                        visible: _aboutVisible,
                        child: _experienceItem(
                          year: 'Jul 2025 – Present',
                          role: 'Junior Flutter Developer · NMG Technologies',
                          desc:
                              'Working on scalable Flutter applications with a focus on performance, clean architecture, '
                              'and production-ready deployments.',
                        ),
                      ),
                      _buildStaggeredItem(
                        delay: 400,
                        visible: _aboutVisible,
                        child: _experienceItem(
                          year: 'Jul 2024 – Jul 2025',
                          role: 'Flutter Developer · Digitalshift Pvt Ltd',
                          desc:
                              'Developed and maintained Cloutin, an influencer marketing platform. '
                              'Integrated Firebase Cloud Messaging, Apple Sign-In, deep linking, and '
                              'state management using BLoC and Provider, improving engagement by 40%.',
                        ),
                      ),
                      _buildStaggeredItem(
                        delay: 500,
                        visible: _aboutVisible,
                        child: _experienceItem(
                          year: 'Apr 2023 – Aug 2023',
                          role: 'Flutter Developer · Zolatte',
                          desc:
                              'Built responsive and visually polished Flutter UIs for Android and iOS. '
                              'Improved app performance by 30% using lazy loading, widget optimization, '
                              'and efficient rendering techniques.',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStaggeredItem({
    required int delay,
    required bool visible,
    required Widget child,
  }) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(
        'stagger_${delay}_$visible',
      ), // Unique key using delay + visible
      tween: Tween(begin: 0.0, end: visible ? 1.0 : 0.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildSkillsSection(bool isMobile) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600 && width < 1200;

    final horizontalPadding = isMobile
        ? 24.0
        : isTablet
        ? 60.0
        : 100.0;
    final verticalPadding = isMobile ? 60.0 : 100.0;

    return AnimatedOpacity(
      opacity: _skillsVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: _skillsVisible ? Offset.zero : const Offset(0, 0.1),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
        child: Container(
          key: skillsKey,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            children: [
              _buildSectionHeader(
                'Technical Skills',
                'Technologies I Work With',
              ),
              SizedBox(height: isMobile ? 40 : 60),
              _buildSkillsGrid(isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillsGrid(bool isMobile) {
    final width = MediaQuery.of(context).size.width;

    final skills = [
      {
        'name': 'Flutter',
        'icon': Icons.flutter_dash,
        'color': const Color(0xFF02569B),
      },
      {'name': 'Dart', 'icon': Icons.code, 'color': const Color(0xFF0175C2)},
      {
        'name': 'Firebase',
        'icon': Icons.whatshot,
        'color': const Color(0xFFFFA000),
      },
      {
        'name': 'Git',
        'icon': FontAwesomeIcons.git,
        'color': const Color(0xFFF05032),
      },
      {
        'name': 'GitHub',
        'icon': FontAwesomeIcons.github,
        'color': const Color(0xFF181717),
      },
      {
        'name': 'Python',
        'icon': FontAwesomeIcons.python,
        'color': const Color(0xFF3776AB),
      },
      {
        'name': 'C/C++',
        'icon': Icons.code_rounded,
        'color': const Color(0xFF00599C),
      },
      {'name': 'Postman', 'icon': Icons.api, 'color': const Color(0xFFFF6C37)},
      {
        'name': 'REST API',
        'icon': Icons.cloud_queue,
        'color': const Color(0xFF00D9F5),
      },
      {
        'name': 'BLoC',
        'icon': Icons.view_stream,
        'color': const Color(0xFF00F5A0),
      },
      {
        'name': 'Provider',
        'icon': Icons.settings_suggest,
        'color': const Color(0xFF00F5A0),
      },
      {
        'name': 'MongoDB',
        'icon': FontAwesomeIcons.database,
        'color': const Color(0xFF47A248),
      },
    ];

    // Responsive spacing and sizing
    final spacing = isMobile
        ? 12.0
        : width < 1200
        ? 16.0
        : 20.0;
    final runSpacing = isMobile
        ? 12.0
        : width < 1200
        ? 16.0
        : 20.0;

    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      alignment: WrapAlignment.center,
      children: skills.asMap().entries.map((entry) {
        int index = entry.key;
        var skill = entry.value;

        return TweenAnimationBuilder<double>(
          key: ValueKey('skill_${skill['name']}_$_skillsVisible'),
          tween: Tween(begin: 0.0, end: _skillsVisible ? 1.0 : 0.0),
          duration: Duration(milliseconds: 400 + (index * 50)),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.scale(scale: 0.8 + (0.2 * value), child: child),
            );
          },
          child: _SkillCard(
            name: skill['name'] as String,
            icon: skill['icon'] as IconData,
            color: skill['color'] as Color,
            isMobile: isMobile,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter(bool isMobile) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600 && width < 1200;

    final horizontalPadding = isMobile
        ? 24.0
        : isTablet
        ? 60.0
        : 100.0;
    final verticalPadding = isMobile ? 40.0 : 60.0;
    final titleFontSize = isMobile
        ? 24.0
        : isTablet
        ? 28.0
        : 36.0;
    final emailFontSize = isMobile
        ? 14.0
        : isTablet
        ? 18.0
        : 20.0;
    final locationFontSize = isMobile
        ? 12.0
        : isTablet
        ? 14.0
        : 16.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
      child: Column(
        children: [
          // Contact Info
          Text(
            'Let\'s Connect',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isMobile ? 16 : 20),

          // Email
          InkWell(
            onTap: () async {
              final uri = Uri(
                scheme: 'mailto',
                path: 'kartikkysp12@gmail.com',
                query: 'subject=Let\'s Work Together',
              );

              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
            child: Text(
              'kartikkysp12@gmail.com',
              style: TextStyle(
                fontSize: emailFontSize,
                color: const Color(0xFF00F5A0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(height: isMobile ? 8 : 10),

          // Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                size: isMobile ? 14 : 16,
                color: Colors.white.withOpacity(0.6),
              ),
              const SizedBox(width: 4),
              Text(
                'New Delhi, India',
                style: TextStyle(
                  fontSize: locationFontSize,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),

          SizedBox(height: isMobile ? 24 : 30),

          // Social Links
          _buildSocialLinks(),
        ],
      ),
    );
  }

  Widget _aboutStat(String value, String label) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1200;

    final valueFontSize = isMobile
        ? 28.0
        : isTablet
        ? 32.0
        : 34.0;
    final labelFontSize = isMobile ? 12.0 : 14.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TweenAnimationBuilder<int>(
          key: ValueKey('stat_$label\_$_aboutVisible'),
          tween: IntTween(
            begin: 0,
            end: _aboutVisible
                ? (int.tryParse(value.replaceAll('+', '')) ?? 0)
                : 0,
          ),
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeOut,
          builder: (context, count, child) {
            return Text(
              value.contains('+') ? '$count+' : '$count',
              style: TextStyle(
                fontSize: valueFontSize,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF00F5A0),
              ),
            );
          },
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: labelFontSize,
          ),
        ),
      ],
    );
  }

  Widget _experienceItem({
    required String year,
    required String role,
    required String desc,
  }) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              year,
              style: const TextStyle(
                color: Color(0xFF00F5A0),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              role,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              desc,
              style: TextStyle(
                color: Colors.white.withOpacity(0.65),
                height: 1.6,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              year,
              style: const TextStyle(
                color: Color(0xFF00F5A0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Floating orbs with enhanced animation
            ...List.generate(3, (index) {
              return AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) {
                  return Positioned(
                    top: 100.0 + (index * 250) + _floatAnimation.value,
                    left: (index % 2 == 0) ? -50 : null,
                    right: (index % 2 != 0) ? -50 : null,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 1000 + (index * 200)),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value * 0.8,
                          child: Transform.scale(scale: value, child: child),
                        );
                      },
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF00F5A0).withOpacity(0.1),
                              const Color(0xFF00D9F5).withOpacity(0.05),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isMobile) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600 && width < 1200;
    final isDesktop = width >= 1200;

    final heroHeight = isMobile
        ? 700.0
        : isTablet
        ? 800.0
        : 900.0;
    final horizontalPadding = isMobile
        ? 24.0
        : isTablet
        ? 60.0
        : 100.0;
    final titleFontSize = isMobile
        ? 36.0
        : isTablet
        ? 52.0
        : 72.0;
    final roleFontSize = isMobile
        ? 18.0
        : isTablet
        ? 24.0
        : 32.0;
    final descFontSize = isMobile
        ? 14.0
        : isTablet
        ? 16.0
        : 18.0;

    return Container(
      key: homeKey,
      height: heroHeight,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: isMobile ? 40 : 60,
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated subtitle with pulse
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: child,
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 16,
                  vertical: isMobile ? 6 : 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF00F5A0).withOpacity(0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xFF00F5A0).withOpacity(0.1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00F5A0),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Available for work',
                      style: TextStyle(
                        color: const Color(0xFF00F5A0),
                        fontSize: isMobile ? 12 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: isMobile ? 24 : 32),

            // Name with enhanced gradient and slide-in animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(-50 * (1 - value), 0),
                    child: child,
                  ),
                );
              },
              child: Text(
                'Kartik Kashyap',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w900,
                  letterSpacing: isMobile ? 0 : 1,
                  height: 1.1,
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [Color(0xFF00F5A0), Color(0xFF00D9F5)],
                    ).createShader(const Rect.fromLTWH(0, 0, 500, 100)),
                ),
              ),
            ),

            SizedBox(height: isMobile ? 12 : 16),

            // Role with typing effect style and delay
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(-30 * (1 - value), 0),
                    child: child,
                  ),
                );
              },
              child: Text(
                'Flutter Developer',
                style: TextStyle(
                  fontSize: roleFontSize,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                  letterSpacing: isMobile ? 0 : 2,
                ),
              ),
            ),

            SizedBox(height: isMobile ? 16 : 24),

            // Description with fade-in
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(opacity: value, child: child);
              },
              child: SizedBox(
                width: isMobile ? double.infinity : 650,
                child: Text(
                  'I build futuristic, high-performance mobile apps with Flutter that scale. Specializing in beautiful UIs, smooth animations, and pixel-perfect designs.',
                  style: TextStyle(
                    fontSize: descFontSize,
                    color: Colors.white.withOpacity(0.7),
                    height: 1.7,
                  ),
                ),
              ),
            ),

            SizedBox(height: isMobile ? 30 : 40),

            // Stats row with staggered animation
            if (!isMobile) ...[
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1400),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Wrap(
                  spacing: isDesktop ? 60 : 40,
                  runSpacing: 20,
                  children: [
                    _buildStatItem('2+', 'Years Experience'),
                    _buildStatItem('10+', 'Projects & Apps'),
                    _buildStatItem('3', 'Companies Worked'),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600 && width < 1200;

    final valueFontSize = isTablet ? 32.0 : 36.0;
    final labelFontSize = isTablet ? 13.0 : 14.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TweenAnimationBuilder<int>(
          tween: IntTween(
            begin: 0,
            end: int.tryParse(value.replaceAll('+', '')) ?? 0,
          ),
          duration: const Duration(milliseconds: 2000),
          curve: Curves.easeOut,
          builder: (context, count, child) {
            return Text(
              value.contains('+') ? '$count+' : '$count',
              style: TextStyle(
                fontSize: valueFontSize,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF00F5A0),
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: labelFontSize,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLinks() {
    final socialLinks = [
      {
        'icon': FontAwesomeIcons.github,
        'url': 'https://github.com/kartikdev1211',
        'label': 'GitHub',
      },
      {
        'icon': FontAwesomeIcons.linkedin,
        'url': 'https://www.linkedin.com/in/kartik-kashyap-35308b230/',
        'label': 'LinkedIn',
      },
      {
        'icon': FontAwesomeIcons.instagram,
        'url': 'https://www.instagram.com/kartikkashyap1211/?next=',
        'label': 'Instagram',
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: socialLinks.asMap().entries.map((entry) {
        int index = entry.key;
        var social = entry.value;

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 800 + (index * 100)),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.scale(scale: 0.5 + (0.5 * value), child: child),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SocialIconButton(
              icon: social['icon'] as IconData,
              url: social['url'] as String,
              label: social['label'] as String,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProjectsSection(bool isMobile) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600 && width < 1200;

    final horizontalPadding = isMobile
        ? 24.0
        : isTablet
        ? 60.0
        : 100.0;
    final verticalPadding = isMobile ? 60.0 : 100.0;

    return AnimatedOpacity(
      opacity: _projectsVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: _projectsVisible ? Offset.zero : const Offset(0, 0.1),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
        child: Container(
          key: projectsKey,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.15)),
          child: Column(
            children: [
              _buildSectionHeader('Featured Projects', 'My Recent Work'),
              SizedBox(height: isMobile ? 40 : 60),
              _buildProjectGrid(isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1200;

    final subtitleFontSize = isMobile
        ? 12.0
        : isTablet
        ? 14.0
        : 16.0;
    final titleFontSize = isMobile
        ? 32.0
        : isTablet
        ? 40.0
        : 48.0;

    return Column(
      children: [
        Text(
          subtitle,
          style: TextStyle(
            fontSize: subtitleFontSize,
            color: const Color(0xFF00F5A0),
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 100,
          height: 4,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00F5A0), Color(0xFF00D9F5)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectGrid(bool isMobile) {
    final width = MediaQuery.of(context).size.width;

    int crossAxisCount;
    double aspectRatio;
    double spacing;

    // More responsive breakpoints
    if (width < 600) {
      crossAxisCount = 1;
      aspectRatio = 0.85;
      spacing = 16;
    } else if (width < 900) {
      crossAxisCount = 2;
      aspectRatio = 0.95;
      spacing = 18;
    } else if (width < 1200) {
      crossAxisCount = 2;
      aspectRatio = 1.0;
      spacing = 20;
    } else {
      crossAxisCount = 3;
      aspectRatio = 1.05;
      spacing = 24;
    }

    final projects = [
      {
        'title': 'Cloutin – Influencer Marketing Platform',
        'description':
            'A production-grade marketplace app connecting brands and influencers with '
            'earnings tracking, payments, and real-time notifications. Live on Play Store.',
        'tech': ['Flutter', 'Firebase', 'Cloud Functions', 'FCM', 'BLoC'],
      },
      {
        'title': 'E-Commerce App',
        'description':
            'Scalable e-commerce application with authentication, real-time cart, '
            'order management, and secure checkout.',
        'tech': ['Flutter', 'Node.js', 'MongoDB', 'REST API'],
      },
      {
        'title': 'Smart Fit – Outfit Recommendation App',
        'description':
            'A full-stack Flutter app that suggests outfits based on weather, occasion, '
            'and user wardrobe using a FastAPI backend and JWT authentication.',
        'tech': ['Flutter', 'FastAPI', 'JWT', 'REST API', 'BLoC'],
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: aspectRatio,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];

        return ProjectCard(
          title: project['title'] as String,
          description: project['description'] as String,
          tech: project['tech'] as List<String>,
          isMobile: width < 600,
        );
      },
    );
  }
}

// ================= SKILL CARD =================

class _SkillCard extends StatefulWidget {
  final String name;
  final IconData icon;
  final Color color;
  final bool isMobile;

  const _SkillCard({
    required this.name,
    required this.icon,
    required this.color,
    required this.isMobile,
  });

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1200;

    final cardSize = isMobile
        ? 140.0
        : isTablet
        ? 155.0
        : 160.0;
    final padding = isMobile ? 20.0 : 24.0;
    final iconSize = isMobile ? 36.0 : 40.0;
    final textSize = isMobile ? 13.0 : 15.0;
    final borderRadius = isMobile ? 14.0 : 16.0;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _bounceController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _bounceController.reverse();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: cardSize,
        padding: EdgeInsets.symmetric(
          vertical: padding,
          horizontal: padding - 4,
        ),
        decoration: BoxDecoration(
          color: _isHovered
              ? widget.color.withOpacity(0.1)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: _isHovered
                ? widget.color.withOpacity(0.5)
                : Colors.white.withOpacity(0.1),
            width: 2,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.color.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -10 * _bounceAnimation.value),
                  child: Transform.rotate(
                    angle: 0.1 * _bounceAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Icon(
                widget.icon,
                size: iconSize,
                color: _isHovered ? widget.color : Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: textSize,
                fontWeight: FontWeight.w600,
                color: _isHovered ? widget.color : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
