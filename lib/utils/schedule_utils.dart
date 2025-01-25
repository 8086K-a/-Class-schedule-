// schedule_utils.dart
List<String> getTimeString(int section, int duration) {
  // 计算每节课的开始时间
  final totalMinutes = (section - 1) * duration + 70 * ((section >= 6 ? 1 : 0) + (section >= 10 ? 1 : 0));
  final startHour = 8 + (totalMinutes ~/ 60);
  final startMinute = totalMinutes % 60;
  final endTotal = totalMinutes + duration;
  final endHour = 8 + (endTotal ~/ 60);
  final endMinute = endTotal % 60;

  return [
    '$section',
    '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}',
    '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}'
  ];
}

String getWeekDay(int day) => ['一', '二', '三', '四', '五', '六', '日'][day - 1];