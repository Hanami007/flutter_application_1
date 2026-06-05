# LearnHub Implementation Guide & Next Steps

This document outlines the remaining implementation steps to complete the LearnHub application and connect real backend services.

## 🚀 Quick Start Checklist

- [ ] Configure Supabase project
- [ ] Set up Firebase project
- [ ] Implement authentication
- [ ] Connect API endpoints
- [ ] Integrate payment gateway
- [ ] Set up notifications
- [ ] Add video streaming
- [ ] Test all flows

## Phase 1: Backend Configuration (Week 1)

### 1.1 Supabase Setup

**Steps:**
1. Create Supabase project at https://supabase.com
2. Copy project URL and anon key
3. Update `lib/core/constants/app_constants.dart`:
```dart
static const String supabaseUrl = 'https://your-project.supabase.co';
static const String supabaseAnonKey = 'your-anon-key-here';
```

4. Run the database schema:
   - Go to SQL Editor in Supabase
   - Copy content from `database_schema.sql`
   - Execute the SQL

5. Enable Row Level Security (RLS) policies:
   - Configure authentication policies
   - Set up access control

### 1.2 Firebase Setup

**Steps:**
1. Create Firebase project at https://console.firebase.google.com
2. Add iOS and Android apps
3. Download config files:
   - `google-services.json` → `android/app/`
   - `GoogleService-Info.plist` → `ios/Runner/`

4. Update `android/build.gradle`:
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}
```

5. Update `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'
```

## Phase 2: Authentication Implementation (Week 2)

### 2.1 Email/Password Authentication

**File: `lib/features/auth/data/repositories/auth_repository.dart`**

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final _supabase = Supabase.instance.client;

  Future<User> registerWithEmail(String email, String password) async {
    try {
      final response = await _supabase.auth.signUpWithPassword(
        email: email,
        password: password,
      );
      return response.user!;
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  Future<User> loginWithEmail(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user!;
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  Future<User?> getCurrentUser() async {
    return _supabase.auth.currentUser;
  }
}
```

### 2.2 Google Sign-In

**Dependencies:**
```yaml
google_sign_in: ^6.2.0
```

**Implementation:**
```dart
Future<User> loginWithGoogle() async {
  try {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) throw Exception('Google sign in cancelled');

    final response = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: googleUser.idToken ?? '',
      accessToken: googleUser.accessToken,
    );
    
    return response.user!;
  } catch (e) {
    throw AuthException(message: e.toString());
  }
}
```

### 2.3 Auth State Management

**File: `lib/features/auth/data/providers/auth_state_provider.dart`**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateProvider = StreamProvider<AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  
  return Supabase.instance.client.auth.onAuthStateChange.map((data) {
    final session = data.session;
    
    if (session != null) {
      return AuthState.authenticated(
        User(
          id: session.user.id,
          email: session.user.email ?? '',
        ),
      );
    }
    
    return const AuthState.unauthenticated();
  });
});
```

## Phase 3: API Integration (Week 3)

### 3.1 Course Repository Implementation

**File: `lib/features/courses/data/repositories/course_repository.dart`**

```dart
class CourseRepository {
  final _supabase = Supabase.instance.client;

