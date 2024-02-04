// ignore_for_file: implementation_imports

import 'dart:convert';
import 'dart:math';
import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as element;
import 'package:charts_flutter/src/text_element.dart' as ts;
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:flutter/material.dart';
import 'package:gmstest/configs/colors.dart';

class CustomCircleSymbolRenderer extends CircleSymbolRenderer {
  CustomCircleSymbolRenderer(this.value);

  final String value;
  @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds,
      {List<int>? dashPattern,
      Color? fillColor,
      FillPatternType? fillPattern,
      Color? strokeColor,
      double? strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    canvas.drawRect(
        Rectangle(bounds.left - 5, bounds.top - 30, bounds.width + 10,
            bounds.height + 10),
        fill: Color.white);
    var textStyle = style.TextStyle();
    textStyle.color = Color.black;
    textStyle.fontSize = 15;
    canvas.drawText(ts.TextElement("$value", style: textStyle),
        (bounds.left).round(), (bounds.top - 28).round());
  }
}

typedef GetText = String Function();
int pointIndex = -1;

class TextSymbolRenderer extends CircleSymbolRenderer {
  TextSymbolRenderer(this.getText,
      {this.marginBottom = 8, this.padding = const EdgeInsets.all(8)});

  final GetText getText;
  final double marginBottom;
  final EdgeInsets padding;

  @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds,
      {List<int>? dashPattern,
      Color? fillColor,
      FillPatternType? fillPattern,
      Color? strokeColor,
      double? strokeWidthPx}) {
    pointIndex = pointIndex + 1;

    List<dynamic> list = json.decode(getText.call());
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        fillPattern: fillPattern,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);

    style.TextStyle textStyle = style.TextStyle();
    textStyle.color = Color.black;
    textStyle.fontSize = 15;

    element.TextElement textElement =
        element.TextElement(list[pointIndex].toString(), style: textStyle);
    double width = textElement.measurement.horizontalSliceWidth;
    double height = textElement.measurement.verticalSliceWidth;

    double centerX = bounds.left + bounds.width / 2;
    double centerY = bounds.top +
        bounds.height / 2 -
        marginBottom -
        (padding.top + padding.bottom);

    canvas.drawRRect(
      Rectangle(
        centerX - (width / 2) - padding.left,
        centerY - (height / 2) - padding.top,
        width + (padding.left + padding.right),
        height + (padding.top + padding.bottom),
      ),
      fill: Color.white,
      radius: 16,
      roundTopLeft: true,
      roundTopRight: true,
      roundBottomRight: true,
      roundBottomLeft: true,
    );
    canvas.drawText(
      textElement,
      (centerX - (width / 2)).round(),
      (centerY - (height / 2)).round(),
    );
  }
}

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
    primaryDarkYellowColor,
    Colors.green,
  ];
  @override
  void initState() {
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
        OrdinalSales modifiedMap = OrdinalSales(originalMap['date'].toString(),
            double.parse(originalMap['inventory_days'].toStringAsFixed(0)));
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
              barGroupingType: charts.BarGroupingType.stacked,
              // barRendererDecorator: charts.BarLabelDecorator<String>(),
              domainAxis: charts.OrdinalAxisSpec(
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

              // defaultRenderer: charts.BarRendererConfig(
              //   groupingType: charts.BarGroupingType.stacked,
              //   strokeWidthPx: 2.0,
              // ),
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
