// ignore_for_file: deprecated_member_use, unused_field, unused_local_variable

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/widgets/glass_navbar.dart';
import 'package:portfolio/widgets/project_card.dart';
import 'package:portfolio/widgets/social_buttons.dart';
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

  // Helper method for responsive values
  T _responsive<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return desktop ?? tablet ?? mobile;
    if (width >= 600) return tablet ?? mobile;
    return mobile;
  }

  @override
  Widget build(BuildContext context) {
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
                _buildHeroSection(context),

                // ================= ABOUT =================
                _buildAboutSection(context),

                // ================= SKILLS =================
                _buildSkillsSection(context),

                // ================= PROJECTS =================
                _buildProjectsSection(context),

                // ================= FOOTER =================
                _buildFooter(context),
              ],
            ),
          ),

          // ================= NAVBAR =================
          Positioned(
            top: _responsive(
              context: context,
              mobile: 20,
              tablet: 25,
              desktop: 30,
            ),
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

  Widget _buildAboutSection(BuildContext context) {
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
            horizontal: _responsive(
              context: context,
              mobile: 24,
              tablet: 60,
              desktop: 100,
            ),
            vertical: _responsive(
              context: context,
              mobile: 60,
              tablet: 80,
              desktop: 100,
            ),
          ),
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.15)),
          child: Column(
            children: [
              // Header
              _buildSectionHeader(
                context,
                'About Me',
                'Experience & Background',
              ),
              SizedBox(
                height: _responsive(
                  context: context,
                  mobile: 40,
                  tablet: 45,
                  desktop: 50,
                ),
              ),

              // ABOUT TEXT
              _buildStaggeredItem(
                delay: 0,
                visible: _aboutVisible,
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: _responsive(
                        context: context,
                        mobile: double.infinity,
                        tablet: 800,
                        desktop: 900,
                      ),
                    ),
                    child: Text(
                      "I'm a Flutter Developer and Software Engineer with a strong foundation in data structures and cross-platform mobile development. I build scalable, production-ready Flutter applications using Firebase, REST APIs, and modern state management like BLoC and Provider. I have experience working in fast-paced startup environments, delivering clean, high-performance, and user-focused mobile apps while collaborating with designers, backend engineers, and product teams.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: _responsive(
                          context: context,
                          mobile: 14,
                          tablet: 16,
                          desktop: 18,
                        ),
                        color: Colors.white.withOpacity(0.75),
                        height: 1.7,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: _responsive(
                  context: context,
                  mobile: 40,
                  tablet: 45,
                  desktop: 50,
                ),
              ),

              // STATS
              _buildStaggeredItem(
                delay: 200,
                visible: _aboutVisible,
                child: Center(
                  child: Wrap(
                    spacing: _responsive(
                      context: context,
                      mobile: 40,
                      tablet: 50,
                      desktop: 60,
                    ),
                    runSpacing: _responsive(
                      context: context,
                      mobile: 20,
                      tablet: 25,
                      desktop: 30,
                    ),
                    alignment: WrapAlignment.center,
                    children: [
                      _aboutStat(context, '2+', 'Years Experience'),
                      _aboutStat(context, '10+', 'Apps & Projects'),
                      _aboutStat(context, '3', 'Companies Worked With'),
                      _aboutStat(context, '1', 'Live Play Store App'),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: _responsive(
                  context: context,
                  mobile: 50,
                  tablet: 55,
                  desktop: 60,
                ),
              ),

              // EXPERIENCE TIMELINE
              Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: _responsive(
                      context: context,
                      mobile: double.infinity,
                      tablet: 800,
                      desktop: 900,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildStaggeredItem(
                        delay: 300,
                        visible: _aboutVisible,
                        child: _experienceItem(
                          context: context,
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
                          context: context,
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
                          context: context,
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
      key: ValueKey('stagger_${delay}_$visible'),
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

  Widget _buildSkillsSection(BuildContext context) {
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
            horizontal: _responsive(
              context: context,
              mobile: 24,
              tablet: 60,
              desktop: 100,
            ),
            vertical: _responsive(
              context: context,
              mobile: 60,
              tablet: 80,
              desktop: 100,
            ),
          ),
          child: Column(
            children: [
              _buildSectionHeader(
                context,
                'Technical Skills',
                'Technologies I Work With',
              ),
              SizedBox(
                height: _responsive(
                  context: context,
                  mobile: 40,
                  tablet: 50,
                  desktop: 60,
                ),
              ),
              _buildSkillsGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillsGrid(BuildContext context) {
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Calculate number of columns based on available width
        int columns;
        if (width < 400) {
          columns = 2;
        } else if (width < 600) {
          columns = 3;
        } else if (width < 900) {
          columns = 4;
        } else if (width < 1200) {
          columns = 5;
        } else {
          columns = 6;
        }

        final spacing = _responsive(
          context: context,
          mobile: 12,
          tablet: 16,
          desktop: 20,
        );

        return Wrap(
          spacing: spacing.toDouble(),
          runSpacing: spacing.toDouble(),
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
                  child: Transform.scale(
                    scale: 0.8 + (0.2 * value),
                    child: child,
                  ),
                );
              },
              child: _SkillCard(
                name: skill['name'] as String,
                icon: skill['icon'] as IconData,
                color: skill['color'] as Color,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: _responsive(
          context: context,
          mobile: 24,
          tablet: 60,
          desktop: 100,
        ),
        vertical: _responsive(
          context: context,
          mobile: 40,
          tablet: 50,
          desktop: 60,
        ),
      ),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
      child: Column(
        children: [
          // Contact Info
          Text(
            'Let\'s Connect',
            style: TextStyle(
              fontSize: _responsive(
                context: context,
                mobile: 24,
                tablet: 28,
                desktop: 36,
              ),
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: _responsive(
              context: context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
          ),

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
                fontSize: _responsive(
                  context: context,
                  mobile: 14,
                  tablet: 18,
                  desktop: 20,
                ),
                color: const Color(0xFF00F5A0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(
            height: _responsive(
              context: context,
              mobile: 8,
              tablet: 9,
              desktop: 10,
            ),
          ),

          // Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                size: _responsive(
                  context: context,
                  mobile: 14,
                  tablet: 15,
                  desktop: 16,
                ),
                color: Colors.white.withOpacity(0.6),
              ),
              const SizedBox(width: 4),
              Text(
                'New Delhi, India',
                style: TextStyle(
                  fontSize: _responsive(
                    context: context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 16,
                  ),
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),

          SizedBox(
            height: _responsive(
              context: context,
              mobile: 24,
              tablet: 27,
              desktop: 30,
            ),
          ),

          // Social Links
          _buildSocialLinks(),
        ],
      ),
    );
  }

  Widget _aboutStat(BuildContext context, String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TweenAnimationBuilder<int>(
          key: ValueKey('stat_${label}_$_aboutVisible'),
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
                fontSize: _responsive(
                  context: context,
                  mobile: 28,
                  tablet: 32,
                  desktop: 34,
                ),
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
            fontSize: _responsive(
              context: context,
              mobile: 12,
              tablet: 13,
              desktop: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _experienceItem({
    required BuildContext context,
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
              style: TextStyle(
                color: const Color(0xFF00F5A0),
                fontWeight: FontWeight.w600,
                fontSize: _responsive(
                  context: context,
                  mobile: 12,
                  tablet: 13,
                  desktop: 14,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              role,
              style: TextStyle(
                fontSize: _responsive(
                  context: context,
                  mobile: 14,
                  tablet: 16,
                  desktop: 18,
                ),
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
                fontSize: _responsive(
                  context: context,
                  mobile: 13,
                  tablet: 14,
                  desktop: 15,
                ),
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
            width: _responsive(
              context: context,
              mobile: 120,
              tablet: 140,
              desktop: 160,
            ),
            child: Text(
              year,
              style: TextStyle(
                color: const Color(0xFF00F5A0),
                fontWeight: FontWeight.w600,
                fontSize: _responsive(
                  context: context,
                  mobile: 13,
                  tablet: 14,
                  desktop: 15,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role,
                  style: TextStyle(
                    fontSize: _responsive(
                      context: context,
                      mobile: 16,
                      tablet: 17,
                      desktop: 18,
                    ),
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
                    fontSize: _responsive(
                      context: context,
                      mobile: 14,
                      tablet: 15,
                      desktop: 16,
                    ),
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

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      key: homeKey,
      constraints: BoxConstraints(
        minHeight: _responsive(
          context: context,
          mobile: 600,
          tablet: 700,
          desktop: 800,
        ),
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: _responsive(
          context: context,
          mobile: 24,
          tablet: 60,
          desktop: 100,
        ),
        vertical: _responsive(
          context: context,
          mobile: 40,
          tablet: 50,
          desktop: 60,
        ),
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
                  horizontal: _responsive(
                    context: context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 16,
                  ),
                  vertical: _responsive(
                    context: context,
                    mobile: 6,
                    tablet: 7,
                    desktop: 8,
                  ),
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
                        fontSize: _responsive(
                          context: context,
                          mobile: 12,
                          tablet: 13,
                          desktop: 14,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: _responsive(
                context: context,
                mobile: 24,
                tablet: 28,
                desktop: 32,
              ),
            ),

            // Name with enhanced gradient
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
                  fontSize: _responsive(
                    context: context,
                    mobile: 36,
                    tablet: 52,
                    desktop: 72,
                  ),
                  fontWeight: FontWeight.w900,
                  letterSpacing: _responsive(
                    context: context,
                    mobile: 0,
                    tablet: 0.5,
                    desktop: 1,
                  ),
                  height: 1.1,
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [Color(0xFF00F5A0), Color(0xFF00D9F5)],
                    ).createShader(const Rect.fromLTWH(0, 0, 500, 100)),
                ),
              ),
            ),

            SizedBox(
              height: _responsive(
                context: context,
                mobile: 12,
                tablet: 14,
                desktop: 16,
              ),
            ),

            // Role
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
                  fontSize: _responsive(
                    context: context,
                    mobile: 18,
                    tablet: 24,
                    desktop: 32,
                  ),
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                  letterSpacing: _responsive(
                    context: context,
                    mobile: 0,
                    tablet: 1,
                    desktop: 2,
                  ),
                ),
              ),
            ),

            SizedBox(
              height: _responsive(
                context: context,
                mobile: 16,
                tablet: 20,
                desktop: 24,
              ),
            ),

            // Description
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(opacity: value, child: child);
              },
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: _responsive(
                    context: context,
                    mobile: double.infinity,
                    tablet: 600,
                    desktop: 650,
                  ),
                ),
                child: Text(
                  'I build futuristic, high-performance mobile apps with Flutter that scale. Specializing in beautiful UIs, smooth animations, and pixel-perfect designs.',
                  style: TextStyle(
                    fontSize: _responsive(
                      context: context,
                      mobile: 14,
                      tablet: 16,
                      desktop: 18,
                    ),
                    color: Colors.white.withOpacity(0.7),
                    height: 1.7,
                  ),
                ),
              ),
            ),

            SizedBox(
              height: _responsive(
                context: context,
                mobile: 30,
                tablet: 35,
                desktop: 40,
              ),
            ),

            // Stats row (hidden on mobile)
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  return const SizedBox.shrink();
                }

                return TweenAnimationBuilder<double>(
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
                    spacing: _responsive(
                      context: context,
                      mobile: 40,
                      tablet: 50,
                      desktop: 60,
                    ),
                    runSpacing: 20,
                    children: [
                      _buildStatItem(context, '2+', 'Years Experience'),
                      _buildStatItem(context, '10+', 'Projects & Apps'),
                      _buildStatItem(context, '3', 'Companies Worked'),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
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
                fontSize: _responsive(
                  context: context,
                  mobile: 32,
                  tablet: 34,
                  desktop: 36,
                ),
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
            fontSize: _responsive(
              context: context,
              mobile: 13,
              tablet: 13,
              desktop: 14,
            ),
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

  Widget _buildProjectsSection(BuildContext context) {
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
            horizontal: _responsive(
              context: context,
              mobile: 24,
              tablet: 60,
              desktop: 100,
            ),
            vertical: _responsive(
              context: context,
              mobile: 60,
              tablet: 80,
              desktop: 100,
            ),
          ),
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.15)),
          child: Column(
            children: [
              _buildSectionHeader(
                context,
                'Featured Projects',
                'My Recent Work',
              ),
              SizedBox(
                height: _responsive(
                  context: context,
                  mobile: 40,
                  tablet: 50,
                  desktop: 60,
                ),
              ),
              _buildProjectGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    return Column(
      children: [
        Text(
          subtitle,
          style: TextStyle(
            fontSize: _responsive(
              context: context,
              mobile: 12,
              tablet: 14,
              desktop: 16,
            ),
            color: const Color(0xFF00F5A0),
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: _responsive(
              context: context,
              mobile: 32,
              tablet: 40,
              desktop: 48,
            ),
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

  Widget _buildProjectGrid(BuildContext context) {
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        int crossAxisCount;
        double aspectRatio;
        double spacing;

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

        // return GridView.builder(
        //   shrinkWrap: true,
        //   physics: const NeverScrollableScrollPhysics(),
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: crossAxisCount,
        //     crossAxisSpacing: spacing,
        //     mainAxisSpacing: spacing,
        //     childAspectRatio: aspectRatio,
        //   ),
        //   itemCount: projects.length,
        //   itemBuilder: (context, index) {
        //     final project = projects[index];

        //     return ProjectCard(
        //       title: project['title'] as String,
        //       description: project['description'] as String,
        //       tech: project['tech'] as List<String>,
        //       isMobile: width < 600,
        //     );
        //   },
        // );
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: projects.map((project) {
            return SizedBox(
              width: width < 600
                  ? width
                  : width < 900
                  ? (width / 2) - spacing
                  : (width / 3) - spacing,
              child: ProjectCard(
                title: project['title'] as String,
                description: project['description'] as String,
                tech: project['tech'] as List<String>,
                isMobile: width < 600,
              ),
            );
          }).toList(),
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

  const _SkillCard({
    required this.name,
    required this.icon,
    required this.color,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final parentWidth = MediaQuery.of(context).size.width;

        // Calculate responsive sizes based on screen width
        double cardSize;
        double padding;
        double iconSize;
        double textSize;
        double borderRadius;

        if (parentWidth < 400) {
          cardSize = 130;
          padding = 16;
          iconSize = 32;
          textSize = 12;
          borderRadius = 12;
        } else if (parentWidth < 600) {
          cardSize = 140;
          padding = 20;
          iconSize = 36;
          textSize = 13;
          borderRadius = 14;
        } else if (parentWidth < 1200) {
          cardSize = 155;
          padding = 22;
          iconSize = 38;
          textSize = 14;
          borderRadius = 15;
        } else {
          cardSize = 160;
          padding = 24;
          iconSize = 40;
          textSize = 15;
          borderRadius = 16;
        }

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
      },
    );
  }
}
