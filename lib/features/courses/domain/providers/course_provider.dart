import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_core;
import '../../domain/entities/course.dart';
import '../../data/mock_course_data.dart';
import '../../../../core/constants/app_constants.dart';
import 'package:flutter/foundation.dart' hide Category;

// Courses Repository Provider
final courseRepositoryProvider = Provider((ref) {
  return CourseRepository();
});

// All Courses Provider
final allCoursesProvider = FutureProvider<List<Course>>((ref) async {
  final repository = ref.watch(courseRepositoryProvider);
  return repository.getAllCourses();
});

// Popular Courses Provider
final popularCoursesProvider = FutureProvider<List<Course>>((ref) async {
  final repository = ref.watch(courseRepositoryProvider);
  return repository.getPopularCourses();
});

// Course Details Provider
final courseDetailsProvider = FutureProvider.family<Course, String>((ref, courseId) async {
  final repository = ref.watch(courseRepositoryProvider);
  return repository.getCourseById(courseId);
});

// All Reviews Provider
final allReviewsProvider = FutureProvider<List<ReviewModel>>((ref) async {
  final repository = ref.watch(courseRepositoryProvider);
  return repository.getAllReviews();
});

// Categories Provider
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repository = ref.watch(courseRepositoryProvider);
  return repository.getCategories();
});

// Courses by Category Provider
final coursesByCategoryProvider = FutureProvider.family<List<Course>, String>((ref, categoryId) async {
  final repository = ref.watch(courseRepositoryProvider);
  return repository.getCoursesByCategory(categoryId);
});

