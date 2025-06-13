import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDataTable extends StatefulWidget {
  const MyDataTable({
    super.key,
    required this.title,
    required this.data,
    required this.isChecks,
    this.onCheckTap,
    this.onRowTap,
  });

  final String title;
  final List<List<String>> data;
  final List<bool> isChecks;
  final Function(int index)? onCheckTap;
  final Function(int index)? onRowTap;

  @override
  MyDataTableState createState() {
    return MyDataTableState();
  }
}

class MyDataTableState extends State<MyDataTable> {
  Widget title() {
    return Text(
      widget.title,
      style: GoogleFonts.notoSansJp(
        textStyle: TextStyle(
          color: Colors.black,
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.75.w,
        ),
      ),
    );
  }

  Map<int, TableColumnWidth> generateColumnWidths(int numColumns) {
    if (numColumns < 2) return {0: FlexColumnWidth()};
    Map<int, TableColumnWidth> columnWidths = {
      0: IntrinsicColumnWidth(),
      numColumns - 1: IntrinsicColumnWidth(),
    };
    for (int i = 1; i < numColumns - 1; i++) {
      columnWidths[i] = FlexColumnWidth();
    }
    return columnWidths;
  }

  Widget table() {
    int length = widget.data[0].length;

    Widget cel(int rowIndex, int celIndex, String cell) {
      if (celIndex == 0 && rowIndex != 0) {
        return Checkbox(
          activeColor: const Color(0xFF448fda),
          value: widget.isChecks[rowIndex],
          onChanged: (bool? value) {
            setState(() {
              widget.onCheckTap?.call(rowIndex);
              widget.isChecks[rowIndex] = value!;
            });
          },
        );
      }

      if (celIndex == length - 1 && rowIndex != 0) {
        return Icon(
          Icons.more_horiz,
          color: CupertinoColors.systemGrey,
          size: 17.sp,
        );
      }

      return Text(
        cell,
        style: GoogleFonts.notoSansJp(
          textStyle: TextStyle(
            color: rowIndex == 0 ? CupertinoColors.systemGrey : Colors.black,
            fontSize: rowIndex == 0 ? 10.sp : 12.sp,
            fontWeight: celIndex == 1 && rowIndex != 0
                ? FontWeight.w600
                : FontWeight.w400,
            letterSpacing: 0.05.w,
          ),
        ),
      );
    }

    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(
        horizontal: 5.w,
      ),
      child: Material(
        child: Table(
          columnWidths: generateColumnWidths(length),
          children:
              widget.data.asMap().entries.map((entry) {
            int rowIndex = entry.key;
            List<String> row = entry.value;

            return TableRow(
              decoration: BoxDecoration(
                color: rowIndex % 2 != 0
                    ? CupertinoColors.systemGrey6
                    : Colors.white,
              ),
              children: row.asMap().entries.map((cellEntry) {
                int cellIndex = cellEntry.key;
                String cell = cellEntry.value;

                return TableRowInkWell(
                  onTap: () {
                    widget.onRowTap?.call(rowIndex);
                  },
                  child: Container(
                    height: 40.h,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 8.h),
                    child: cel(rowIndex, cellIndex, cell),
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title(),
          SizedBox(height: 15.h),
          table(),
        ],
      ),
    );
  }
}
