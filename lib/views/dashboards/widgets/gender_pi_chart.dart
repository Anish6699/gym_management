import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class CustomPieChart extends StatelessWidget {
  final int maleCount;
  final int femaleCount;

  CustomPieChart({required this.maleCount, required this.femaleCount});

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      'Male': maleCount.toDouble(),
      'Female': femaleCount.toDouble(),
    };

    List<Color> colorList = [
      Colors.blue,
      Colors.pink,
    ];

    return PieChart(
      dataMap: dataMap,
      colorList: colorList,
      chartType: ChartType.ring,
      chartRadius: MediaQuery.of(context).size.width / 7,
      legendOptions: const LegendOptions(
        showLegendsInRow: true,
        legendPosition: LegendPosition.bottom,
        showLegends: true,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: true,
        showChartValuesOutside: false,
        decimalPlaces: 0,
      ),
    );
  }
}
