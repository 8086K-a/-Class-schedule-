import 'package:flutter/material.dart';
import 'screens/course_schedule_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '小米课程表',
      home: CourseScheduleScreen(),
    );
  }
}