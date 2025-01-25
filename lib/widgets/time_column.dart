import 'package:flutter/material.dart';
import '../utils/schedule_utils.dart';

class TimeColumn extends StatelessWidget {
  final double sectionHeight;
  final int startSection;
  final int endSection;
  final int classDuration; // 接收每节课时长

  const TimeColumn({
    Key? key,
    required this.sectionHeight,
    required this.startSection,
    required this.endSection,
    required this.classDuration, // 添加classDuration参数
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: endSection - startSection + 1,
                itemBuilder: (context, index) {
                  final section = startSection + index;
                  return Container(
                    height: sectionHeight,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[100]!),
                        right: BorderSide(color: Colors.grey[100]!),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          getTimeString(section, classDuration)[0], // 传递classDuration
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          getTimeString(section, classDuration)[1], // 传递classDuration
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[700]!,
                          ),
                        ),
                        Text(
                          getTimeString(section, classDuration)[2], // 传递classDuration
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[700]!,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}