class CourseRepository {
  bool get _isSupabaseActive {
    try {
      final client = supabase_core.Supabase.instance.client;
      return AppConstants.supabaseUrl != 'https://your-project.supabase.co' &&
             AppConstants.supabaseUrl.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Map<String, dynamic> _mapCourseDbToModel(Map<String, dynamic> dbJson) {
    return {
      'id': dbJson['id']?.toString() ?? '',
      'name': dbJson['name']?.toString() ?? '',
      'description': dbJson['description']?.toString() ?? '',
      'categoryId': dbJson['category_id']?.toString() ?? dbJson['categoryId']?.toString() ?? '',
      'instructorId': dbJson['instructor_id']?.toString() ?? dbJson['instructorId']?.toString() ?? '',
      'thumbnailUrl': dbJson['thumbnail_url']?.toString() ?? dbJson['thumbnailUrl']?.toString(),
      'price': dbJson['price'] != null ? double.parse(dbJson['price'].toString()) : 0.0,
      'duration': dbJson['duration'] != null ? int.parse(dbJson['duration'].toString()) : 0,
      'level': dbJson['level']?.toString() ?? 'Beginner',
      'rating': dbJson['rating'] != null ? double.parse(dbJson['rating'].toString()) : 0.0,
      'totalStudents': dbJson['total_students'] != null
          ? int.parse(dbJson['total_students'].toString())
          : (dbJson['totalStudents'] != null ? int.parse(dbJson['totalStudents'].toString()) : 0),
      'whatYouWillLearn': dbJson['what_you_will_learn'] != null
          ? List<String>.from(dbJson['what_you_will_learn'] as List)
          : (dbJson['whatYouWillLearn'] != null ? List<String>.from(dbJson['whatYouWillLearn'] as List) : null),
      'requirements': dbJson['requirements'] != null
          ? List<String>.from(dbJson['requirements'] as List)
          : (dbJson['requirements'] != null ? List<String>.from(dbJson['requirements'] as List) : null),
      'createdAt': dbJson['created_at'] ?? dbJson['createdAt'],
      'updatedAt': dbJson['updated_at'] ?? dbJson['updatedAt'],
    };
  }

  Map<String, dynamic> _mapCategoryDbToModel(Map<String, dynamic> dbJson) {
    return {
      'id': dbJson['id']?.toString() ?? '',
      'name': dbJson['name']?.toString() ?? '',
      'description': dbJson['description']?.toString(),
      'iconUrl': dbJson['icon_url']?.toString() ?? dbJson['iconUrl']?.toString(),
    };
  }

  Future<List<Course>> getAllCourses() async {
    if (_isSupabaseActive) {
      try {
        final response = await supabase_core.Supabase.instance.client
            .from('courses')
            .select();
        return (response as List)
            .map((json) => Course.fromJson(_mapCourseDbToModel(json)))
            .toList();
      } catch (e) {
        return MockCourseData.mockCourses;
      }
    }
    return MockCourseData.mockCourses;
  }

  Future<List<Course>> getPopularCourses() async {
    if (_isSupabaseActive) {
      try {
        final response = await supabase_core.Supabase.instance.client
            .from('courses')
            .select()
            .order('rating', ascending: false)
            .limit(3);
        return (response as List)
            .map((json) => Course.fromJson(_mapCourseDbToModel(json)))
            .toList();
      } catch (e) {
        return MockCourseData.mockCourses.take(3).toList();
      }
    }
    return MockCourseData.mockCourses.take(3).toList();
  }

  Future<Course> getCourseById(String courseId) async {
    if (_isSupabaseActive) {
      try {
        final response = await supabase_core.Supabase.instance.client
            .from('courses')
            .select()
            .eq('id', courseId)
            .maybeSingle();
        if (response != null) {
          return Course.fromJson(_mapCourseDbToModel(response));
        }
      } catch (_) {}
    }
    return MockCourseData.mockCourses.firstWhere(
      (c) => c.id == courseId,
      orElse: () => MockCourseData.mockCourses.first,
    );
  }

  Future<List<Category>> getCategories() async {
    if (_isSupabaseActive) {
      try {
        final response = await supabase_core.Supabase.instance.client
            .from('categories')
            .select();
        return (response as List)
            .map((json) => Category.fromJson(_mapCategoryDbToModel(json)))
            .toList();
      } catch (e) {
        return MockCourseData.mockCategories;
      }
    }
    return MockCourseData.mockCategories;
  }

  Future<List<Course>> getCoursesByCategory(String categoryId) async {
    if (_isSupabaseActive) {
      try {
        final response = await supabase_core.Supabase.instance.client
            .from('courses')
            .select()
            .eq('category_id', categoryId);
        return (response as List)
            .map((json) => Course.fromJson(_mapCourseDbToModel(json)))
            .toList();
      } catch (e) {
        return MockCourseData.mockCourses.where((c) => c.categoryId == categoryId).toList();
      }
    }
    return MockCourseData.mockCourses.where((c) => c.categoryId == categoryId).toList();
  }

  Future<void> submitRating({
    required String userId,
    required String courseId,
    required double rating,
    required String reviewText,
  }) async {
    if (_isSupabaseActive) {
      try {
        final data = {
          'user_id': userId,
          'course_id': courseId,
          'rating': rating,
          'review': reviewText,
        };
        debugPrint('Submitting rating payload to Supabase: $data');
        await supabase_core.Supabase.instance.client
            .from('ratings')
            .upsert(data, onConflict: 'user_id,course_id');
        debugPrint('Rating submitted successfully!');
        return;
      } catch (e) {
        debugPrint('submitRating supabase error: $e');
      }
    }
    debugPrint('Mock: saved rating $rating for course $courseId by user $userId: "$reviewText"');
  }

  Future<List<ReviewModel>> getAllReviews() async {
    if (_isSupabaseActive) {
      try {
        final response = await supabase_core.Supabase.instance.client
            .from('ratings')
            .select('*, users(full_name), courses(name)')
            .order('created_at', ascending: false);
            
        return (response as List).map((json) {
          final dbMap = Map<String, dynamic>.from(json as Map);
          
          final userName = dbMap['users'] != null 
              ? dbMap['users']['full_name']?.toString() 
              : 'Anonymous';
          final courseName = dbMap['courses'] != null 
              ? dbMap['courses']['name']?.toString() 
              : 'Course';
              
          return ReviewModel(
            id: dbMap['id']?.toString() ?? '',
            userName: userName ?? 'Anonymous',
            courseName: courseName ?? 'Course',
            rating: dbMap['rating'] != null ? double.parse(dbMap['rating'].toString()) : 5.0,
            review: dbMap['review']?.toString() ?? '',
            createdAt: dbMap['created_at'] != null 
                ? DateTime.parse(dbMap['created_at'].toString()) 
                : DateTime.now(),
          );
        }).toList();
      } catch (e) {
        debugPrint('getAllReviews supabase error: $e');
      }
    }
    return [];
  }
}
