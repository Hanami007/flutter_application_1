import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_core;
import '../../domain/entities/booking.dart';
import 'package:learn_hub/features/courses/data/mock_course_data.dart';
import '../../../../core/constants/app_constants.dart';

// Booking Repository Provider
final bookingRepositoryProvider = Provider((ref) {
  return BookingRepository();
});

// User Bookings Provider
final userBookingsProvider = FutureProvider.family<List<Booking>, String>((ref, userId) async {
  final repository = ref.watch(bookingRepositoryProvider);
  return repository.getUserBookings(userId);
});

// Class Sessions Provider
final classSessionsProvider = FutureProvider.family<List<ClassSession>, String>((ref, courseId) async {
  final repository = ref.watch(bookingRepositoryProvider);
  return repository.getClassSessions(courseId);
});

// Branches Provider
final branchesProvider = FutureProvider<List<Branch>>((ref) async {
  final repository = ref.watch(bookingRepositoryProvider);
  return repository.getBranches();
});

// Create Booking Provider
final createBookingProvider = FutureProvider.family<Booking, BookingRequest>((ref, request) async {
  final repository = ref.watch(bookingRepositoryProvider);
  return repository.createBooking(request);
});

class BookingRequest {
  final String userId;
  final String courseId;
  final String? branchId;
  final String? dateIso;
  final String? time;

  BookingRequest({
    required this.userId,
    required this.courseId,
    this.branchId,
    this.dateIso,
    this.time,
  });
}

class BookingRepository {
  bool get _isSupabaseActive {
    try {
      final client = supabase_core.Supabase.instance.client;
      final configured = AppConstants.supabaseUrl.isNotEmpty &&
          !AppConstants.supabaseUrl.contains('https://pxwoxdbfjwfzxmmvrquh.supabase.co') &&
          AppConstants.supabaseAnonKey.isNotEmpty &&
          !AppConstants.supabaseAnonKey.contains('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB4d294ZGJmandmenhtaXZycXVoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk3NjAwMTcsImV4cCI6MjA2NTM0MDAxN30.M2qN-g6b400F7f-BvS-1437t0m99XJ_Yy7K0K5KqN6k');
      if (!configured) return false;
      // Require an active authenticated session — without it, RLS will reject
      // all writes/reads and return 401 Unauthorized.
      return client.auth.currentSession != null;
    } catch (_) {
      return false;
    }
  }

  Map<String, dynamic> _mapBookingDbToModel(Map<String, dynamic> dbJson) {
    return {
      'id': dbJson['id']?.toString() ?? '',
      'userId': dbJson['user_id']?.toString() ?? dbJson['userId']?.toString() ?? '',
      'classSessionId': dbJson['class_session_id']?.toString() ?? dbJson['classSessionId']?.toString() ?? '',
      'status': dbJson['status'] ?? 'confirmed',
      'attendanceStatus': dbJson['attendance_status'] ?? dbJson['attendanceStatus'],
      'bookingDate': dbJson['booking_date'] ?? dbJson['bookingDate'],
      'createdAt': dbJson['created_at'] ?? dbJson['createdAt'],
      'updatedAt': dbJson['updated_at'] ?? dbJson['updatedAt'],
    };
  }
  // In-memory mock store for bookings (demo only)
  final List<Booking> _bookings = [];

  Future<List<Booking>> getUserBookings(String userId) async {
    if (_isSupabaseActive) {
      try {
        final resp = await supabase_core.Supabase.instance.client
            .from('bookings')
            .select()
            .eq('user_id', userId);
        final list = (resp as List)
            .map((e) => Booking.fromJson(_mapBookingDbToModel(Map<String, dynamic>.from(e as Map))))
            .toList();
        // If Supabase returned no rows but we have in-memory bookings (created as fallback),
        // include them so the UI reflects bookings made during this session.
        if (list.isEmpty) {
          final local = _bookings.where((b) => b.userId == userId).toList();
          if (local.isNotEmpty) return local;
        }
        return list;
      } catch (e) {
        debugPrint('getUserBookings supabase error: $e');
        // fallback to mock
      }
    }
    await Future.delayed(const Duration(milliseconds: 150));
    return _bookings.where((b) => b.userId == userId).toList();
  }

