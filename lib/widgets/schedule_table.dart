import 'package:flutter/material.dart';
import '../models/course.dart';
import 'time_column.dart';
import 'day_column.dart';
import '../utils/schedule_utils.dart';
import '../utils/date_utils.dart';
import '../core/constants/strings.dart';
import '../models/settings.dart'; // 导入设置模型

class ScheduleTable extends StatefulWidget {
  final List<Course> courses;
  final int currentWeek;
  final AppSettings settings; // 接收设置参数

  const ScheduleTable({
    super.key,
    required this.courses,
    required this.currentWeek,
    required this.settings, // 添加settings参数
  });

  @override
  State<ScheduleTable> createState() => _ScheduleTableState();
}

class _ScheduleTableState extends State<ScheduleTable> {
  final ScrollController _scrollController = ScrollController();
  static const double _dividerHeight = 25.0;
  static const int _totalSections = 13;
  static const _morningSections = [1, 5];
  static const _afternoonSections = [6, 10];
  static const _eveningSections = [11, 13];

  // 根据设置计算每节课的高度
  double get sectionHeight => widget.settings.classDuration * 2.5;

  List<Widget> _buildScheduleContent() => [
    _buildCourseSection(_morningSections[0], _morningSections[1]),
    _buildGlobalDivider(top: 5 * sectionHeight, label: Strings.lunchBreak),
    _buildCourseSection(_afternoonSections[0], _afternoonSections[1]),
    _buildGlobalDivider(
      top: 5 * sectionHeight + _dividerHeight + 5 * sectionHeight,
      label: Strings.dinnerBreak,
    ),
    _buildCourseSection(_eveningSections[0], _eveningSections[1]),
  ];

  Widget _buildCourseSection(int startSection, int endSection) {
    return Positioned(
      top: _getSectionTopOffset(startSection),
      left: 0,
      right: 0,
      child: Container(
        height: (endSection - startSection + 1) * sectionHeight,
        child: Row(
          children: [
            TimeColumn(
              sectionHeight: sectionHeight,
              startSection: startSection,
              endSection: endSection,
              classDuration: widget.settings.classDuration, // 传递每节课时长
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => Row(
                  children: List.generate(
                    widget.settings.showWeekend ? 7 : 5, // 根据设置显示天数
                        (day) => DayColumn(
                      day: day + 1,
                      courses: processData(widget.courses,day,startSection, endSection ,widget.settings),
                      sectionHeight: sectionHeight,
                      totalSections: endSection - startSection + 1,
                      columnWidth: constraints.maxWidth / (widget.settings.showWeekend ? 7 : 5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlobalDivider({
    required double top,
    required String label,
  }) {
    return Positioned(
      top: top,
      left: 0,
      right: 0,
      height: _dividerHeight,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Course> processData(List<Course> data, int day, int startSection, int endSection, AppSettings settings) {
    if (!settings.showOtherWeeks) {
      return data.where((c) =>
      c.day == day + 1 &&
          c.startSection >= startSection &&
          c.endSection <= endSection &&
          c.isCurrWeek == true)
          .toList();
    } else {
      // 1. 获取所有符合条件的课程（包括本周和非本周）
      List<Course> allCourses = data.where((c) =>
      c.day == day + 1 &&
          c.startSection >= startSection &&
          c.endSection <= endSection)
          .toList();

      // 2. 分离本周和非本周课程
      List<Course> currWeek = allCourses.where((c) => c.isCurrWeek).toList();
      List<Course> otherWeek = allCourses.where((c) => !c.isCurrWeek).toList();

      // 3. 记录本周课程占用的节数范围
      Set<int> occupiedSections = {};
      for (Course c in currWeek) {
        for (int s = c.startSection; s <= c.endSection; s++) {
          occupiedSections.add(s);
        }
      }

      // 4. 调整非本周课程的节数范围
      List<Course> adjustedOtherWeek = [];
      for (Course other in otherWeek) {
        List<int> availableSections = [];
        for (int s = other.startSection; s <= other.endSection; s++) {
          if (!occupiedSections.contains(s)) {
            availableSections.add(s);
          }
        }

        // 5. 将连续可用节数分段生成新课程
        if (availableSections.isNotEmpty) {
          int currentStart = availableSections.first;
          for (int i = 1; i < availableSections.length; i++) {
            if (availableSections[i] != availableSections[i-1] + 1) {
              adjustedOtherWeek.add(_createAdjustedCourse(
                  original: other,
                  start: currentStart,
                  end: availableSections[i-1]
              ));
              currentStart = availableSections[i];
            }
          }
          adjustedOtherWeek.add(_createAdjustedCourse(
              original: other,
              start: currentStart,
              end: availableSections.last
          ));
        }
      }

      // 6. 合并结果返回
      return [...currWeek, ...adjustedOtherWeek];
    }
  }

// 辅助函数：生成调整后的课程副本
  Course _createAdjustedCourse({required Course original, required int start, required int end}) {
    return Course(
      name: original.name,
      classroom: original.classroom,
      teacher: original.teacher,
      remark: original.remark,
      day: original.day,
      startSection: start,
      endSection: end,
      startWeek: original.startWeek,
      endWeek: original.endWeek,
      index: original.index,
      credit: original.credit,
      isCurrWeek: original.isCurrWeek,

    );
  }
  double _getSectionTopOffset(int startSection) {
    double offset = 0;
    if (startSection >= 6) offset += _dividerHeight;  // 下午分隔条
    if (startSection >= 10) offset += _dividerHeight; // 晚上分隔条
    return (startSection - 1) * sectionHeight + offset;
  }

  Widget _buildWeekDayHeader() {
    // 根据设置中的开学日期计算周日期
    final weekDates = CourseDateUtils.getWeekDates(widget.currentWeek, widget.settings.startDate);
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          Container(width: 40),
          Expanded(
            child: Row(
              children: List.generate(widget.settings.showWeekend ? 7 : 5, (index) {
                final date = weekDates[index];
                final isToday = _isToday(date);
                return Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '周${getWeekDay(index + 1)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isToday ? Colors.blue : Colors.black,
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        Text(
                          CourseDateUtils.formatCourseDate(date).replaceAll('.', '/'),
                          style: TextStyle(
                            fontSize: 10,
                            color: isToday ? Colors.blue : Colors.black,
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildWeekDayHeader(),
        Expanded(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  height: (_totalSections * sectionHeight) + (_dividerHeight * 2),
                  child: Stack(
                    children: _buildScheduleContent(),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 120,
                  child: Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}