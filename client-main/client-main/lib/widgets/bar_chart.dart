import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarChartData {
  BarChartData({
    required this.x,
    required this.y,
  });

  final String x;
  final List<double> y;
}

class BarChart extends StatelessWidget {
  BarChart({
    super.key,
    required this.title,
    required this.chartData,
    required this.names,
  });

  String title;
  List<BarChartData> chartData;
  List<String> names;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 380.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: CupertinoColors.systemGrey6,
          width: 1.w,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.notoSansJp(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 19.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.75.w,
              ),
            ),
          ),
          Spacer(),
          SfCartesianChart(
            primaryXAxis: CategoryAxis(
              labelRotation: 90,
            ),
            legend: Legend(
              isVisible: true,
              position: LegendPosition.top,
              overflowMode: LegendItemOverflowMode.wrap,
              alignment: ChartAlignment.near,
            ),
            series: List<StackedColumnSeries<BarChartData, String>>.generate(
              chartData[0].y.length,
              (int index) => StackedColumnSeries<BarChartData, String>(
                dataSource: chartData,
                xValueMapper: (BarChartData data, _) => data.x,
                yValueMapper: (BarChartData data, _) => data.y[index],
                name: names[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
