import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_core;
import '../../domain/entities/course.dart';
import '../../data/mock_course_data.dart';
import '../../../../core/constants/app_constants.dart';

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
}
