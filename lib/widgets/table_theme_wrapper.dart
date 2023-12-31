
import 'package:easy_table/easy_table.dart';
import 'package:flutter/material.dart';
import 'package:gmstest/configs/colors.dart';

class TableThemeWrapper extends StatefulWidget {
  final Widget table;

  final double contentHeight;

  const TableThemeWrapper({Key? key, required this.table, required this.contentHeight}) : super(key: key);

  @override
  State<TableThemeWrapper> createState() => _TableThemeWrapperState();
}

class _TableThemeWrapperState extends State<TableThemeWrapper> {
  @override
  Widget build(BuildContext context) {
    return EasyTableTheme(
      data: EasyTableThemeData(
        decoration: BoxDecoration(border: Border.all(color: Colors.transparent), color: Colors.white),
        header: const HeaderThemeData(
          color: secondaryDarkBlueColor,
          columnDividerColor: Colors.transparent,
          bottomBorderColor: Colors.transparent,
        ),
        headerCell: HeaderCellThemeData(
          height: 48,
          textStyle: TextStyle(
            color: primaryDarkBlueColor,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.visible,
            fontSize: MediaQuery.of(context).size.width * 0.01,
          ),
          padding: const EdgeInsets.all(8),
        ),
        cell: CellThemeData(
          contentHeight: widget.contentHeight,
          overflow: TextOverflow.visible,
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.009,
          ),
        ),
        columnDividerColor: Colors.transparent,
        row: const RowThemeData(dividerColor: secondaryBorderGreyColor, fillHeight: true),
      ),
      child: widget.table,
    );
  }
}
