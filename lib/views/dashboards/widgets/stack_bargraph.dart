// ignore_for_file: implementation_imports

import 'dart:convert';
import 'dart:math';
import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as element;
import 'package:charts_flutter/src/text_element.dart' as ts;
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mat;

class StackBarGraphWidget extends StatefulWidget {
  List graphData = [];

  StackBarGraphWidget(this.graphData);

  @override
  State<StackBarGraphWidget> createState() => _OrdinalComboBarLineChartState();
}

class _OrdinalComboBarLineChartState extends State<StackBarGraphWidget> {
  List<List<OrdinalSales>> modifiedList = [];
  int xAxisLength = 0;
  List randomColors = [
    mat.Color.fromRGBO(35, 182, 230, 1),
    mat.Color.fromRGBO(2, 211, 154, 1)
  ];
  @override
  void initState() {
    print('graphhhhh datatattatat');
    print(widget.graphData);
    aaaa();
    super.initState();
  }

  aaaa() async {
    await createtempList();
  }

  List<List> temp = [];
  createtempList() {
    for (int i = 0; i < widget.graphData.length; i++) {
      temp.add(widget.graphData[i]['data']);
    }
    createOg();
  }

  createOg() {
    modifiedList = temp.map((innerList) {
      return innerList.map((originalMap) {
        OrdinalSales modifiedMap = OrdinalSales(originalMap['month'].toString(),
            double.parse(originalMap['count'].toStringAsFixed(0)));
        return modifiedMap;
      }).toList();
    }).toList();
    Set<String> uniqueYears = modifiedList
        .expand((series) => series.map((data) => data.year))
        .toSet();

    // Calculate the length of the X-axis
    xAxisLength = uniqueYears.length;
  }

  @override
  Widget build(BuildContext context) {
    String value = '';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: xAxisLength < 11
                ? MediaQuery.of(context).size.width * 0.65
                : MediaQuery.of(context).size.width * 0.067 * xAxisLength,
            child: charts.BarChart(
              _createSeries(),
              animate: true,
              // barGroupingType: charts.BarGroupingType.stacked,
              // barRendererDecorator: charts.BarLabelDecorator<String>(),
              domainAxis: const charts.OrdinalAxisSpec(
                renderSpec: charts.SmallTickRendererSpec(
                  labelStyle: charts.TextStyleSpec(
                    color: charts.MaterialPalette.white,
                  ),
                ),
              ),
              primaryMeasureAxis: charts.NumericAxisSpec(
                renderSpec: charts.GridlineRendererSpec(
                  labelStyle: charts.TextStyleSpec(
                      color: charts.ColorUtil.fromDartColor(Colors.white)),
                ),
              ),

              defaultRenderer: charts.BarRendererConfig(
                groupingType: charts.BarGroupingType.stacked,
                strokeWidthPx: 2.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<charts.Series<OrdinalSales, String>> _createSeries() {
    return List.generate(
      modifiedList.length,
      (index) => charts.Series<OrdinalSales, String>(
        id: 'Category $index',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(randomColors[index]),
        data: modifiedList[index],
      ),
    );
  }
}

class OrdinalSales {
  final String year;
  final double sales;

  OrdinalSales(this.year, this.sales);
}
