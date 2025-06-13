import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mcm_app/api/api_electricity_service.dart';
import 'package:mcm_app/api/api_util.dart';
import 'package:mcm_app/api/models/api_electricity_model.dart';
import 'package:mcm_app/pages/home/edit/edit_page.dart';
import 'package:mcm_app/pages/home/home_page.dart';
import 'package:mcm_app/storages/user_storage.dart';
import 'package:mcm_app/widgets/bar_chart.dart';
import 'package:mcm_app/widgets/my_data_table.dart';

class ElectricityPage extends StatefulWidget {
  const ElectricityPage({
    super.key,
    required this.homePageState,
  });

  final HomePageState homePageState;

  @override
  ElectricityPageState createState() {
    return ElectricityPageState();
  }
}

class ElectricityPageState extends State<ElectricityPage> {
  final ApiElectricityService apiElectricityService = ApiElectricityService();
  Future<ApiGetElectricityModel>? getElectricityFuture;
  ApiGetElectricityModel? apiElectricityModel;

  late List<bool> isChecks;
  late List<List<String>> data;

  bool isInit = false;
  int modifyMonth = 0;

  @override
  void initState() {
    super.initState();
    refreshElectricity();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refreshElectricity() {
    setState(() {
      isInit = false;
      getElectricityFuture = apiElectricityService.getElectricity(
        userId: UserStorage.userId,
        year: widget.homePageState.selectedYear,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: FutureBuilder<ApiGetElectricityModel>(
        future: getElectricityFuture,
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
              apiElectricityModel = snapshot.data;

              if (!isInit) {
                isInit = true;
                setData();
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
    Map electricity = apiElectricityModel!.electricity;
    List<List<String>> newData = [];

    newData.add(["", "Month", "用電度數", ""]);

    for (int i = 0; i < ApiUtil.monthKey.length; i++) {
      String key = ApiUtil.monthKey[i];
      Electricity e = electricity[key];

      newData.add([
        "",
        key.substring(0, 3),
        "${e.electricityConsumption} 度" ,
        "",
      ]);
    }

    data = newData;

    isChecks = List.generate(
      newData.length,
      (index) => true,
    );
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
            children: [
              MyDataTable(
                title: "電力使用管理",
                data: data,
                isChecks: isChecks,
                onCheckTap: (index) {
                  setState(() {
                    isChecks[index] = !isChecks[index];
                  });
                },
                onRowTap: (index) {
                  modifyMonth = index - 1;
                  widget.homePageState.goEdit(
                    editPageType: EditPageType.electricity,
                    title: data[index][1],
                    electricityPageState: this,
                  );
                },
              ),
              SizedBox(height: 15.h),
              BarChart(
                title: "電力排放量",
                chartData: apiElectricityModel!.electricity.entries
                    .toList()
                    .asMap()
                    .entries
                    .where((indexedEntry) {
                  return isChecks[indexedEntry.key + 1];
                }).map(
                  (indexedEntry) {
                    final entry = indexedEntry.value;
                    return BarChartData(
                      x: entry.key.substring(0, 3).toUpperCase(),
                      y: [entry.value.value!],
                    );
                  },
                ).toList(),
                names: const ["排放量"],
              ),
              SizedBox(height: 75.h),
            ],
          ),
        ),
      ),
    );
  }
}
