import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/constants/app_strings.dart';
import '../../../../shared/widgets/common_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/domain/providers/auth_provider.dart';
import '../../../auth/domain/entities/user.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(AppStrings.profile),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Padding(
              padding: EdgeInsets.all(AppTheme.spacingMd),
              child: Column(
                children: [
                  Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryColor,
                    ),
                    child: Icon(Icons.person, size: 50.sp, color: Colors.white),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'John Doe',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'john@example.com',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 16.h),
                  OutlineButton(
                    text: AppStrings.editProfile,
                    onPressed: () {
                      // TODO: Implement edit profile
                    },
                    width: 150.w,
                  ),
                ],
              ),
            ),

            // Stats
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard('5', 'Courses'),
                  _buildStatCard('12', 'Bookings'),
                  _buildStatCard('3.8', 'Rating'),
                ],
              ),
            ),

            SizedBox(height: 32.h),

            // Menu Items
            _buildMenuSection(
              context,
              'Account',
              [
                _buildMenuItem(
                  'My Learning',
                  Icons.school,
                  () => context.go('/home/learning'),
                ),
                _buildMenuItem(
                  AppStrings.changePassword,
                  Icons.lock,
                  () {},
                ),
                _buildMenuItem(
                  'Payment Methods',
                  Icons.payment,
                  () {},
                ),
              ],
            ),

            _buildMenuSection(
              context,
              'App',
              [
                _buildMenuItem(
                  AppStrings.settings,
                  Icons.settings,
                  () => context.go('/home/profile/settings'),
                ),
                _buildMenuItem(
                  AppStrings.helpSupport,
                  Icons.help,
                  () {},
                ),
                _buildMenuItem(
                  AppStrings.about,
                  Icons.info,
                  () {},
                ),
              ],
            ),

            _buildMenuSection(
              context,
              'Legal',
              [
                _buildMenuItem(
                  AppStrings.privacyPolicy,
                  Icons.description,
                  () {},
                ),
                _buildMenuItem(
                  AppStrings.termsConditions,
                  Icons.description,
                  () {},
                ),
              ],
            ),

            SizedBox(height: 32.h),

            // Logout Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
                child: PrimaryButton(
                  text: AppStrings.signout,
                  backgroundColor: AppTheme.errorColor,
                  onPressed: () async {
                    // Attempt repository logout (if implemented)
                    try {
                      final authRepo = ref.read(authRepositoryProvider);
                      await authRepo.logout();
                    } catch (_) {}

                    // Clear auth state and current user
                    ref.read(authStateProvider.notifier).state = AuthState.unauthenticated();
                    ref.read(currentUserProvider.notifier).clearUser();

                    // Navigate to login
                    context.go('/auth/login');
                  },
                ),
            ),

            SizedBox(height: 24.h),

            // Version
            Padding(
              padding: EdgeInsets.all(AppTheme.spacingMd),
              child: Text(
                'Version 1.0.0',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.mediumGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(
    BuildContext context,
    String title,
    List<Widget> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: 12.h,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.mediumGrey,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            color: AppTheme.surfaceColor,
            boxShadow: AppTheme.softShadow,
          ),
          child: Column(children: items),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: 12.h,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppTheme.lightGrey),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.primaryColor, size: 20.sp),
                SizedBox(width: 12.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.darkGrey,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: AppTheme.mediumGrey,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}
