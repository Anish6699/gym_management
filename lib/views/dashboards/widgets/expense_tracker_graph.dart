import 'package:fl_chart/fl_chart.dart';
// import 'package:fl_line_chart_example/widget/line_titles.dart';
import 'package:flutter/material.dart';

class ExpenseTrackerGraph extends StatefulWidget {
  List graphData;
  ExpenseTrackerGraph({super.key, required this.graphData});

  @override
  State<ExpenseTrackerGraph> createState() => _ExpenseTrackerGraphState();
}

class _ExpenseTrackerGraphState extends State<ExpenseTrackerGraph> {
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List<FlSpot> convertToListOfFlSpots(List data) {
    List<FlSpot> flSpots = [];

    for (int i = 0; i < data.length; i++) {
      String month = data[i]['month'];
      double value = data[i]['value'].toDouble();
      flSpots.add(FlSpot(i.toDouble(), value));
    }

    return flSpots;
  }

  List<FlSpot> graphFlList = [];

  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() {
    graphFlList = convertToListOfFlSpots(widget.graphData);
  }

  @override
  Widget build(BuildContext context) => LineChart(
        LineChartData(
          minX: 0,
          // maxX: 11,
          minY: 0,
          // maxY: 6,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(value.toString());
              },
            )),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    switch (value.toInt()) {
                      case 0:
                        return const Text('Jan');
                      case 1:
                        return const Text('Feb');
                      case 2:
                        return const Text('Mar');
                      case 3:
                        return const Text('Apr');
                      case 4:
                        return const Text('May');
                      case 5:
                        return const Text('Jun');
                      case 6:
                        return const Text('Jul');
                      case 7:
                        return const Text('Aug');
                      case 8:
                        return const Text('Sep');
                      case 9:
                        return const Text('Oct');
                      case 10:
                        return const Text('Nov');
                      case 11:
                        return const Text('Dec');
                      default:
                        return const Text('');
                    }
                  },
                  interval: 1
                  // reservedSize: 0.1,
                  ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: const Color(0xff37434d),
                strokeWidth: 1,
              );
            },
            drawVerticalLine: true,
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: const Color(0xff37434d),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: graphFlList,
              isCurved: true,
              isStrokeJoinRound: false,
              isStrokeCapRound: false,
              curveSmoothness: 0.1,
              color: Color(0xff23b6e6),
              barWidth: 3,
              // dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                  show: true, color: Color(0xff02d39a).withOpacity(0.3)),
            ),
          ],
        ),
      );
}
