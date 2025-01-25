import 'package:flutter/material.dart';

class ColorPalette {
  static const int _maxColorIndex = 11;

  final List<String> _colors = [
    '#e6f4ff', '#fdebdd', '#defbf7', '#eeedff', '#fcebcd',
    '#ffeff0', '#ffeef8', '#e2f9f3', '#fff9c9', '#faedff', '#f4f2fd'
  ];

  final List<String> _darkerColors = [
    '#00a8ff', '#ff7f50', '#00cec9', '#a55eea', '#ffb142',
    '#ff4757', '#ff6b81', '#00d2d3', '#ffdd59', '#cd84f1', '#7d5fff'
  ];

  int _safeIndex(int index) => index % _maxColorIndex;

  List<String> getColors() => _colors;
  List<String> getDarkerColors() => _darkerColors;

  String getColorByIndex(int index) => _colors[_safeIndex(index)];
  String getDarkerColorByIndex(int index) => _darkerColors[_safeIndex(index)];



  Color getColorByIndexAsColor(int index) => _parseColor(getColorByIndex(index));
  Color getDarkerColorByIndexAsColor(int index) => _parseColor(getDarkerColorByIndex(index));

  static Color _parseColor(String hexColor) {
    try {
      hexColor = hexColor.replaceAll("#", "").padLeft(8, 'FF');
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return Colors.transparent;
    }
  }
}