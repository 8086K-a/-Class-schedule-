import 'package:flutter/material.dart';
import '../models/settings.dart';

class SettingsDialog extends StatefulWidget {
  final AppSettings initialSettings;

  const SettingsDialog({super.key, required this.initialSettings});

  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late int _totalWeeks;
  late DateTime _startDate;
  late int _currentWeek;
  late bool _showWeekend;
  late bool _showOtherWeeks;
  late int _classDuration;

  @override
  void initState() {
    super.initState();
    _totalWeeks = widget.initialSettings.totalWeeks;
    _startDate = widget.initialSettings.startDate;
    _showWeekend = widget.initialSettings.showWeekend;
    _showOtherWeeks = widget.initialSettings.showOtherWeeks;
    _classDuration = widget.initialSettings.classDuration;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题栏
            _buildHeader(),

            // 学期设置组
            _buildSection(
              children: [
                _buildSliderTile(
                  "总周数",
                  "${_totalWeeks}周",
                  _totalWeeks.toDouble(),
                  1,
                  30,
                      (v) => setState(() => _totalWeeks = v.toInt()),
                ),
                _buildDateTile(),
              ],
            ),

            // 课程时间组
            _buildSection(
              children: [
                _buildSliderTile(
                  "每节课时长",
                  "${_classDuration}分钟",
                  _classDuration.toDouble(),
                  30,
                  90,
                      (v) => setState(() => _classDuration = v.toInt()),
                ),
              ],
            ),
            // 课程显示组
            _buildSection(
              children: [
                _buildSwitchTile("显示周末", _showWeekend, (v) => setState(() => _showWeekend = v)),
                _buildSwitchTile("显示非本周课程", _showOtherWeeks, (v) => setState(() => _showOtherWeeks = v)),
              ],
            ),

          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text("取消", style: TextStyle(color: Colors.grey[600])),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          onPressed: _saveSettings,
          child: Text("保存", style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  // 构建标题
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Text("设置", style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87
          )),
        ],
      ),
    );
  }

  // 构建设置分组
  Widget _buildSection({required List<Widget> children}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: children
            .map((child) => Container(
          decoration: BoxDecoration(
            border: Border(
                bottom: children.indexOf(child) != children.length - 1
                    ? BorderSide(color: Colors.grey[200]!)
                    : BorderSide.none
            ),
          ),
          child: child,
        ))
            .toList(),
      ),
    );
  }

  // 构建带滑块的设置项
  Widget _buildSliderTile(String title, String value, double current, double min, double max, Function(double) onChanged) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 15)),
          Text(value, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
      subtitle: Slider(
        value: current,
        min: min,
        max: max,
        divisions: (max - min).toInt(),
        activeColor: Colors.blue,
        inactiveColor: Colors.grey[200],
        onChanged: onChanged,
      ),
    );
  }

  // 构建日期选择项
  Widget _buildDateTile() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("开学日期", style: TextStyle(fontSize: 15)),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              backgroundColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _pickStartDate,
            child: Row(
              children: [
                Text("${_startDate.year}-${_startDate.month}-${_startDate.day}",
                    style: TextStyle(color: Colors.grey[700])),
                SizedBox(width: 6),
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建开关项
  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(title, style: TextStyle(fontSize: 15)),
      trailing: Switch(
        value: value,
        activeColor: Colors.blue,
        onChanged: onChanged,
      ),
    );
  }

  Future<void> _pickStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) setState(() => _startDate = date);
  }

  void _saveSettings() {
    Navigator.pop(context, AppSettings(
      totalWeeks: _totalWeeks,
      startDate: _startDate,
      showWeekend: _showWeekend,
      showOtherWeeks: _showOtherWeeks,
      classDuration: _classDuration,
    ));
  }
}