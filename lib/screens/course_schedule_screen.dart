import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/course_service.dart';
import '../widgets/schedule_table.dart';
import '../models/settings.dart';
import '../services/settings_service.dart';
import '../widgets/settings_dialog.dart'; // 导入设置对话框

class CourseScheduleScreen extends StatefulWidget {
  @override
  _CourseScheduleScreenState createState() => _CourseScheduleScreenState();
}

class _CourseScheduleScreenState extends State<CourseScheduleScreen> {
  PageController? _pageController; // 改为可空类型
  int _currentWeek = 1;
  Map<int, List<Course>> _weeklyCourses = {};
  bool _isLoading = true;
  late AppSettings _settings;
  @override
  void initState() {
    super.initState();
    _loadSettings().then((_) {
      _pageController = PageController(initialPage: getCurrWeek() - 1);
      _currentWeek = getCurrWeek();
      setState(() {}); // 触发UI更新
    });
    _loadCourses();
    // _pageController = PageController(initialPage: getCurrWeek());
  }

  Future<void> _loadSettings() async {
    final settingsService = SettingsService();
    _settings = await settingsService.loadSettings();
  }

  Future<void> _loadCourses() async {
    try {
      final courses = await CourseService.loadCourses();
      setState(() {
        _weeklyCourses = courses;
        _isLoading = false;
      });
    } catch (e) {
      print("加载课程表失败: $e");
      setState(() => _isLoading = false);
    }
  }

  int getCurrWeek() {
    DateTime now = DateTime.now();
    DateTime startDate = _settings.startDate;
    // 计算天数差（确保正数）
    int daysDifference = now.difference(startDate).inDays;
    // 计算周数（向上取整）
    return (daysDifference ~/ 7);
  }
  void _openSettings() async {
    final settingsService = SettingsService();
    final result = await showDialog<AppSettings>(
      context: context,
      builder: (context) => SettingsDialog(initialSettings: _settings),
    );

    if (result != null) {
      await settingsService.saveSettings(result);
      setState(() {
        _settings = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('第$_currentWeek周'),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : PageView.builder(
        controller: _pageController,
        onPageChanged: (page) => setState(() => _currentWeek = page + 1),
        itemCount: _settings.totalWeeks,
        itemBuilder: (context, index) => ScheduleTable(
          courses: _weeklyCourses[index + 1] ?? [],
          currentWeek: index + 1,
          settings: _settings,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addCourse,
      ),
    );
  }

  void _addCourse() {
  }
}