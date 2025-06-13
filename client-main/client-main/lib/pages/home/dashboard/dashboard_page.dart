import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mcm_app/api/api_dashboard_service.dart';
import 'package:mcm_app/api/models/api_dashboard_model.dart';
import 'package:mcm_app/pages/home/home_page.dart';
import 'package:mcm_app/pages/lobby/lobby_page.dart';
import 'package:mcm_app/storages/user_storage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesData {
  SalesData(this.category, this.sales, this.color);

  final String category;
  final double sales;
  final Color color;
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
    required this.homePageState,
  });

  final HomePageState homePageState;

  @override
  DashboardPageState createState() {
    return DashboardPageState();
  }
}

class DashboardPageState extends State<DashboardPage> {
  final ApiDashboardService apiDashboardService = ApiDashboardService();
  Future<ApiGetDashboardModel>? getDashboardFuture;
  ApiGetDashboardModel? apiGetDashboardModel;

  late List<SalesData> chartData;
  late double totalValue;
  late double monthlyAverage;

  bool isInit = false;

  @override
  void initState() {
    super.initState();
    refreshDashboard();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refreshDashboard() {
    setState(() {
      isInit = false;
      getDashboardFuture = apiDashboardService.getData(
        userId: UserStorage.userId,
        year: widget.homePageState.selectedYear,
      );
    });
  }

  Widget total() {
    Widget block(String title, int value) {
      return Container(
        width: 165.w,
        height: 70.h,
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: CupertinoColors.systemGrey5,
            width: 0.75.w,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.notoSansJp(
                textStyle: TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              "$value tCO2",
              style: GoogleFonts.notoSansJp(
                textStyle: TextStyle(
                  color: CupertinoColors.darkBackgroundGray,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.25.w,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: 1.sw,
      height: 110.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "總碳排放分析",
            style: GoogleFonts.notoSansJp(
              textStyle: TextStyle(
                color: CupertinoColors.darkBackgroundGray,
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.75.w,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              block("Year total", totalValue.floor()),
              block("Monthly average", monthlyAverage.floor()),
            ],
          ),
        ],
      ),
    );
  }

  Widget totalChart() {
    Widget chart(String title, double value, double maxValue) {
      return Container(
        width: 1.sw,
        height: 37.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.notoSansJp(
                    textStyle: TextStyle(
                      color: CupertinoColors.darkBackgroundGray,
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.35.w,
                    ),
                  ),
                ),
                Text(
                  value.toStringAsFixed(4),
                  style: GoogleFonts.notoSansJp(
                    textStyle: TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.35.w,
                    ),
                  ),
                ),
              ],
            ),
            LinearProgressIndicator(
              borderRadius: BorderRadius.circular(8.r),
              value: value / maxValue,
              backgroundColor: Color(0xFFecf4fb),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF448fda)),
              minHeight: 8.h,
            ),
          ],
        ),
      );
    }

    return Container(
      width: 1.sw,
      height: 280.h,
      padding: EdgeInsets.symmetric(
        vertical: 16.h,
        horizontal: 16.w,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: CupertinoColors.systemGrey5,
          width: 0.75.w,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: chartData
            .map(
              (data) => chart(data.category, data.sales, totalValue),
            )
            .toList(),
      ),
    );
  }

  Widget totalCircleChart() {
    Widget circleChart() {
      return SfCircularChart(
          legend: Legend(
            isVisible: true,
            position: LegendPosition.bottom,
            overflowMode: LegendItemOverflowMode.wrap,
            textStyle: TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.25.w,
            ),
          ),
          series: <DoughnutSeries<SalesData, String>>[
            DoughnutSeries<SalesData, String>(
              dataSource: chartData,
              pointColorMapper: (SalesData data, _) => data.color,
              xValueMapper: (SalesData data, _) => data.category,
              yValueMapper: (SalesData data, _) => data.sales,
              radius: '90%',
              innerRadius: '60%',
              dataLabelMapper: (SalesData data, _) {
                double total =
                    chartData.map((e) => e.sales).reduce((a, b) => a + b);
                double percentage = (data.sales / total) * 100;
                return '${percentage.toStringAsFixed(1)}%';
              },
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelPosition: ChartDataLabelPosition.outside,
                labelIntersectAction: LabelIntersectAction.none,
                labelAlignment: ChartDataLabelAlignment.auto,
                textStyle: TextStyle(
                  color: CupertinoColors.darkBackgroundGray,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.25.w,
                ),
              ),
            )
          ]);
    }

    return Container(
      width: 1.sw,
      height: 400.h,
      padding: EdgeInsets.symmetric(
        vertical: 16.h,
        horizontal: 16.w,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: CupertinoColors.systemGrey5,
          width: 0.75.w,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "年度總排放量",
            style: GoogleFonts.notoSansJp(
              textStyle: TextStyle(
                color: CupertinoColors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.75.w,
              ),
            ),
          ),
          circleChart(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: FutureBuilder<ApiGetDashboardModel>(
        future: getDashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.hexagonDots(
                color: const Color(0xFF448fda),
                size: 100.sp,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              apiGetDashboardModel = snapshot.data;

              if (!isInit) {
                isInit = true;
                setData();
              }

              if (totalValue == 0) {
                return Center(
                  child: Text(
                    "無資料",
                    style: GoogleFonts.notoSansJp(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.75.w,
                      ),
                    ),
                  ),
                );
              }

              return content();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
          }
          return Container();
        },
      ),
    );
  }

  void setData() {
    double electricity = apiGetDashboardModel!.electricity;
    double employee = apiGetDashboardModel!.employee;
    double gasoline = apiGetDashboardModel!.gasoline;
    double diesel = apiGetDashboardModel!.diesel;
    double refrigerant = apiGetDashboardModel!.refrigerant;

    chartData = [
      SalesData('電力排放量', electricity, Color(0xFF448fda)),
      SalesData('員工糞肥管理', employee, Color(0xFF5db5dc)),
      SalesData('汽油燃燒排放量', gasoline, Color(0xFFe3988f)),
      SalesData('柴油燃燒排放量', diesel, Color(0xFF7eb88e)),
      SalesData('冷媒逸散排放量', refrigerant, Color(0xFFd09ac7)),
    ];

    totalValue = electricity + employee + gasoline + diesel + refrigerant;
    monthlyAverage = totalValue / 12;
  }

  Widget content() {
    return Container(
      height: 1.sh,
      width: 1.sw,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 7.5.h),
              Divider(
                color: CupertinoColors.systemGrey5,
                thickness: 0.75.h,
                height: 0,
              ),
              SizedBox(height: 18.h),
              total(),
              SizedBox(height: 18.h),
              Divider(
                color: CupertinoColors.systemGrey5,
                thickness: 0.75.h,
                height: 0,
              ),
              SizedBox(height: 18.h),
              totalChart(),
              SizedBox(height: 36.h),
              totalCircleChart(),
              SizedBox(height: 60.h),
            ],
          ),
        ),
      ),
    );
  }
}
