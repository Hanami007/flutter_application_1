# LearnHub - Quick Setup Guide

Get LearnHub running in 5 minutes!

## ⚡ Quick Start (No Backend)

### 1. Install Dependencies
```bash
cd flutter_application_1
flutter pub get
```

### 2. Generate Code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Run the App
```bash
flutter run
```

**Done!** The app will run with mock data and UI-only functionality.

## 🔌 Add Backend Integration (Optional)

### Step 1: Create Supabase Account
1. Go to [supabase.com](https://supabase.com)
2. Create a new project
3. Copy your Project URL and Anon Key

### Step 2: Update Configuration
Edit `lib/core/constants/app_constants.dart`:
```dart
static const String supabaseUrl = 'YOUR_URL_HERE';
static const String supabaseAnonKey = 'YOUR_KEY_HERE';
```

### Step 3: Setup Database
1. Go to SQL Editor in Supabase
2. Copy content from `database_schema.sql`
3. Paste and execute

### Step 4: Initialize Supabase in main.dart
```dart
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'YOUR_URL',
    anonKey: 'YOUR_KEY',
  );
  
  runApp(const ProviderScope(child: MyApp()));
}
```

## 📱 Testing the App

### Navigate Through Screens
- **Splash** → Starts the app
- **Login** → Mock credentials work (implement real auth)
- **Home** → Shows mock courses and categories
- **Course List** → Browse courses
- **Booking** → Multi-step booking flow
- **Profile** → User settings

### Test Data
Currently using mock data. To use real data:
1. Implement repositories (see IMPLEMENTATION_GUIDE.md)
2. Connect Supabase queries
3. Run tests with real data

## 🎨 Customization

### Change Primary Color
`lib/core/theme/app_theme.dart`:
```dart
static const primaryColor = Color(0xFF4F46E5);  // Change this
```

### Change App Name
`pubspec.yaml`:
```yaml
name: learn_hub  # Change to your app name
```

### Change Fonts
Add fonts to `pubspec.yaml` and update theme.

## 📁 Project Structure at a Glance

```
lib/
├── core/          → Theme & constants
├── shared/        → Widgets & utilities
├── features/      → 8 app features
├── routes/        → Navigation
└── main.dart      → Entry point

docs/
├── LEARNHUB_README.md         → Full documentation
├── IMPLEMENTATION_GUIDE.md    → Backend setup
└── PROJECT_COMPLETION_SUMMARY.md → What's done
```

## 🚀 Common Tasks

### Add a New Screen
1. Create file in `lib/features/[feature]/presentation/screens/`
2. Add route to `lib/routes/app_router.dart`
3. Update navigation if needed

### Add a New Provider
1. Create in `lib/features/[feature]/domain/providers/`
2. Use `FutureProvider`, `StateProvider`, etc.
3. Use with `ref.watch()` in widgets

### Add New API Endpoint
1. Create repository in `lib/features/[feature]/data/repositories/`
2. Create provider that uses repository
3. Watch provider in widget

### Add New Theme Color
Edit `lib/core/theme/app_theme.dart`:
```dart
static const String myColor = Color(0xFF..);
// Use as AppTheme.myColor
```

## 🐛 Troubleshooting

### App won't build
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Supabase connection fails
- Check URL and API key
- Verify network connection
- Check Supabase project status

### Code generation issues
```bash
flutter pub run build_runner clean
flutter pub run build_runner build
```

## 📚 Documentation

| Document | Purpose |
|----------|---------|
| LEARNHUB_README.md | Complete feature documentation |
| IMPLEMENTATION_GUIDE.md | Backend & API integration |
| PROJECT_COMPLETION_SUMMARY.md | What's done & pending |
| database_schema.sql | Database setup |

## 🎯 Next Steps

1. ✅ Run the app with `flutter run`
2. ⏳ Explore the UI and navigate screens
3. ⏳ Follow IMPLEMENTATION_GUIDE.md for backend
4. ⏳ Add your Supabase configuration
5. ⏳ Test with real data

## 💡 Tips

- Use `flutter run -v` for verbose output
- Use `flutter devices` to see connected devices
- Use DevTools: `flutter pub global run devtools`
- Check all TODOs in code: `grep -r "TODO" lib/`

## ✨ Features to Explore

- **Responsive Design**: Try on different screen sizes
- **Modern UI**: Check theme colors and animations
- **Smart Navigation**: Use bottom nav to navigate between screens
- **Form Validation**: Try invalid inputs on login
- **List Items**: Scroll through courses and notifications

## 📞 Need Help?

1. Check LEARNHUB_README.md for comprehensive docs
2. See IMPLEMENTATION_GUIDE.md for technical details
3. Review code comments in key files
4. Check Flutter documentation at flutter.dev

---

**Happy Coding! 🚀**

Next: Run `flutter run` and explore LearnHub!
