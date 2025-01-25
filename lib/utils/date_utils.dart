import 'package:intl/intl.dart';

class CourseDateUtils {
  static List<DateTime> getWeekDates(int weekNumber, DateTime startDate) {
    final firstDayOfYear = startDate;
    final daysOffset = (firstDayOfYear.weekday + 6) % 7; // 修正周一计算

    final firstWeekMonday = firstDayOfYear.add(Duration(
      days: (7 - daysOffset) % 7,
    ));

    final targetMonday = firstWeekMonday.add(Duration(
      days: (weekNumber - 1) * 7,
    ));

    return List.generate(7, (index) => targetMonday.add(Duration(days: index)));
  }

  static String formatCourseDate(DateTime date) {
    return DateFormat('M.d').format(date);
  }
  static bool _isToday(DateTime date) =>
      date.difference(DateTime.now()).inDays == 0 &&
          date.year == DateTime.now().year;
}