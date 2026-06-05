import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learn_hub/core/theme/app_theme.dart';
import 'package:learn_hub/shared/widgets/common_widgets.dart';
import 'package:learn_hub/shared/constants/app_strings.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase, AuthException;
import 'package:learn_hub/features/auth/domain/providers/auth_provider.dart';
import 'package:learn_hub/features/auth/domain/entities/user.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with TickerProviderStateMixin {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late AnimationController _bgController;
  late AnimationController _contentController;
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _contentFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );
    _contentSlide =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentController,
            curve: Curves.easeOutCubic,
          ),
        );

    _contentController.forward();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _bgController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  bool get _isSupabaseConfigured {
    try {
      Supabase.instance.client;
      return true;
    } catch (_) {
      return false;
    }
  }

  void _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        final repo = ref.read(authRepositoryProvider);
        final user = await repo.registerWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          fullName: _fullNameController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim().isNotEmpty
              ? _phoneNumberController.text.trim()
              : null,
          address: _addressController.text.trim().isNotEmpty
              ? _addressController.text.trim()
              : null,
        );

        if (mounted) {
          // Trigger immediate sign-in with the registered user state
          ref.read(authStateProvider.notifier).state = AuthState.authenticated(user);
          ref.read(currentUserProvider.notifier).setUser(user);
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful!'),
              backgroundColor: Color(0xFF4CAF88),
            ),
          );

          context.go('/home');
        }
      } on AuthException catch (e) {
        if (mounted) {
          String msg = e.message;
          if (e.message.toLowerCase().contains('confirm') || e.message.toLowerCase().contains('verification')) {
            msg = 'การสมัครสมาชิกสำเร็จ! โปรดตรวจสอบอีเมลเพื่อยืนยันตัวตนก่อนเข้าสู่ระบบ';
          } else if (e.message.contains('Email signup is disabled')) {
            msg = 'การสมัครสมาชิกถูกปิดใช้งานชั่วคราว (กรุณาตรวจสอบว่าเปิด "Allow new users to sign up" ใน Supabase Dashboard หรือยัง)';
          } else if (e.message.contains('User already registered')) {
            msg = 'อีเมลนี้ถูกใช้งานไปแล้วในระบบ กรุณาใช้อีเมลอื่นหรือเข้าสู่ระบบ';
          } else if (e.message.toLowerCase().contains('rate limit') || e.message.toLowerCase().contains('too many requests') || e.statusCode == '429') {
            msg = 'คุณส่งคำขอถี่เกินไปชั่วคราว (Rate Limit) กรุณารอ 1-2 นาที หรือเพิ่มขีดจำกัด Email Rate Limit ในหน้า Supabase Dashboard > Settings > Auth';
          } else {
            msg = 'การสมัครสมาชิกล้มเหลว: ${e.message}';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration failed: ${e.toString()}'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── Soft top gradient blob ──────────────────────────────
          Positioned(
            top: -60,
            left: -40,
            right: -40,
            child: AnimatedBuilder(
              animation: _bgController,
              builder: (_, __) {
                final t = _bgController.value * 2 * math.pi;
                return Transform.translate(
                  offset: Offset(6 * math.sin(t), 4 * math.cos(t)),
                  child: Container(
                    height: 320.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.18),
                          AppTheme.primaryColor.withOpacity(0.08),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(80.r),
                        bottomRight: Radius.circular(120.r),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ── Decorative circles ──────────────────────────────────
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 140.w,
              height: 140.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryColor.withOpacity(0.07),
              ),
            ),
          ),

          // ── Scrollable content ──────────────────────────────────
          SafeArea(
            child: SlideTransition(
              position: _contentSlide,
              child: FadeTransition(
                opacity: _contentFade,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 28.w,
                    vertical: 20.h,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),

                        // ── Logo ──────────────────────────────────
                        Center(
                          child: Container(
                            width: 72.w,
                            height: 72.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppTheme.primaryColor,
                                  AppTheme.primaryColor.withOpacity(0.7),
                                ],
                              ),
                            ),
                            child: Icon(
                              Icons.school_rounded,
                              size: 36.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // ── Heading ───────────────────────────────
                        Text(
                          'Create Account',
                          style: GoogleFonts.poppins(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.darkGrey,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Register to start your premium learning journey',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: AppTheme.mediumGrey,
                          ),
                        ),
                        SizedBox(height: 28.h),

                        // ── Full Name ─────────────────────────────
                        const _FieldLabel(label: 'Full Name'),
                        SizedBox(height: 6.h),
                        _StyledField(
                          controller: _fullNameController,
                          hint: 'Your Full Name',
                          prefixIcon: Icons.person_outline,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Full Name is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),

                        // ── Email ─────────────────────────────────
                        _FieldLabel(label: AppStrings.email),
                        SizedBox(height: 6.h),
                        _StyledField(
                          controller: _emailController,
                          hint: 'your@email.com',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: (v) {
                            if (v == null || v.isEmpty)
                              return AppStrings.fieldRequired;
                            if (!v.contains('@'))
                              return AppStrings.invalidEmail;
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),

                        // ── Phone Number (Optional) ───────────────
                        const _FieldLabel(label: 'Phone Number (Optional)'),
                        SizedBox(height: 6.h),
                        _StyledField(
                          controller: _phoneNumberController,
                          hint: '0812345678',
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone_outlined,
                        ),
                        SizedBox(height: 16.h),

                        // ── Address (Optional) ────────────────────
                        const _FieldLabel(label: 'Address (Optional)'),
                        SizedBox(height: 6.h),
                        _StyledField(
                          controller: _addressController,
                          hint: 'Your address',
                          prefixIcon: Icons.home_outlined,
                        ),
                        SizedBox(height: 16.h),

                        // ── Password ──────────────────────────────
                        _FieldLabel(label: AppStrings.password),
                        SizedBox(height: 6.h),
                        _StyledField(
                          controller: _passwordController,
                          hint: '••••••••',
                          obscureText: _obscurePassword,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20.sp,
                              color: AppTheme.mediumGrey,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty)
                              return AppStrings.fieldRequired;
                            if (v.length < 6)
                              return AppStrings.passwordTooShort;
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),

                        // ── Confirm Password ──────────────────────
                        const _FieldLabel(label: 'Confirm Password'),
                        SizedBox(height: 6.h),
                        _StyledField(
                          controller: _confirmPasswordController,
                          hint: '••••••••',
                          obscureText: _obscureConfirmPassword,
                          prefixIcon: Icons.lock_clock_outlined,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20.sp,
                              color: AppTheme.mediumGrey,
                            ),
                            onPressed: () => setState(
                              () => _obscureConfirmPassword = !_obscureConfirmPassword,
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty)
                              return AppStrings.fieldRequired;
                            if (v != _passwordController.text)
                              return 'Passwords do not match';
                            return null;
                          },
                        ),
                        SizedBox(height: 28.h),

                        // ── Register button ───────────────────────
                        _GradientButton(
                          text: AppStrings.signup,
                          isLoading: _isLoading,
                          onPressed: _handleRegister,
                        ),
                        SizedBox(height: 20.h),

                        // ── Login link ────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: GoogleFonts.inter(
                                color: AppTheme.mediumGrey,
                                fontSize: 14.sp,
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.go('/auth/login'),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 6.w),
                              ),
                              child: Text(
                                AppStrings.login,
                                style: GoogleFonts.inter(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 36.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reusable sub-widgets ───────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: AppTheme.darkGrey,
        letterSpacing: 0.2,
      ),
    );
  }
}

class _StyledField extends StatelessWidget {
  const _StyledField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: GoogleFonts.inter(fontSize: 15.sp, color: AppTheme.darkGrey),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          fontSize: 14.sp,
          color: Colors.grey.shade400,
        ),
        prefixIcon: Icon(prefixIcon, size: 20.sp, color: AppTheme.mediumGrey),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: AppTheme.primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.text,
    required this.isLoading,
    required this.onPressed,
  });

  final String text;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryColor,
              AppTheme.primaryColor.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  width: 22.w,
                  height: 22.w,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
        ),
      ),
    );
  }
}
