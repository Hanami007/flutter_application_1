import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO: Initialize Firebase
  
  // Safe Supabase initialization
  try {
    final configured = AppConstants.supabaseUrl.isNotEmpty &&
        !AppConstants.supabaseUrl.contains('your-project') &&
        AppConstants.supabaseAnonKey.isNotEmpty &&
        !AppConstants.supabaseAnonKey.contains('your-anon-key');


    if (configured) {
      await Supabase.initialize(
        url: AppConstants.supabaseUrl,
        anonKey: AppConstants.supabaseAnonKey,
      );
      debugPrint('Supabase initialized successfully!');
    } else {
      debugPrint('Supabase not configured — running in Mock Mode.');
    }
  } catch (e, st) {
    debugPrint('Supabase initialization failed: $e');
    debugPrint('$st');
    debugPrint('Running in Mock Mode.');
  }
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'LearnHub',
          theme: AppTheme.lightTheme,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return child ?? const SizedBox();
          },
        );
      },
    );
  }
}
