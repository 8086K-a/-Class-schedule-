import 'package:flutter/material.dart';
import '../models/course.dart';
import 'course_detail_sheet.dart';
class CourseItem extends StatelessWidget {
  final Course course;
  final double sectionHeight;
  final double columnWidth;
  const CourseItem({
    Key? key,
    required this.course,
    required this.sectionHeight,
    required this.columnWidth,
  }) : super(key: key);

  void _showCourseDetail(BuildContext context, Course course) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CourseDetailSheet(course: course),
    );
  }

  @override
  Widget build(BuildContext context) {
    final duration = course.endSection - course.startSection + 1;
    final height = duration * sectionHeight - 3; // 根据实际间距调整
    int temp = 0;
    if (course.startSection >= 6 && course.startSection <= 9) {
      temp = course.startSection - 5;
    } else if (course.startSection >= 10 && course.startSection <= 13) {
      temp = course.startSection - 10;
    } else {
      temp = course.startSection;
    }
    final top = (temp - 1) * sectionHeight + 1;

    return Positioned(
      top: top,
      left: 1.5,
      width: columnWidth - 4,
      height: height,
      child: GestureDetector(
        onTap: () => _showCourseDetail(context, course),
        child: Container(
          decoration: BoxDecoration(
            color:course.isCurrWeek? course.color: Colors.grey[300],
            borderRadius: BorderRadius.circular(6),
            // border: Border.all( color:course.isCurrWeek? course.color: Colors.grey[300]!,),
          ),
          padding: const EdgeInsets.only(top: 6, left: 4,right: 4),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.name,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color:course.isCurrWeek? course.colorDarker: Colors.grey)),
                  const SizedBox(height: 2),
                  Text(course.classroom,
                      // overflow: TextOverflow.ellipsis, // 超出显示省略号
                      style: TextStyle(fontSize: 11, color:course.isCurrWeek? course.colorDarker: Colors.grey)),
                  Text(course.teacher,
                      // overflow: TextOverflow.ellipsis, // 超出显示省略号
                      style: TextStyle(fontSize: 11, color:course.isCurrWeek? course.colorDarker: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}