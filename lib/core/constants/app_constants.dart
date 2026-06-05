class AppConstants {
  // App Information
  static const String appName = 'LearnHub';
  static const String appVersion = '1.0.0';

  // Supabase Configuration (local dev)
  static const String supabaseUrl = 'https://pxwoxdbfjwfzxmmvrquh.supabase.co';
  // Local publishable anon key from `supabase start` (development only)
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB4d294ZGJmandmenhtbXZycXVoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA0NTUxODAsImV4cCI6MjA5NjAzMTE4MH0.IvFqdPF6maXm1FKu1SYW_ujY5_aBUACP2rXDGNc0Jzg';

  // Firebase Configuration
  static const String firebaseProjectId = 'your-firebase-project';

  // API Endpoints
  static const String baseUrl = '$supabaseUrl/rest/v1';

  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  // Pagination
  static const int pageSize = 20;

  // Cache Duration
  static const Duration cacheDuration = Duration(hours: 1);

  // Date Format
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String timeFormat = 'HH:mm';
}
