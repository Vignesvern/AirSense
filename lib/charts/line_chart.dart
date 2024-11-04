import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LineChartContent extends StatelessWidget {
  @override

  List<Color> lineColor = [
    Color(0xfff3f169),
  ];

  List<LineChartBarData> lineChartBarData = [
    LineChartBarData(
        //colors: lineColor,
        isCurved: true,
        spots: [
          FlSpot(1, 8),
          FlSpot(2, 12.4),
          FlSpot(3, 10.8),
          FlSpot(4, 9),
          FlSpot(5, 8),
          FlSpot(6, 8.6),
          FlSpot(7, 10)
        ]
    )
  ];

  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 1,
        minY: 0,
        maxX: 7,
        maxY: 16,
        lineBarsData: lineChartBarData,
      ),
    );
  }
}