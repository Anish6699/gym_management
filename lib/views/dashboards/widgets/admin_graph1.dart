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
import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/configs/global_functions.dart';
import 'package:gmstest/views/dashboards/branch/testdata.dart';
import 'package:gmstest/views/dashboards/widgets/test_graph_datas.dart';

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

class AdminGraph1 extends StatefulWidget {
  static const String id = '/StackedBarLineExample';

  const AdminGraph1({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<AdminGraph1> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OrdinalComboBarLineChart(graph1Data),
    );
  }
}

class OrdinalComboBarLineChart extends StatefulWidget {
  final List seriesList;

  const OrdinalComboBarLineChart(this.seriesList, {super.key});

  @override
  State<OrdinalComboBarLineChart> createState() =>
      _OrdinalComboBarLineChartState();
}

class _OrdinalComboBarLineChartState extends State<OrdinalComboBarLineChart> {
  List<charts.Series<OrdinalSales, String>> createSampleData(
      List<dynamic> graphData) {
    List<charts.Series<OrdinalSales, String>> seriesList = [];

    // Iterate over each branch's data
    for (var i = 0; i < graphData.length; i++) {
      final branchData = graphData[i];
      final branchName = branchData['branch_name'];
      final List<dynamic> branchDataList = branchData['data'];

      // Create a list of OrdinalSales objects for this branch
      final List<OrdinalSales> salesData = [];

      for (var monthData in branchDataList) {
        salesData.add(OrdinalSales(
          monthData['month'],
          int.parse(monthData['activeValue']),
        ));
      }

      // Create a series for this branch with the color from the list
      seriesList.add(
        charts.Series<OrdinalSales, String>(
          id: branchName,
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          data: salesData,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            randomColors[i],
          ),
          seriesCategory: branchName,
        )..setAttribute(charts.rendererIdKey, 'customLine'),
      );
    }

    return seriesList;
  }

  List randomColors = [];
  List filterList = [
    {"name": "Active Member's", "id": 1},
    {"name": "In-Active Member's", "id": 2},
    {"name": "Pending Fees Member's", "id": 3},
    {"name": "Visitor's", "id": 4},
    {"name": "Total Amount Received", "id": 5},
    {"name": "Total Amount Pending", "id": 6},
  ];

  @override
  void initState() {
    randomColors = generateGlobalRandomColors(widget.seriesList.length);
    super.initState();
  }

  changeGraphonFilterChange() {}
  var selectedFilter;
  @override
  Widget build(BuildContext context) {
    String value = '';
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: mat.MediaQuery.of(context).size.width * 0.5,
              height: mat.MediaQuery.of(context).size.height * 0.08,
              child: mat.ListView.builder(
                  itemCount: widget.seriesList.length,
                  scrollDirection: mat.Axis.horizontal,
                  itemBuilder: ((context, index) {
                    return mat.Row(children: [
                      mat.Container(
                        width: 20,
                        height: 20,
                        color: randomColors[index].withOpacity(0.5),
                      ),
                      mat.Text(
                        "  - ${widget.seriesList[index]['branch_name']}    ",
                        style: mat.TextStyle(
                            fontSize:
                                mat.MediaQuery.of(context).size.width * 0.008,
                            fontWeight: mat.FontWeight.w800),
                      ),
                    ]);
                  })),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.08,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: Colors.transparent),
              ),
              child: DropdownButtonFormField(
                value: selectedFilter,
                isExpanded: true,
                elevation: 1,
                items: [
                  "Active Member's",
                  "In-Active Member's",
                  "Pending Fees Members",
                  "Total Amount Received",
                  "Total Amount Pending"
                ].map(
                  (item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: mat.TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.01,
                            color: Colors.white),
                      ),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  selectedFilter = value!;
                  changeGraphonFilterChange();
                },
                borderRadius: BorderRadius.circular(4),
                style: mat.TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.08,
                  color: Colors.white,
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.width * 0.015,
                ),
                decoration: InputDecoration(
                  hintText: "Select Filter",
                  hintStyle: mat.TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.01,
                    color: Colors.white,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: charts.OrdinalComboChart(
            createSampleData(widget.seriesList),
            animate: true,
            defaultRenderer: charts.BarRendererConfig(
              groupingType: charts.BarGroupingType.stacked,
            ),
            customSeriesRenderers: [
              charts.LineRendererConfig(
                customRendererId: 'customLine',
                includeArea: false,
                includePoints: true, // Include points for tooltips
                radiusPx: 3.0,
              ),
            ],
            behaviors: [
              charts.SelectNearest(
                selectClosestSeries: true,
                eventTrigger: charts.SelectionTrigger.tap,
              ),
              charts.LinePointHighlighter(
                drawFollowLinesAcrossChart: true,
                symbolRenderer: TextSymbolRenderer(() => value),
              ),
            ],
            selectionModels: [
              SelectionModelConfig(changedListener: (SelectionModel model) {
                print(model.selectedDatum);

                pointIndex = -1;

                if (model.hasDatumSelection) {
                  List a = [];
                  a.clear();

                  for (int i = 0; i < model.selectedDatum.length; i++) {
                    a.add(model.selectedDatum[i].series
                        .data[model.selectedDatum[0].index ?? 0].sales);
                  }
                  value = a.toString();
                }
              })
            ],
            domainAxis: const charts.OrdinalAxisSpec(
              renderSpec: charts.SmallTickRendererSpec(
                labelStyle: charts.TextStyleSpec(
                  color: charts.MaterialPalette.white, // X-axis title color
                ),
              ),
            ),
            primaryMeasureAxis: charts.NumericAxisSpec(
              renderSpec: charts.GridlineRendererSpec(
                labelStyle: charts.TextStyleSpec(
                  color: charts.MaterialPalette.white, // Y-axis title color
                ),
                lineStyle: charts.LineStyleSpec(
                  color: charts.ColorUtil.fromDartColor(
                    const mat.Color.fromRGBO(163, 189, 232, 0.1),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
