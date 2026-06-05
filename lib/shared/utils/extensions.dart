import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toFormattedString({String format = 'dd/MM/yyyy'}) {
    return DateFormat(format).format(this);
  }

  String toFormattedDateTimeString({String format = 'dd/MM/yyyy HH:mm'}) {
    return DateFormat(format).format(this);
  }

  String toFormattedTimeString({String format = 'HH:mm'}) {
    return DateFormat(format).format(this);
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isToday() {
    return isSameDay(DateTime.now());
  }

  bool isTomorrow() {
    return isSameDay(DateTime.now().add(Duration(days: 1)));
  }

  bool isYesterday() {
    return isSameDay(DateTime.now().subtract(Duration(days: 1)));
  }

  String get timeAgo {
    final now = DateTime.now();
    final duration = now.difference(this);

    if (duration.inSeconds < 60) {
      return 'now';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m ago';
    } else if (duration.inHours < 24) {
      return '${duration.inHours}h ago';
    } else if (duration.inDays < 7) {
      return '${duration.inDays}d ago';
    } else if (duration.inDays < 30) {
      return '${(duration.inDays / 7).floor()}w ago';
    } else if (duration.inDays < 365) {
      return '${(duration.inDays / 30).floor()}mo ago';
    } else {
      return '${(duration.inDays / 365).floor()}y ago';
    }
  }
}

extension StringExtension on String {
  bool isValidEmail() {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  bool isValidPhone() {
    final phoneRegex = RegExp(r'^[0-9]{10,}$');
    return phoneRegex.hasMatch(replaceAll(RegExp(r'\D'), ''));
  }

  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String toTitleCase() {
    return split(' ')
        .map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}

extension NumExtension on num {
  String toCurrency({String symbol = '₹', int decimals = 2}) {
    return '$symbol${toStringAsFixed(decimals)}';
  }

  String toPercentage({int decimals = 1}) {
    return '${toStringAsFixed(decimals)}%';
  }
}

extension ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }

  List<T> addIfNotEmpty(T element) {
    if ((element as dynamic).toString().isNotEmpty) {
      add(element);
    }
    return this;
  }
}
