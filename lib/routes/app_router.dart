import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/domain/providers/auth_provider.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/courses/presentation/screens/course_list_screen.dart';
import '../features/courses/presentation/screens/course_detail_screen.dart';
import '../features/booking/presentation/screens/booking_screen.dart';
import '../features/booking/presentation/screens/booking_success_screen.dart';
import '../features/payments/presentation/screens/payment_screen.dart';
import '../features/schedule/presentation/screens/schedule_screen.dart';
import '../features/learning/presentation/screens/learning_screen.dart';
import '../features/learning/presentation/screens/course_player_screen.dart';
import '../features/notifications/presentation/screens/notifications_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = authState.maybeMap(
        authenticated: (_) => true,
        orElse: () => false,
      );
      final isAuthRoute = state.fullPath?.startsWith('/auth/') ?? false;

      if (!isAuthenticated && !isAuthRoute) {
        return '/auth/splash_screen';
      }
      
      if (isAuthenticated && isAuthRoute) {
        return '/home';
      }

      return null;
    },
    routes: [
      // Root redirect to avoid missing route for '/'
      GoRoute(
        path: '/',
        redirect: (context, state) {
          final isAuthenticated = authState.maybeMap(
            authenticated: (_) => true,
            orElse: () => false,
          );
          return isAuthenticated ? '/home' : '/auth/splash_screen';
        },
      ),
      // Splash Screen
      GoRoute(
        path: '/auth/splash_screen',
        builder: (context, state) => const SplashScreen(),
      ),
      // Login Screen
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      // Register Screen
      GoRoute(
        path: '/auth/register',
        builder: (context, state) => Scaffold(
          body: Center(child: Text('Register Screen')),
        ),
      ),
      // Home Screen
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          // Courses
          GoRoute(
            path: 'courses',
            builder: (context, state) => const CourseListScreen(),
            routes: [
              GoRoute(
                path: ':courseId',
                builder: (context, state) {
                  final courseId = state.pathParameters['courseId']!;
                  return CourseDetailScreen(courseId: courseId);
                },
              ),
            ],
          ),
          // Booking
          GoRoute(
            path: 'booking/:courseId',
            builder: (context, state) {
              final courseId = state.pathParameters['courseId']!;
              return BookingScreen(courseId: courseId);
            },
            routes: [
              GoRoute(
                path: 'payment',
                builder: (context, state) {
                  final courseId = state.pathParameters['courseId']!;
                  final extra = state.extra as Map<String, dynamic>?;
                  return PaymentScreen(
                    courseId: courseId,
                    bookingExtras: extra,
                  );
                },
              ),
              GoRoute(
                path: 'success',
                builder: (context, state) {
                  final courseId = state.pathParameters['courseId']!;
                  final extra = state.extra as Map<String, dynamic>?;
                  return BookingSuccessScreen(courseId: courseId, payload: extra);
                },
              ),
            ],
          ),
          // Schedule
          GoRoute(
            path: 'schedule',
            builder: (context, state) => const ScheduleScreen(),
          ),
          // Learning — My Learning tab
          GoRoute(
            path: 'learning',
            builder: (context, state) => const LearningScreen(),
            routes: [
              // Course Player (Start/Continue Learning)
              GoRoute(
                path: ':courseId',
                builder: (context, state) {
                  final courseId = state.pathParameters['courseId']!;
                  return CoursePlayerScreen(courseId: courseId);
                },
                routes: [
                  // Direct video link (resume to specific lesson)
                  GoRoute(
                    path: 'video/:videoId',
                    builder: (context, state) {
                      final courseId = state.pathParameters['courseId']!;
                      final videoId = state.pathParameters['videoId']!;
                      return CoursePlayerScreen(
                        courseId: courseId,
                        initialVideoId: videoId,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          // Notifications
          GoRoute(
            path: 'notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          // Profile
          GoRoute(
            path: 'profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'settings',
                builder: (context, state) => Scaffold(
                  body: Center(child: Text('Settings Screen')),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
