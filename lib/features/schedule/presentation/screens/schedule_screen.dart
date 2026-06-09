import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:learn_hub/core/theme/app_theme.dart';
import 'package:learn_hub/shared/constants/app_strings.dart';
import 'package:learn_hub/shared/widgets/common_widgets.dart';
import 'package:learn_hub/features/booking/domain/providers/booking_provider.dart';
import 'package:learn_hub/features/booking/domain/entities/booking.dart';
import 'package:learn_hub/features/courses/domain/providers/course_provider.dart';
import 'package:learn_hub/features/courses/domain/entities/course.dart';
import 'package:learn_hub/features/enrollment/domain/providers/enrollment_provider.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

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

  String _formatSelectedDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
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
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(AppStrings.schedule),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Calendar
            Padding(
              padding: EdgeInsets.all(AppTheme.spacingMd),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  color: AppTheme.surfaceColor,
                  boxShadow: AppTheme.softShadow,
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
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    defaultTextStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    weekendTextStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.errorColor,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: AppTheme.primaryColor,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final normalizedDay = DateTime(day.year, day.month, day.day);
                      if (highlightedDays.contains(normalizedDay)) {
                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.12),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.primaryColor.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
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
                            color: AppTheme.primaryColor.withOpacity(0.05),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.primaryColor.withOpacity(0.25),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.primaryColor.withOpacity(0.5),
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

            // Sessions Header for Selected Date
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingMd, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Schedule on ${_formatSelectedDate(selectedDate)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (displayItems.isNotEmpty)
                    Text(
                      '${displayItems.length} session(s)',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),

            if (isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: LoadingWidget(),
              )
            else if (displayItems.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 32.h),
                child: Column(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 48.sp,
                      color: AppTheme.lightGrey,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'No sessions on this day',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
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

    final courseName = course?.name ?? 'Live Class Session';
    final sessionType = session.sessionType;
    final startTime = session.startTime;
    final endTime = session.endTime;

    final timeStr = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')} - '
        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';

    final dateStr = _formatSelectedDate(startTime);

    return Container(
      padding: EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        color: AppTheme.surfaceColor,
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courseName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkGrey,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Instructor • ${sessionType.toUpperCase()}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.mediumGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  color: AppTheme.primaryColor.withOpacity(0.1),
                ),
                child: Text(
                  'UPCOMING',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16.sp, color: AppTheme.primaryColor),
              SizedBox(width: 8.w),
              Text(
                dateStr,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.darkGrey,
                ),
              ),
              SizedBox(width: 16.w),
              Icon(Icons.access_time, size: 16.sp, color: AppTheme.primaryColor),
              SizedBox(width: 8.w),
              Text(
                timeStr,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.darkGrey,
                ),
              ),
            ],
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

    final courseName = course?.name ?? 'Live Class Session';
    final sessionType = session?.sessionType ?? 'online';
    final startTime = session?.startTime ?? booking.bookingDate ?? DateTime.now();
    final endTime = session?.endTime ?? startTime.add(const Duration(hours: 1));

    final timeStr = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')} - '
        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';

    final dateStr = _formatSelectedDate(startTime);

    return Container(
      padding: EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        color: AppTheme.surfaceColor,
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courseName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkGrey,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Instructor • ${sessionType.toUpperCase()}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.mediumGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  color: AppTheme.successColor.withOpacity(0.1),
                ),
                child: Text(
                  booking.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.successColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16.sp, color: AppTheme.primaryColor),
              SizedBox(width: 8.w),
              Text(
                dateStr,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.darkGrey,
                ),
              ),
              SizedBox(width: 16.w),
              Icon(Icons.access_time, size: 16.sp, color: AppTheme.primaryColor),
              SizedBox(width: 8.w),
              Text(
                timeStr,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.darkGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
