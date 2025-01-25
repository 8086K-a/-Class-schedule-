import 'package:flutter/material.dart';
import '../core/constants/ColorPalette.dart';

class Course {
  final String name;
  final String classroom;
  final String teacher;
  final String remark;
  final int day;
  final int startSection;
  final int endSection;
  final int startWeek;
  final int endWeek;
  final int index;
  final double credit;
  final bool isCurrWeek;
  late final Color color;
  late final Color colorDarker;
  Course({
    required this.name,
    required this.classroom,
    required this.teacher,
    required this.remark,
    required this.day,
    required this.startSection,
    required this.endSection,
    required this.startWeek,
    required this.endWeek,
    required this.index,
    required this.credit,
    required this.isCurrWeek,
  }) {
    final palette = ColorPalette();
    color = palette.getColorByIndexAsColor(index);
    colorDarker = palette.getDarkerColorByIndexAsColor(index);
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      name: json['name'],
      classroom: json['classroom'],
      teacher: json['teacher'],
      remark: json['remark'] ?? '无',
      day: json['day'],
      startSection: json['startSection'],
      endSection: json['endSection'],
      startWeek: json['startWeek'],
      endWeek: json['endWeek'],
      isCurrWeek: json['isCurrWeek'] ?? false,
      index: json['index'],
      credit: (json['credit'] ?? 0.0).toDouble(),
    );
  }
  @override
  String toString() {
    return '课程名称: $name, 星期: $day, 节次: $startSection-$endSection, 周数: $startWeek-$endWeek 是否是本周:$isCurrWeek';
  }
}