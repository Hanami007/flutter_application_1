import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learn_hub/shared/widgets/common_widgets.dart';
import 'package:learn_hub/features/booking/domain/providers/booking_provider.dart';
import 'package:learn_hub/features/booking/domain/entities/booking.dart';
import 'package:learn_hub/features/courses/domain/providers/course_provider.dart';
import 'package:learn_hub/features/courses/domain/entities/course.dart';
import 'package:learn_hub/features/enrollment/domain/providers/enrollment_provider.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    // Ensure focusedDay falls within the calendar's allowed range to avoid
    // TableCalendar assertion failures when device date is beyond lastDay.
    final computedLastDay = DateTime.utc(DateTime.now().year + 1, 12, 31);
    if (_focusedDay.isAfter(computedLastDay)) {
      _focusedDay = computedLastDay;
    }
  }

  String _formatSelectedDateThai(DateTime date) {
    final monthsTh = [
      'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
      'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'
    ];
    return '${date.day} ${monthsTh[date.month - 1]} ${date.year + 543}';
  }

  Color _getCategoryColor(String courseName) {
    final name = courseName.toLowerCase();
    if (name.contains('procreate') || name.contains('วาดรูป') || name.contains('ศิลปะ') || name.contains('art')) {
      return const Color(0xFFAB94F0); // Purple
    } else if (name.contains('flutter') || name.contains('program') || name.contains('code') || name.contains('โปรแกรม')) {
      return const Color(0xFF2DC9A8); // Teal
    } else if (name.contains('guitar') || name.contains('ดนตรี') || name.contains('music')) {
      return const Color(0xFFFF9F50); // Orange
    } else if (name.contains('cook') || name.contains('อาหาร') || name.contains('cooking')) {
      return const Color(0xFFFF7EB3); // Pink
    } else if (name.contains('science') || name.contains('วิทยาศาสตร์') || name.contains('วิทย์')) {
      return const Color(0xFF5B9CF6); // Blue
    }
    return const Color(0xFF2DC9A8); // Default brand Teal
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(currentUserIdProvider);
    final userBookingsAsync = ref.watch(userBookingsProvider(userId));
    final classSessionsAsync = ref.watch(allClassSessionsProvider);
    final coursesAsync = ref.watch(allCoursesProvider);
    final enrolledCoursesAsync = ref.watch(enrolledCoursesProvider);

    final bookings = userBookingsAsync.value ?? [];
    final classSessions = classSessionsAsync.value ?? [];
    final courses = coursesAsync.value ?? [];
    final enrolledCourses = enrolledCoursesAsync.value ?? [];

    const textDarkColor = Color(0xFF1A1F36);
    const textMidColor = Color(0xFF6E7A9A);
    const brandTeal = Color(0xFF2DC9A8);
    const brandTealLight = Color(0xFFE6F9F5);

    // Collect all dates with bookings or class sessions of enrolled courses
    final highlightedDays = <DateTime>{};
    for (final b in bookings) {
      if (b.bookingDate != null) {
        highlightedDays.add(DateTime(b.bookingDate!.year, b.bookingDate!.month, b.bookingDate!.day));
      }
    }

    final enrolledCourseIds = enrolledCourses.map((c) => c.id).toSet();
    final enrolledClassSessions = classSessions.where((s) => enrolledCourseIds.contains(s.courseId)).toList();

    for (final s in enrolledClassSessions) {
      highlightedDays.add(DateTime(s.startTime.year, s.startTime.month, s.startTime.day));
    }

    final selectedDate = _selectedDay ?? DateTime.now();
    final normalizedSelectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    // Filter bookings for the selected date
    final selectedBookings = bookings.where((b) {
      if (b.bookingDate == null) return false;
      final normalizedBookingDate = DateTime(b.bookingDate!.year, b.bookingDate!.month, b.bookingDate!.day);
      return normalizedBookingDate == normalizedSelectedDate;
    }).toList();

    // Filter enrolled class sessions for the selected date
    final selectedSessions = enrolledClassSessions.where((s) {
      final normalizedSessionDate = DateTime(s.startTime.year, s.startTime.month, s.startTime.day);
      return normalizedSessionDate == normalizedSelectedDate;
    }).toList();

    // Merge them into display items
    final displayItems = <dynamic>[];
    final bookedSessionIds = selectedBookings.map((b) => b.classSessionId).toSet();

    // Add bookings first
    displayItems.addAll(selectedBookings);

    // Add enrolled class sessions that aren't already booked
    for (final s in selectedSessions) {
      if (!bookedSessionIds.contains(s.id)) {
        displayItems.add(s);
      }
    }

    final isLoading = userBookingsAsync.isLoading ||
        classSessionsAsync.isLoading ||
        coursesAsync.isLoading ||
        enrolledCoursesAsync.isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(
          'ตารางเรียน',
          style: GoogleFonts.notoSansThai(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: textDarkColor,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Calendar Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFEDF2F7), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(DateTime.now().year + 1, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  eventLoader: (day) {
                    final normalizedDay = DateTime(day.year, day.month, day.day);
                    if (highlightedDays.contains(normalizedDay)) {
                      return ['event'];
                    }
                    return [];
                  },
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: GoogleFonts.notoSansThai(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: textDarkColor,
                    ),
                    weekendStyle: GoogleFonts.notoSansThai(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFF7EB3),
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    selectedDecoration: const BoxDecoration(
                      color: brandTeal,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: const BoxDecoration(
                      color: brandTealLight,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: brandTeal,
                    ),
                    selectedTextStyle: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    defaultTextStyle: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: textDarkColor,
                    ),
                    weekendTextStyle: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFFF7EB3),
                    ),
                    outsideTextStyle: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      color: const Color(0xFFA0AEC0),
                    ),
                    markerDecoration: const BoxDecoration(
                      color: brandTeal,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    leftChevronIcon: const Icon(
                      Icons.chevron_left_rounded,
                      color: brandTeal,
                    ),
                    rightChevronIcon: const Icon(
                      Icons.chevron_right_rounded,
                      color: brandTeal,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    headerTitleBuilder: (context, date) {
                      final monthsTh = [
                        'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน',
                        'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม'
                      ];
                      return Center(
                        child: Text(
                          '${monthsTh[date.month - 1]} ${date.year}',
                          style: GoogleFonts.notoSansThai(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: textDarkColor,
                          ),
                        ),
                      );
                    },
                    defaultBuilder: (context, day, focusedDay) {
                      final normalizedDay = DateTime(day.year, day.month, day.day);
                      if (highlightedDays.contains(normalizedDay)) {
                        final isSelected = isSameDay(_selectedDay, day);
                        if (isSelected) return null;

                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: brandTealLight,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: brandTeal.withValues(alpha: 0.35),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '${day.day}',
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: brandTeal,
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                    outsideBuilder: (context, day, focusedDay) {
                      final normalizedDay = DateTime(day.year, day.month, day.day);
                      if (highlightedDays.contains(normalizedDay)) {
                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F9FC),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '${day.day}',
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFA0AEC0),
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),

            // Sessions Header Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _formatSelectedDateThai(selectedDate),
                      style: GoogleFonts.notoSansThai(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: textDarkColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (displayItems.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: brandTealLight,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        '${displayItems.length} คลาส',
                        style: GoogleFonts.notoSansThai(
                          fontSize: 11.sp,
                          color: brandTeal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 8.h),

            if (isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: LoadingWidget(),
              )
            else if (displayItems.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 48.h),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.calendar_today_rounded,
                        size: 36.sp,
                        color: const Color(0xFFA0AEC0),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'ไม่มีตารางเรียนในวันนี้',
                      style: GoogleFonts.notoSansThai(
                        fontSize: 13.sp,
                        color: textMidColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: displayItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: _buildScheduleCard(displayItems[index], classSessions, courses),
                  );
                },
              ),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard(
    dynamic item,
    List<ClassSession> classSessions,
    List<Course> courses,
  ) {
    if (item is Booking) {
      return _buildBookingCard(item, classSessions, courses);
    }

    final session = item as ClassSession;
    final course = courses.where((c) => c.id == session.courseId).firstOrNull;

    final courseName = course?.name ?? 'คลาสเรียนบรรยายสด (Live)';
    final sessionType = session.sessionType;
    final startTime = session.startTime;
    final endTime = session.endTime;

    final timeStr = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')} - '
        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')} น.';

    final categoryColor = _getCategoryColor(courseName);
    const textDarkColor = Color(0xFF1A1F36);
    const textMidColor = Color(0xFF6E7A9A);
    const brandTeal = Color(0xFF2DC9A8);
    const brandTealLight = Color(0xFFE6F9F5);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEDF2F7), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vertical Accent Indicator Bar (Google Calendar style)
          Container(
            width: 4.w,
            height: 48.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: categoryColor,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        courseName,
                        style: GoogleFonts.notoSansThai(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: textDarkColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        color: brandTealLight,
                      ),
                      child: Text(
                        'UPCOMING',
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: brandTeal,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  'คลาสสอนสด • ${sessionType.toUpperCase()}',
                  style: GoogleFonts.notoSansThai(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: textMidColor,
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 14.sp, color: brandTeal),
                    SizedBox(width: 6.w),
                    Text(
                      timeStr,
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: textDarkColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(
    Booking booking,
    List<ClassSession> classSessions,
    List<Course> courses,
  ) {
    final session = classSessions
        .where((s) => s.id == booking.classSessionId)
        .firstOrNull;
    final course = session != null
        ? courses.where((c) => c.id == session.courseId).firstOrNull
        : null;

    final courseName = course?.name ?? 'คลาสเรียนบรรยายสด (Live)';
    final sessionType = session?.sessionType ?? 'online';
    final startTime = session?.startTime ?? booking.bookingDate ?? DateTime.now();
    final endTime = session?.endTime ?? startTime.add(const Duration(hours: 1));

    final timeStr = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')} - '
        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')} น.';

    final categoryColor = _getCategoryColor(courseName);
    const textDarkColor = Color(0xFF1A1F36);
    const textMidColor = Color(0xFF6E7A9A);
    const brandTeal = Color(0xFF2DC9A8);
    const statusGreen = Color(0xFF10B981);
    const statusGreenLight = Color(0xFFD1FAE5);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEDF2F7), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vertical Accent Indicator Bar (Google Calendar style)
          Container(
            width: 4.w,
            height: 48.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: categoryColor,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        courseName,
                        style: GoogleFonts.notoSansThai(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: textDarkColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        color: statusGreenLight,
                      ),
                      child: Text(
                        booking.status.toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: statusGreen,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  'คลาสที่จองไว้ • ${sessionType.toUpperCase()}',
                  style: GoogleFonts.notoSansThai(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: textMidColor,
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 14.sp, color: brandTeal),
                    SizedBox(width: 6.w),
                    Text(
                      timeStr,
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: textDarkColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
