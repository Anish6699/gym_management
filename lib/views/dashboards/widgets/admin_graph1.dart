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
import 'package:get/get.dart';
import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/configs/global_functions.dart';
import 'package:gmstest/super_admin/branch/branch_view.dart';
import 'package:gmstest/views/dashboards/branch/testdata.dart';
import 'package:gmstest/views/dashboards/widgets/test_graph_datas.dart';
import 'package:gmstest/views/dashboards/widgets/tile_widget.dart';

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
  List graphData;
  AdminGraph1({super.key, required this.graphData});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<AdminGraph1> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OrdinalComboBarLineChart(widget.graphData),
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
  List<charts.Series<OrdinalSales, String>> seriesList = [];
  createSampleData(List<dynamic> graphData) {
    seriesList.clear();
    for (var i = 0; i < graphData.length; i++) {
      final branchData = graphData[i];
      final branchName = branchData['branch_name'];
      final List<dynamic> branchDataList = branchData['data'];

      final List<OrdinalSales> salesData = [];

      for (var monthData in branchDataList) {
        salesData.add(OrdinalSales(
          monthData['month'].toString(),
          int.parse(monthData[graphFilterValue()].toString()),
        ));
      }
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
    setState(() {});
  }

  List randomColors = [];
  List<Map> filterList = [
    {"name": "Active Member's", "id": 1},
    {"name": "In-Active Member's", "id": 2},
    {"name": "Expense", "id": 3},
    {"name": "Visitor's", "id": 4},
  ];

  String graphFilterValue() {
    if (selectedFilter != null) {
      switch (selectedFilter['id']) {
        case 1:
          return "active";
        case 2:
          return "inactive";
        case 3:
          return "expense";
        case 4:
          return "visitors";

        default:
          return "active";
      }
    } else {
      return "active";
    }
  }

  String totalCount() {
    if (selectedFilter != null) {
      switch (selectedFilter['id']) {
        case 1:
          return "active";
        case 2:
          return "inactive";
        case 3:
          return "expense";
        case 4:
          return "visitors";

        default:
          return "active";
      }
    } else {
      return "active";
    }
  }

  @override
  void initState() {
    randomColors = generateGlobalRandomColors(widget.seriesList.length);
    selectedFilter = filterList.first;
    createSampleData(widget.seriesList);
    super.initState();
  }

  changeGraphonFilterChange() {
    createSampleData(widget.seriesList);
  }

  String value = '';
  var selectedFilter;
  @override
  Widget build(BuildContext context) {
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
                items: filterList.map(
                  (item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(
                        item['name'],
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
            seriesList,
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
                labelStyle: const charts.TextStyleSpec(
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
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: ListView.builder(
              itemCount: widget.seriesList.length,
              itemBuilder: ((context, index) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.17,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(BranchProfile.routeName,
                              arguments: widget.seriesList[index]['branch_id']);
                        },
                        child: Text(
                          '${widget.seriesList[index]['branch_name'].toString()} - View Details',
                          style: mat.TextStyle(
                              color: primaryColor,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.013,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.17,
                            child: FileInfoCard(
                              fieldName: "Active Member's",
                              value: widget.seriesList[index]
                                          ['yearly_active_member_count']
                                      ?.toString() ??
                                  '-',
                              svgSrc: 'assets/icon/people.png',
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.17,
                            child: FileInfoCard(
                              fieldName: "In-Active Member's",
                              value: widget.seriesList[index]
                                          ['yearly_in-active_member_count']
                                      ?.toString() ??
                                  '-',
                              svgSrc: 'assets/icon/people.png',
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.17,
                            child: FileInfoCard(
                              fieldName: "Total Visitors",
                              value: widget.seriesList[index]
                                          ['yearly_total_visitor_count']
                                      ?.toString() ??
                                  '-',
                              svgSrc: 'assets/icon/visitors.png',
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.17,
                            child: FileInfoCard(
                              fieldName: "Total Expense",
                              value: widget.seriesList[index]
                                          ['yearly_total_expense']
                                      ?.toString() ??
                                  '-',
                              svgSrc: 'assets/icon/budget.png',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              })),
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
