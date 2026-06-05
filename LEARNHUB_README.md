# LearnHub - Flutter Learning & Course Booking App

A production-ready Flutter application for online and onsite course booking, learning management, and payments. Built with modern Flutter best practices using Riverpod, Clean Architecture, and Supabase.

## Features

### 🎓 Core Features
- **Browse Courses**: Discover courses by categories with ratings and reviews
- **Book Classes**: Book onsite classes at physical locations or join online classes
- **Payment Integration**: Secure payment processing with Razorpay
- **Schedule Management**: Calendar view of all bookings and classes
- **Learning Progress**: Track course progress and completed lessons
- **Video Playback**: Watch recorded lessons with Chewie player
- **Notifications**: Real-time notifications for class reminders and bookings
- **User Profiles**: Manage personal information and preferences

### 📱 Screens Included
1. **Splash Screen** - App initialization
2. **Login/Register** - Email and Google authentication
3. **Home Screen** - Dashboard with courses, categories, and upcoming classes
4. **Course List** - Browse all available courses with filters
5. **Course Detail** - Detailed course information and curriculum
6. **Booking Flow** - Multi-step booking process (Branch → Date/Time → Payment)
7. **Payment** - Payment method selection and processing
8. **Booking Success** - Confirmation screen with booking details
9. **Schedule** - Calendar view of bookings and classes
10. **Learning** - Track progress across enrolled courses
11. **Video Player** - Watch recorded lessons
12. **Notifications** - View all notifications and updates
13. **Profile** - User profile and settings
14. **Settings** - App preferences and configuration

## Tech Stack

### Frontend
- **Flutter 3.x** - UI framework
- **Riverpod** - State management
- **Go Router** - Navigation
- **Freezed** - Data class generation
- **Dio** - HTTP client
- **Flutter ScreenUtil** - Responsive design

### Backend
- **Supabase** - Backend-as-a-Service
- **PostgreSQL** - Database
- **Supabase Auth** - Authentication
- **Supabase Storage** - File storage

### Additional Services
- **Firebase Cloud Messaging** - Push notifications
- **Razorpay** - Payment processing
- **Google Sign-In** - Social authentication

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   │   └── app_theme.dart          # Theme configuration
│   └── utils/
├── shared/
│   ├── constants/
│   │   ├── app_constants.dart      # App configuration
│   │   └── app_strings.dart        # UI strings
│   ├── models/
│   │   ├── api_response.dart
│   │   └── exceptions.dart
│   ├── utils/
│   │   └── extensions.dart         # Helper extensions
│   └── widgets/
│       └── common_widgets.dart     # Reusable widgets
├── features/
│   ├── auth/
│   │   ├── data/                   # Data layer
│   │   ├── domain/                 # Domain entities & providers
│   │   └── presentation/           # UI screens
│   ├── home/
│   ├── courses/
│   ├── booking/
│   ├── learning/
│   ├── schedule/
│   ├── notifications/
│   ├── profile/
│   └── payments/
├── routes/
│   └── app_router.dart             # Navigation configuration
└── main.dart                        # App entry point
```

## Getting Started

### Prerequisites
- Flutter 3.x installed
- Dart 3.x
- iOS 14+ / Android 5+
- Supabase account
- Firebase project
- Razorpay account

### Installation

1. **Clone the repository**
```bash
git clone <repo-url>
cd flutter_application_1
```

2. **Get dependencies**
```bash
flutter pub get
```

3. **Configure Supabase**
   - Update `lib/core/constants/app_constants.dart` with your Supabase URL and anon key
   - Run the SQL schema from `database_schema.sql` in your Supabase dashboard

4. **Configure Firebase**
   - Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Update Firebase configuration in the app

5. **Configure Razorpay**
   - Add your Razorpay API keys to environment variables

6. **Generate code**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

7. **Run the app**
```bash
flutter run
```

## Database Schema

The application includes a comprehensive PostgreSQL schema with the following tables:

- **users** - User accounts and profiles
- **courses** - Course information
- **categories** - Course categories
- **branches** - Physical class locations
- **teachers** - Teacher profiles
- **class_sessions** - Online and onsite class sessions
- **bookings** - Course bookings
- **payments** - Payment records
- **videos** - Video lessons
- **documents** - Course documents
- **quizzes** - Quizzes and assessments
- **notifications** - User notifications
- **ratings** - Course ratings and reviews

See `database_schema.sql` for complete schema definition.

## Architecture

### Clean Architecture Pattern
```
Presentation Layer (UI Screens)
    ↓
Domain Layer (Entities, Use Cases, Providers)
    ↓
Data Layer (Repositories, Models, API/Local Storage)
```

### State Management with Riverpod
- **StateProvider** - Simple state values
- **FutureProvider** - Async data fetching
- **StateNotifierProvider** - Complex state logic
- **Provider** - Computed/derived state

Example:
```dart
// Providers
final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, User?>((ref) {
  return CurrentUserNotifier();
});

