import '../domain/entities/course.dart';
import '../../booking/domain/entities/booking.dart';

class MockCourseData {
  // Mock Categories
  static final List<Category> mockCategories = [
    const Category(
      id: '8f3b2072-881c-4b62-b2d9-1ff04c15144b',
      name: 'Development',
      description: 'Web development, mobile apps, and programming languages',
      iconUrl: 'developer_mode',
    ),
    const Category(
      id: '035f5240-7cc5-4eb8-bb2f-6571fa79bf77',
      name: 'Design',
      description: 'UI/UX design, graphic design, and video editing',
      iconUrl: 'palette',
    ),
    const Category(
      id: '6db8efcc-a477-4c4f-a496-93cb7ce5768e',
      name: 'Data Science',
      description: 'Machine learning, data analytics, and AI models',
      iconUrl: 'analytics',
    ),
    const Category(
      id: 'c36d2e67-d874-4b53-b09e-711e5491f24d',
      name: 'Business',
      description: 'Marketing, startups, leadership, and finance',
      iconUrl: 'business_center',
    ),
    const Category(
      id: '68a2ee3e-67fe-4ec6-89bf-1e64906f23ee',
      name: 'Languages',
      description: 'English, Japanese, Chinese, and communication skills',
      iconUrl: 'language',
    ),
  ];

