import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/constants/app_strings.dart';
import '../../../../shared/widgets/common_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/domain/providers/auth_provider.dart';
import '../../../auth/domain/entities/user.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    const textDarkColor = Color(0xFF1A1F36);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(
          AppStrings.profile,
          style: GoogleFonts.notoSansThai(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: textDarkColor,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 16.h),

            // Profile Header Widget
            _buildProfileHeader(context, currentUser),

            SizedBox(height: 20.h),

            // Stats Dashboard Card
            _buildStatsCard(),

            SizedBox(height: 24.h),

            // Account Section
            _buildMenuSection(
              context,
              'บัญชีผู้ใช้งาน',
              [
                _buildMenuItem(
                  'คอร์สเรียนของฉัน (My Learning)',
                  Icons.school_rounded,
                  () => context.go('/home/learning'),
                  isLast: true,
                ),
              ],
            ),

            // App Settings Section
            _buildMenuSection(
              context,
              'แอปพลิเคชัน',
              [
                _buildMenuItem(
                  AppStrings.helpSupport,
                  Icons.help_rounded,
                  () {},
                  isLast: true,
                ),
              ],
            ),

            // Legal Section
            _buildMenuSection(
              context,
              'ข้อตกลงและนโยบาย',
              [
                _buildMenuItem(
                  AppStrings.privacyPolicy,
                  Icons.privacy_tip_rounded,
                  () {},
                ),
                _buildMenuItem(
                  AppStrings.termsConditions,
                  Icons.description_rounded,
                  () {},
                  isLast: true,
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Logout Button
            _buildLogoutButton(context, ref),

            // Version info
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text(
                'Lumina Learn v1.0.0',
                style: GoogleFonts.poppins(
                  fontSize: 11.sp,
                  color: const Color(0xFFA0AEC0),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, User? currentUser) {
    const textDarkColor = Color(0xFF1A1F36);
    const textMidColor = Color(0xFF6E7A9A);
    const brandTeal = Color(0xFF2DC9A8);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Container(
            width: 88.w,
            height: 88.w,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: brandTeal, width: 2),
            ),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE6F9F5),
              ),
              child: Icon(
                Icons.person_rounded,
                size: 42.sp,
                color: brandTeal,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            currentUser?.fullName ?? 'ผู้ใช้งานทั่วไป',
            style: GoogleFonts.notoSansThai(
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
              color: textDarkColor,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            currentUser?.email ?? 'ยังไม่ได้ลงทะเบียนอีเมล',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: textMidColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.h),
          OutlineButton(
            text: AppStrings.editProfile,
            borderColor: brandTeal,
            textColor: brandTeal,
            onPressed: () {
              // TODO: Implement edit profile
            },
            width: 130.w,
            height: 34.h,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFEDF2F7), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('5', 'คอร์สเรียน', Icons.school_rounded, const Color(0xFFAB94F0)),
          _buildDivider(),
          _buildStatItem('12', 'การจองคลาส', Icons.event_note_rounded, const Color(0xFFFF9F50)),
          _buildDivider(),
          _buildStatItem('3.8', 'คะแนนผู้ใช้', Icons.star_rounded, const Color(0xFF2DC9A8)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon, Color iconColor) {
    const textDarkColor = Color(0xFF1A1F36);
    const textMidColor = Color(0xFF6E7A9A);

    return Expanded(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 16.sp),
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: textDarkColor,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: GoogleFonts.notoSansThai(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: textMidColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40.h,
      color: const Color(0xFFEDF2F7),
    );
  }

  Widget _buildMenuSection(
    BuildContext context,
    String title,
    List<Widget> items,
  ) {
    const textMid = Color(0xFF6E7A9A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 12.h, bottom: 8.h),
          child: Text(
            title,
            style: GoogleFonts.notoSansThai(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: textMid,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: Colors.white,
            border: Border.all(color: const Color(0xFFEDF2F7), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap, {bool isLast = false}) {
    const textDark = Color(0xFF1A1F36);
    const textMid = Color(0xFF6E7A9A);
    const brandTeal = Color(0xFF2DC9A8);
    const brandTealLight = Color(0xFFE6F9F5);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(color: Color(0xFFEDF2F7), width: 1),
                ),
        ),
        child: Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: const BoxDecoration(
                color: brandTealLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: brandTeal, size: 16.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.notoSansThai(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w600,
                  color: textDark,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: textMid.withValues(alpha: 0.4),
              size: 13.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: TextButton.icon(
        icon: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 16),
        label: Text(
          'ออกจากระบบ',
          style: GoogleFonts.notoSansThai(
            fontSize: 13.5.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFEF4444),
          ),
        ),
        onPressed: () async {
          try {
            final authRepo = ref.read(authRepositoryProvider);
            await authRepo.logout();
          } catch (_) {}

          ref.read(authStateProvider.notifier).state = AuthState.unauthenticated();
          ref.read(currentUserProvider.notifier).clearUser();

          if (context.mounted) {
            context.go('/auth/login');
          }
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          backgroundColor: const Color(0xFFFEE2E2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          minimumSize: Size(double.infinity, 44.h),
        ),
      ),
    );
  }
}