final allCoursesProvider = FutureProvider<List<Course>>((ref) async {
  final repository = ref.watch(courseRepositoryProvider);
  return repository.getAllCourses();
});
```

## Implementation Guide

### For Developers

1. **Implementing API Integration**
   - Create data models in `features/[feature]/data/models/`
   - Create repositories in `features/[feature]/data/repositories/`
   - Update providers to fetch real data

2. **Adding New Screens**
   - Create screen in `features/[feature]/presentation/screens/`
   - Add route in `lib/routes/app_router.dart`
   - Create necessary providers and models

3. **Customizing Theme**
   - Update colors in `lib/core/theme/app_theme.dart`
   - Modify text styles and spacing constants
   - Theme applies globally to entire app

4. **Building Forms**
   - Use `TextInputField` widget from `common_widgets.dart`
   - Add validation logic in `validator` parameter
   - Use Riverpod providers to manage form state

### Firebase Setup

1. **Configure FCM**
```dart
// In main.dart
await Firebase.initializeApp();
await FirebaseMessaging.instance.requestPermission();

// Listen for messages
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  // Handle foreground messages
});
```

2. **Handle Notifications**
```dart
// Use the notification service to show local notifications
// Integrate with FCM for push notifications
```

### Supabase Integration

1. **Authentication**
```dart
// Email login
final user = await supabase.auth.signInWithPassword(
  email: email,
  password: password,
);

// Google login
final user = await supabase.auth.signInWithOAuth(
  provider: OAuthProvider.google,
);
```

2. **Data Operations**
```dart
// Fetch courses
final courses = await supabase
    .from('courses')
    .select()
    .eq('category_id', categoryId);

// Create booking
await supabase
    .from('bookings')
    .insert({
      'user_id': userId,
      'class_session_id': sessionId,
    });
```

### Payment Integration (Razorpay)

```dart
// Initialize Razorpay
Razorpay _razorpay = Razorpay();

// Create order
Future<void> processPayment(double amount) async {
  var options = {
    'key': 'YOUR_RAZORPAY_KEY',
    'amount': (amount * 100).toInt(),
    'name': 'LearnHub',
    'description': 'Course Booking Payment',
    'prefill': {
      'email': userEmail,
      'contact': userPhone,
    }
  };

  _razorpay.open(options);
}
```

## Customization

### Colors
Edit `lib/core/theme/app_theme.dart`:
```dart
static const primaryColor = Color(0xFF4F46E5);      // Indigo
static const secondaryColor = Color(0xFF06B6D4);    // Cyan
static const backgroundColor = Color(0xFFF8FAFC);   // Light Gray
```

### Fonts
Add your custom fonts in `pubspec.yaml` and use in theme configuration.

### Spacing & Radius
Modify constants in `AppTheme` class to adjust layout.

## Performance Optimization

1. **Image Caching**
   - Use `cached_network_image` for course thumbnails
   - Set cache duration in constants

2. **Pagination**
   - Implement with `infinite_scroll_pagination`
   - Load 20 items per page (configurable)

3. **State Persistence**
   - Use `shared_preferences` for user preferences
   - Cache course data locally

4. **Code Generation**
   - Run build_runner for Freezed classes
   - Use code generation for serialization

## Testing

### Unit Tests
```bash
flutter test test/unit_tests/
```

### Widget Tests
```bash
flutter test test/widget_tests/
```

### Integration Tests
```bash
flutter test integration_test/
```

## Deployment

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Known Issues & Limitations

1. **Video Streaming** - Requires proper CORS configuration on Supabase Storage
2. **Notifications** - FCM requires additional configuration for each platform
3. **Payment** - Test mode available in Razorpay dashboard
4. **Offline Support** - Basic offline support via local caching

## Future Enhancements

- [ ] Offline mode with sync
- [ ] Live class video streaming
- [ ] Discussion forum
- [ ] Certificate generation
- [ ] Advanced analytics dashboard
- [ ] Gamification (badges, leaderboards)
- [ ] Referral program
- [ ] Multi-language support

## Contributing

1. Create a feature branch (`git checkout -b feature/amazing-feature`)
2. Commit changes (`git commit -m 'Add amazing feature'`)
3. Push to branch (`git push origin feature/amazing-feature`)
4. Open a Pull Request

## License

This project is licensed under the MIT License - see LICENSE file for details.

## Support

For issues, feature requests, or questions:
- Email: support@learnhub.com
- Documentation: https://docs.learnhub.com

## Changelog

### Version 1.0.0 (Current)
- Initial release with core features
- Authentication (Email & Google)
- Course browsing and booking
- Payment integration
- Schedule management
- Learning tracking

---

**Built with ❤️ using Flutter**