  Future<List<Course>> getAllCourses() async {
    try {
      final response = await _supabase
          .from('courses')
          .select('''
            *,
            categories (id, name),
            teacher:teachers (id, user:users (full_name))
          ''')
          .order('created_at', ascending: false);

      return (response as List)
          .map((course) => Course.fromJson(course))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<List<Course>> getPopularCourses() async {
    try {
      final response = await _supabase
          .from('courses')
          .select('*')
          .order('total_students', ascending: false)
          .limit(10);

      return (response as List)
          .map((course) => Course.fromJson(course))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<Course> getCourseById(String courseId) async {
    try {
      final response = await _supabase
          .from('courses')
          .select('*')
          .eq('id', courseId)
          .single();

      return Course.fromJson(response);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
```

### 3.2 Dio HTTP Client Setup

**File: `lib/core/network/dio_client.dart`**

```dart
import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class DioClient {
  late Dio _dio;

  DioClient() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: Duration(milliseconds: AppConstants.connectTimeout),
      receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
      sendTimeout: Duration(milliseconds: AppConstants.sendTimeout),
    ))
    ..interceptors.add(LoggingInterceptor())
    ..interceptors.add(AuthInterceptor());
  }

  Future<Response> get(String path) => _dio.get(path);
  Future<Response> post(String path, {required data}) => _dio.post(path, data: data);
  Future<Response> put(String path, {required data}) => _dio.put(path, data: data);
  Future<Response> delete(String path) => _dio.delete(path);
}
```

## Phase 4: Payment Integration (Week 3)

### 4.1 Razorpay Setup

**File: `lib/features/payments/data/repositories/payment_repository.dart`**

```dart
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentRepository {
  final _razorpay = Razorpay();
  final _supabase = Supabase.instance.client;

  void initializeRazorpay() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  Future<void> processPayment({
    required String bookingId,
    required double amount,
    required String email,
    required String phone,
  }) async {
    var options = {
      'key': 'YOUR_RAZORPAY_KEY_ID',
      'amount': (amount * 100).toInt(),
      'name': 'LearnHub',
      'description': 'Course Booking Payment',
      'order_id': bookingId,
      'prefill': {
        'email': email,
        'contact': phone,
      },
      'notes': {
        'booking_id': bookingId,
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      throw PaymentException(message: e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Update payment status in database
    await _supabase.from('payments').update({
      'status': 'completed',
      'transaction_id': response.paymentId,
      'payment_date': DateTime.now().toIso8601String(),
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    throw PaymentException(message: response.message ?? 'Payment failed');
  }
}
```

## Phase 5: Notifications Setup (Week 4)

### 5.1 Firebase Cloud Messaging

**File: `lib/core/services/notification_service.dart`**

```dart
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initializeNotifications() async {
    // Request permission
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carplay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Get FCM token
    final token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundNotification(message);
    });

    // Listen to background messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message);
    });
  }

  void _handleForegroundNotification(RemoteMessage message) {
    // Show notification in app
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
  }

  void _handleNotificationTap(RemoteMessage message) {
    // Navigate based on notification type
    print('Notification tapped!');
  }
}
```

## Phase 6: Video Streaming Setup (Week 4)

### 6.1 Video Player Screen

**File: `lib/features/learning/presentation/screens/video_player_screen.dart`**

```dart
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String videoTitle;

  const VideoPlayerScreen({
    required this.videoUrl,
    required this.videoTitle,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: AppTheme.primaryColor,
        handleColor: AppTheme.primaryColor,
        backgroundColor: AppTheme.lightGrey,
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.videoTitle)),
      body: Chewie(controller: _chewieController),
    );
  }
}
```

## Phase 7: Testing & Refinement (Week 5)

### 7.1 Unit Tests

**File: `test/features/auth/data/repositories/auth_repository_test.dart`**

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthRepository', () {
    late AuthRepository authRepository;

    setUp(() {
      authRepository = AuthRepository();
    });

    test('loginWithEmail should return user on success', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';

      // Act
      final user = await authRepository.loginWithEmail(email, password);

      // Assert
      expect(user, isNotNull);
      expect(user.email, email);
    });

    test('loginWithEmail should throw exception on failure', () async {
      // Arrange
      const email = 'invalid@example.com';
      const password = 'wrong';

      // Act & Assert
      expect(
        () => authRepository.loginWithEmail(email, password),
        throwsA(isA<AuthException>()),
      );
    });
  });
}
```

## Deployment Checklist

### Pre-Deployment

- [ ] Update API keys and secrets in environment
- [ ] Configure Supabase RLS policies
- [ ] Set up Firebase deployment
- [ ] Test all payment flows
- [ ] Verify email notifications
- [ ] Test video streaming
- [ ] Build release APK/IPA

### Deployment

- [ ] Deploy to Google Play Store
- [ ] Deploy to Apple App Store
- [ ] Set up monitoring and analytics
- [ ] Configure error tracking (Sentry)
- [ ] Set up CI/CD pipeline

### Post-Deployment

- [ ] Monitor crash logs
- [ ] Collect user feedback
- [ ] Plan next features
- [ ] Schedule maintenance windows

## Common Issues & Solutions

### Issue 1: Supabase Connection Fails
**Solution:** 
- Verify URL and anon key in constants
- Check network connectivity
- Enable CORS in Supabase settings

### Issue 2: Payment Integration Not Working
**Solution:**
- Verify Razorpay API keys
- Check test mode is enabled
- Verify callback URLs

### Issue 3: Video Streaming Issues
**Solution:**
- Enable CORS on Supabase Storage
- Use proper video format (MP4)
- Check network bandwidth

## Performance Optimization Tips

1. **Image Optimization**
   - Compress images before upload
   - Use appropriate sizes
   - Implement lazy loading

2. **Database Queries**
   - Add indexes on frequently queried columns
   - Use pagination for large datasets
   - Cache frequently accessed data

3. **State Management**
   - Only watch necessary providers
   - Use `select` for computed values
   - Avoid unnecessary rebuilds

## Resources & Documentation

- [Flutter Docs](https://flutter.dev/docs)
- [Supabase Docs](https://supabase.com/docs)
- [Riverpod Docs](https://riverpod.dev)
- [Firebase Docs](https://firebase.google.com/docs)
- [Razorpay Docs](https://razorpay.com/docs/)

## Support

For technical issues or questions:
1. Check the documentation
2. Search GitHub issues
3. Create a new issue with details
4. Contact support team

---

**Happy Coding! 🚀**
