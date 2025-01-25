import 'package:flutter/material.dart';
import '../models/course.dart';
import '../utils/schedule_utils.dart';
import '../core/constants/strings.dart';

class CourseDetailSheet extends StatelessWidget {
  final Course course;

  const CourseDetailSheet({super.key, required this.course});

  String _formatTimeAndWeeks() {
    // 生成节次范围 (如：3-5节)
    final sectionRange = '${course.startSection}-${course.endSection}节';
    // 生成周数范围 (如：1-8周)
    final weekRange = '${course.startWeek}-${course.endWeek}周';
    return '($sectionRange)$weekRange';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailRow('课程名称:', course.name),
          _buildDetailRow('教室:', course.classroom.replaceAll('@', '')),
          _buildDetailRow('教师:', course.teacher),
          // 合并时间和周数显示
          _buildDetailRow('时间:', '周${getWeekDay(course.day)} ${_formatTimeAndWeeks()}'),
          _buildDetailRow('备注:', course.remark),
          _buildDetailRow('学分:', '${course.credit.toStringAsFixed(1)} 学分'),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: course.colorDarker,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('关闭',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}