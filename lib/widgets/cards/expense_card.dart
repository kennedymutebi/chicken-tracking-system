import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseChart extends StatelessWidget {
  const ExpenseChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  const months = ['Jan', 'Feb', 'Mar'];
                  return Text(months[value.toInt()]);
                },
              ),
            ),
          ),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 500, color: Colors.red)]),
            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 300, color: Colors.red)]),
            BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 700, color: Colors.red)]),
          ],
        ),
      ),
    );
  }
}
