import 'package:flutter/material.dart';
import '../models/course.dart';
import 'course_item.dart';

class DayColumn extends StatelessWidget {
  final int day;
  final List<Course> courses;
  final double sectionHeight;
  final int totalSections;
  final double columnWidth;

  const DayColumn({
    super.key,
    required this.day,
    required this.courses,
    required this.sectionHeight,
    required this.totalSections,
    required this.columnWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: columnWidth,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Stack(
        children: [
          _buildGridBackground(),
          ...courses.map((course) => CourseItem(
            key: ValueKey('${course.name}_${course.day}_${course.startSection}_${course.endSection}'),
            course: course,
            sectionHeight: sectionHeight,
            columnWidth: columnWidth,
          )),
        ],
      ),
    );
  }

  Widget _buildGridBackground() {
    return Column(
      children: List.generate(
        totalSections,
            (index) => Container(
          height: sectionHeight,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
          ),
        ),
      ),
    );
  }
}