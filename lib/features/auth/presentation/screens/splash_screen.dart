import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Brand colors (ดึงมาจาก design ของ Lumina Learn) ─────────────────────────
class _Brand {
  static const primary    = Color(0xFF4CAF88); // สีเขียว teal หลัก
  static const primaryDark = Color(0xFF2D8C68); // เขียวเข้ม
  static const accent     = Color(0xFFFFB347); // ส้มอบอุ่น (icon categories)
  static const surface    = Color(0xFFF0FAF5); // เขียวอ่อนมากสำหรับพื้นหลัง
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _shimmerController;
  late AnimationController _pulseController;
  late AnimationController _orbController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _textFade;
  late Animation<double> _shimmer;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    _shimmer = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.90, end: 1.10).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _orbController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _logoController.forward().then((_) => _textController.forward());

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go('/auth/login');
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _shimmerController.dispose();
    _pulseController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Gradient พื้นหลัง — เขียว teal ของ Lumina Learn ──────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF5DC99A), // เขียวสว่าง (top-left)
                  Color(0xFF4CAF88), // primary teal (กลาง)
                  Color(0xFF2D8C68), // เขียวเข้ม (bottom-right)
                ],
                stops: [0.0, 0.45, 1.0],
              ),
            ),
          ),

          // ── Floating orbs — สีขาวอ่อน เข้ากับ theme สีเขียว ──────────────
          AnimatedBuilder(
            animation: _orbController,
            builder: (_, __) {
              final t = _orbController.value * 2 * math.pi;
              return Stack(
                children: [
                  _Orb(
                    x: 0.1 + 0.08 * math.cos(t),
                    y: 0.12 + 0.06 * math.sin(t),
                    size: 180.w,
                    color: Colors.white.withOpacity(0.10),
                  ),
                  _Orb(
                    x: 0.75 + 0.06 * math.cos(t + math.pi),
                    y: 0.08 + 0.05 * math.sin(t + math.pi),
                    size: 130.w,
                    color: Colors.white.withOpacity(0.07),
                  ),
                  _Orb(
                    x: 0.65 + 0.07 * math.cos(t + 1),
                    y: 0.78 + 0.06 * math.sin(t + 1),
                    size: 200.w,
                    color: Colors.white.withOpacity(0.08),
                  ),
                  _Orb(
                    x: 0.05 + 0.05 * math.cos(t + 2),
                    y: 0.70 + 0.05 * math.sin(t + 2),
                    size: 100.w,
                    color: Colors.white.withOpacity(0.06),
                  ),
                  // orb พิเศษ — สีส้ม accent เล็กน้อยเพื่อ brand flavor
                  _Orb(
                    x: 0.85 + 0.04 * math.cos(t + 3),
                    y: 0.50 + 0.07 * math.sin(t + 3),
                    size: 80.w,
                    color: const Color(0xFFFFB347).withOpacity(0.12),
                  ),
                ],
              );
            },
          ),

          // ── Main content ──────────────────────────────────────────────────
          // Make content scrollable on small viewports and avoid Flex overflow
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth * 0.92,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                // ── Logo circle ──────────────────────────────────────────
                ScaleTransition(
                  scale: _logoScale,
                  child: FadeTransition(
                    opacity: _logoFade,
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (_, child) => Transform.scale(
                        scale: _pulse.value,
                        child: child,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Glow ring
                          Container(
                            width: 148.w,
                            height: 148.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.white.withOpacity(0.30),
                                  Colors.white.withOpacity(0.0),
                                ],
                              ),
                            ),
                          ),
                          // Icon circle — สีขาวโปร่งแสง บน bg เขียว
                          Container(
                            width: 120.w,
                            height: 120.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.50),
                                width: 2.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1A6B4A).withOpacity(0.35),
                                  blurRadius: 32,
                                  offset: const Offset(0, 14),
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.18),
                                  blurRadius: 20,
                                  spreadRadius: -4,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: AnimatedBuilder(
                                animation: _shimmer,
                                builder: (_, child) => ShaderMask(
                                  shaderCallback: (bounds) =>
                                      LinearGradient(
                                    begin: Alignment(_shimmer.value - 1, -0.5),
                                    end: Alignment(_shimmer.value, 0.5),
                                    colors: [
                                      Colors.white.withOpacity(0.0),
                                      Colors.white.withOpacity(0.45),
                                      Colors.white.withOpacity(0.0),
                                    ],
                                    stops: const [0.35, 0.5, 0.65],
                                  ).createShader(bounds),
                                  blendMode: BlendMode.srcATop,
                                  child: child,
                                ),
                                // เปลี่ยนไอคอนให้เข้ากับ "learning platform"
                                child: Icon(
                                  Icons.auto_stories_rounded,
                                  size: 56.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40.h),

                // ── Text block ────────────────────────────────────────────
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textFade,
                    child: Column(
                      children: [
                        // ชื่อแอป — Poppins ตรงกับ design
                        Text(
                          'Lumina Learn',
                          style: GoogleFonts.poppins(
                            fontSize: 34.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.20),
                                offset: const Offset(0, 4),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        // Tagline pill
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.w,
                            vertical: 7.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.35),
                            ),
                            color: Colors.white.withOpacity(0.12),
                          ),
                          child: Text(
                            'Learn, Book & Grow',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.92),
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 80.h),

                // ── Loading dots ──────────────────────────────────────────
                FadeTransition(
                  opacity: _textFade,
                  child: _LoadingDots(),
                ),
                ],
              ),
            ),
          );
        },
      ),
    ),

          // ── Bottom version tag ────────────────────────────────────────────
          Positioned(
            bottom: 32.h,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _textFade,
              child: Text(
                'v1.0.0',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: Colors.white.withOpacity(0.40),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ────────────────────────────────────────────────────────────────

class _Orb extends StatelessWidget {
  const _Orb({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
  });

  final double x, y, size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Positioned(
      left: screen.width * x - size / 2,
      top: screen.height * y - size / 2,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (i) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );
    _animations = _controllers
        .map(
          (c) => Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: c, curve: Curves.easeInOut),
          ),
        )
        .toList();

    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) _controllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (_, __) => Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.3 + 0.7 * _animations[i].value),
            ),
          ),
        );
      }),
    );
  }
}