  // Mock Courses
  static final List<Course> mockCourses = [
    Course(
      id: '1121ee2e-fa46-4bb4-952c-f68482bf4f22',
      name: 'Flutter Mobile Development (Masterclass)',
      description: 'เรียนรู้การพัฒนา Mobile Application ด้วย Flutter และ Dart ตั้งแต่พื้นฐานจนถึงการเชื่อมต่อฐานข้อมูลจริง สร้างแอปพลิเคชันที่สวยงาม รวดเร็ว และรองรับทั้ง iOS และ Android อย่างมืออาชีพ',
      categoryId: '8f3b2072-881c-4b62-b2d9-1ff04c15144b',
      instructorId: '1219ee9d-ff46-4cb4-972c-f68482bf4f17',
      thumbnailUrl: 'https://images.unsplash.com/photo-1617042375876-a13e36732a04?q=80&w=600&auto=format&fit=crop',
      price: 3500.0,
      duration: 40,
      level: 'Beginner',
      rating: 4.8,
      totalStudents: 1540,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Course(
      id: '2232ff3f-ab57-4cc5-a63d-a79493cf5a33',
      name: 'UI/UX Design Essentials with Figma',
      description: 'ออกแบบแอปพลิเคชันและเว็บไซต์ให้ตอบโจทย์ผู้ใช้งานและดูทันสมัย เรียนรู้หลักการจัดวางสี Typography การทำ Wireframe และ High-fidelity Prototype ด้วย Figma พร้อมเทคนิคการทำงานร่วมกับนักพัฒนา',
      categoryId: '035f5240-7cc5-4eb8-bb2f-6571fa79bf77',
      instructorId: 'a5b7c729-ea21-4f1a-b6d1-92b1cb5705ad',
      thumbnailUrl: 'https://images.unsplash.com/photo-1561070791-26c113006238?q=80&w=600&auto=format&fit=crop',
      price: 2900.0,
      duration: 24,
      level: 'Intermediate',
      rating: 4.7,
      totalStudents: 890,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Course(
      id: '3343aa4a-bc68-4dd6-b74e-b8a594df6b44',
      name: 'Advanced Dart & Clean Architecture',
      description: 'เจาะลึกภาษา Dart ขั้นสูง โครงสร้างแบบ Clean Architecture การจัดการ State ด้วย Riverpod และการเขียน Unit/Widget/Integration Tests สำหรับโปรเจกต์ระดับโปรดักชันที่มีเสถียรภาพสูง',
      categoryId: '8f3b2072-881c-4b62-b2d9-1ff04c15144b',
      instructorId: '1219ee9d-ff46-4cb4-972c-f68482bf4f17',
      thumbnailUrl: 'https://images.unsplash.com/photo-1542831371-29b0f74f9713?q=80&w=600&auto=format&fit=crop',
      price: 4200.0,
      duration: 30,
      level: 'Advanced',
      rating: 4.9,
      totalStudents: 450,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Course(
      id: '4454bb5b-cd79-4ee7-c85f-c9b695ef7c55',
      name: 'Data Science & ML with Python',
      description: 'วิเคราะห์ข้อมูลขนาดใหญ่และสร้างโมเดล Machine Learning ด้วยภาษา Python เรียนรู้การใช้งาน Pandas, NumPy, Scikit-Learn และการแสดงผลข้อมูลด้วย Matplotlib และ Seaborn ครบจบในคอร์สเดียว',
      categoryId: '6db8efcc-a477-4c4f-a496-93cb7ce5768e',
      instructorId: 'c6a0c5c4-42b7-4aef-b20b-193de3f13c6b',
      thumbnailUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?q=80&w=600&auto=format&fit=crop',
      price: 3800.0,
      duration: 35,
      level: 'Beginner',
      rating: 4.6,
      totalStudents: 1200,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Course(
      id: '5565cc6c-de80-4ff8-d96f-d0c796f88d66',
      name: 'Digital Marketing & SEO Strategies',
      description: 'กลยุทธ์การทำตลาดออนไลน์ให้ประสบความสำเร็จและยั่งยืน เรียนรู้การทำ SEO, SEM, ยิงโฆษณา Facebook/Google Ads และการวัดผลวิเคราะห์ข้อมูลผู้เยี่ยมชมอย่างแม่นยำด้วย Google Analytics',
      categoryId: 'c36d2e67-d874-4b53-b09e-711e5491f24d',
      instructorId: '4a9fa3bc-452f-410a-8bf7-e54e4e9bc35a',
      thumbnailUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?q=80&w=600&auto=format&fit=crop',
      price: 2500.0,
      duration: 20,
      level: 'Beginner',
      rating: 4.5,
      totalStudents: 620,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  // Mock Branches (Physical Locations)
  static final List<Branch> mockBranches = [
    const Branch(
      id: 'b1122cc3-dd44-4ee5-bf66-aa77bb88cc99',
      name: 'LearnHub Siam Square',
      address: 'Floor 4, Siam Square One, Pathum Wan',
      city: 'Bangkok',
      state: 'Bangkok',
      zipCode: '10330',
      phone: '02-123-4567',
      latitude: 13.7444,
      longitude: 100.5350,
      capacity: 50,
    ),
    const Branch(
      id: 'b2233dd4-ee55-4ff6-c077-bb88cc99ddaa',
      name: 'LearnHub Asoke Center',
      address: 'Floor 12, Exchange Tower, Sukhumvit Road',
      city: 'Bangkok',
      state: 'Bangkok',
      zipCode: '10110',
      phone: '02-765-4321',
      latitude: 13.7360,
      longitude: 100.5604,
      capacity: 40,
    ),
  ];

  // Mock Class Sessions (Live Schedules)
  static final List<ClassSession> mockClassSessions = [
    ClassSession(
      id: 's1122dd3-ee44-4ff5-bf66-aa77bb88cc99',
      courseId: '1121ee2e-fa46-4bb4-952c-f68482bf4f22',
      branchId: 'b1122cc3-dd44-4ee5-bf66-aa77bb88cc99',
      teacherId: '7df20330-8a22-4467-bc85-98317c24a275',
      sessionType: 'onsite',
      startTime: DateTime.now().add(const Duration(days: 1, hours: 2)), // Tomorrow
      endTime: DateTime.now().add(const Duration(days: 1, hours: 5)),
      capacity: 25,
      enrolledCount: 18,
      status: 'scheduled',
    ),
    ClassSession(
      id: 's2233ee4-ff55-4006-c077-bb88cc99ddaa',
      courseId: '1121ee2e-fa46-4bb4-952c-f68482bf4f22',
      branchId: null, // Online
      teacherId: '7df20330-8a22-4467-bc85-98317c24a275',
      sessionType: 'online',
      startTime: DateTime.now().add(const Duration(days: 3, hours: 6)),
      endTime: DateTime.now().add(const Duration(days: 3, hours: 8)),
      capacity: 100,
      enrolledCount: 45,
      status: 'scheduled',
      meetingLink: 'https://zoom.us/j/1234567890',
    ),
    ClassSession(
      id: 's3344ff5-0066-4117-d188-cc99ee00ffbb',
      courseId: '2232ff3f-ab57-4cc5-a63d-a79493cf5a33',
      branchId: 'b2233dd4-ee55-4ff6-c077-bb88cc99ddaa',
      teacherId: '86cb6c32-2d85-48b5-9017-f3162235c024',
      sessionType: 'onsite',
      startTime: DateTime.now().add(const Duration(days: 2, hours: 3)),
      endTime: DateTime.now().add(const Duration(days: 2, hours: 6)),
      capacity: 20,
      enrolledCount: 12,
      status: 'scheduled',
    ),
  ];

  // Mock Course Progresses for the current user
  static final List<CourseProgress> mockProgresses = [
    const CourseProgress(
      id: 'progress-flutter',
      userId: '1',
      courseId: '1121ee2e-fa46-4bb4-952c-f68482bf4f22',
      videosWatched: 6,
      videosTotal: 8,
      progressPercentage: 0.75,
    ),
    const CourseProgress(
      id: 'progress-uiux',
      userId: '1',
      courseId: '2232ff3f-ab57-4cc5-a63d-a79493cf5a33',
      videosWatched: 3,
      videosTotal: 8,
      progressPercentage: 0.375,
    ),
  ];

  // Mock Video Lessons (for inside learning screen)
  static final List<Map<String, dynamic>> mockVideos = [
    {
      'id': 'v1111111-2222-3333-4444-555555555551',
      'course_id': '1121ee2e-fa46-4bb4-952c-f68482bf4f22',
      'title': '1. Introduction to Flutter & Dart',
      'description': 'ทำความรู้จักกับ Flutter framework และภาษา Dart รวมถึงข้อดีและการเขียนเบื้องต้น',
      'video_url': 'https://assets.mixkit.co/videos/preview/mixkit-software-developer-working-on-his-computer-34281-large.mp4',
      'thumbnail_url': 'https://images.unsplash.com/photo-1542831371-29b0f74f9713',
      'duration': 650,
      'order_index': 1,
    },
    {
      'id': 'v2222222-3333-4444-5555-666666666662',
      'course_id': '1121ee2e-fa46-4bb4-952c-f68482bf4f22',
      'title': '2. Flutter Widgets Basics',
      'description': 'เรียนรู้การทำงานของ Stateless และ Stateful Widget และการจัด Layout ด้วย Row/Column',
      'video_url': 'https://assets.mixkit.co/videos/preview/mixkit-software-developer-working-on-his-computer-34281-large.mp4',
      'thumbnail_url': 'https://images.unsplash.com/photo-1617042375876-a13e36732a04',
      'duration': 920,
      'order_index': 2,
    },
    {
      'id': 'v3333333-4444-5555-6666-777777777773',
      'course_id': '1121ee2e-fa46-4bb4-952c-f68482bf4f22',
      'title': '3. Navigation and Routing',
      'description': 'การสลับหน้าจอใน Flutter โดยใช้ Navigator และการส่งค่าข้ามหน้า',
      'video_url': 'https://assets.mixkit.co/videos/preview/mixkit-software-developer-working-on-his-computer-34281-large.mp4',
      'thumbnail_url': 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97',
      'duration': 800,
      'order_index': 3,
    },
    {
      'id': 'v4444444-5555-6666-7777-888888888884',
      'course_id': '1121ee2e-fa46-4bb4-952c-f68482bf4f22',
      'title': '4. State Management with Riverpod',
      'description': 'เจาะลึกการใช้ Riverpod เพื่อควบคุมสถานะของแอปพลิเคชันอย่างเป็นระบบและมีประสิทธิภาพ',
      'video_url': 'https://assets.mixkit.co/videos/preview/mixkit-software-developer-working-on-his-computer-34281-large.mp4',
      'thumbnail_url': 'https://images.unsplash.com/photo-1605379399642-870262d3d051',
      'duration': 1100,
      'order_index': 4,
    },
  ];
}
