import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/course.dart';

class CourseService {
  static Future<Map<int, List<Course>>> loadCourses() async {
    try {
      final jsonString = await rootBundle.loadString('assets/courses.json');
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final courses = (jsonData['courses'] as List)
          .map((item) => Course.fromJson(item))
          .toList();
      return _organizeByWeek(courses, 20);
    } catch (e) {
      return {1: []};
    }
  }

  static Map<int, List<Course>> _organizeByWeek(List<Course> courses, int totalWeek) {
    final Map<int, List<Course>> organized = {};
    for (var course in courses) {
      for (int week = 1; week <= totalWeek; week++) {
        final isCurrWeek = week >= course.startWeek && week <= course.endWeek;
        final courseCopy = Course(
            name: course.name,
            index: course.index,
          classroom: course.classroom,
          teacher: course.teacher,
          remark: course.remark,
          day: course.day,
          startSection: course.startSection,
          endSection: course.endSection,
          startWeek: course.startWeek, // 确保复制 startWeek
          endWeek: course.endWeek,     // 确保复制 endWeek
          credit: course.credit,
            isCurrWeek: isCurrWeek
        );
        organized.putIfAbsent(week, () => []).add(courseCopy);
      }
    }

    return organized;
  }
}