  Future<List<ClassSession>> getClassSessions(String courseId) async {
    if (_isSupabaseActive) {
      try {
        final resp = await supabase_core.Supabase.instance.client
            .from('class_sessions')
            .select()
            .eq('course_id', courseId);
        return (resp as List)
            .map((e) => ClassSession.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      } catch (e) {
        debugPrint('getClassSessions supabase error: $e');
        // fallback to mock
      }
    }
    await Future.delayed(const Duration(milliseconds: 150));
    return MockCourseData.mockClassSessions
        .where((s) => s.courseId == courseId)
        .toList();
  }

  Future<List<Branch>> getBranches() async {
    if (_isSupabaseActive) {
      try {
        final resp = await supabase_core.Supabase.instance.client
            .from('branches')
            .select();
        return (resp as List)
            .map((e) => Branch.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      } catch (e) {
        debugPrint('getBranches supabase error: $e');
        // fallback
      }
    }
    await Future.delayed(const Duration(milliseconds: 150));
    return MockCourseData.mockBranches;
  }

  Future<Booking> createBooking(BookingRequest request) async {
    if (_isSupabaseActive) {
      try {
        final client = supabase_core.Supabase.instance.client;

        // Debug: print auth state and request payloads to help diagnose DB failures
        try {
          debugPrint('Supabase current user: ${client.auth.currentUser}');
        } catch (_) {}


        // If no class session id provided, create a class session for this booking
        String classSessionId;
        if (request.dateIso != null) {
          // create a simple class_session with provided date/time
          final start = DateTime.parse(request.dateIso!);
          final payloadSession = {
            'course_id': request.courseId,
            'branch_id': request.branchId,
            'teacher_id': null,
            'session_type': request.branchId != null ? 'onsite' : 'online',
            'start_time': start.toIso8601String(),
            'end_time': start.add(Duration(hours: 1)).toIso8601String(),
            'capacity': 20,
            'enrolled_count': 0,
            'status': 'scheduled',
          };
          debugPrint('Inserting class_session payload: $payloadSession');
          final respSession = await client.from('class_sessions').insert(payloadSession).select().single();
          debugPrint('class_session insert response: $respSession');
          classSessionId = (respSession as Map)['id'].toString();
        } else {
          // create a minimal session if date not provided
          final payloadMin = {
            'course_id': request.courseId,
            'teacher_id': null,
            'session_type': 'online',
            'start_time': DateTime.now().toIso8601String(),
            'end_time': DateTime.now().add(Duration(hours: 1)).toIso8601String(),
          };
          debugPrint('Inserting minimal class_session payload: $payloadMin');
          final respSession = await client.from('class_sessions').insert(payloadMin).select().single();
          debugPrint('class_session insert response: $respSession');
          classSessionId = (respSession as Map)['id'].toString();
        }

        final payload = {
          'user_id': request.userId,
          'class_session_id': classSessionId,
          'status': 'confirmed',
          'booking_date': DateTime.now().toIso8601String(),
        };
        debugPrint('Inserting booking payload: $payload');
        final resp = await client.from('bookings').insert(payload).select().single();
        debugPrint('booking insert response: $resp');
        return Booking.fromJson(_mapBookingDbToModel(Map<String, dynamic>.from(resp as Map)));
      } catch (e, st) {
        debugPrint('createBooking supabase error: $e');
        debugPrint('$st');
        // fallback to mock below
      }
    }
    // Create a mock booking and store it in memory.
    await Future.delayed(const Duration(milliseconds: 250));
    final generatedSessionId = DateTime.now().millisecondsSinceEpoch.toString();
    final booking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: request.userId,
      classSessionId: generatedSessionId,
      bookingDate: request.dateIso != null ? DateTime.parse(request.dateIso!) : DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _bookings.add(booking);
    return booking;
  }
}
