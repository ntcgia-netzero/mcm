import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mcm_app/api/api_fuel_service.dart';
import 'package:mcm_app/api/api_util.dart';
import 'package:mcm_app/api/models/api_fuel_model.dart';
import 'package:mcm_app/pages/home/edit/edit_page.dart';
import 'package:mcm_app/pages/home/home_page.dart';
import 'package:mcm_app/storages/user_storage.dart';
import 'package:mcm_app/widgets/bar_chart.dart';
import 'package:mcm_app/widgets/my_data_table.dart';
import 'package:mcm_app/widgets/nav_bar.dart';

class FuelsPage extends StatefulWidget {
  const FuelsPage({
    super.key,
    required this.homePageState,
  });

  final HomePageState homePageState;

  @override
  FuelsPageState createState() {
    return FuelsPageState();
  }
}

class FuelsPageState extends State<FuelsPage> {
  final ApiFuelService apiFuelService = ApiFuelService();
  Future<ApiGetFuelModel>? getGetFuelFuture;
  ApiGetFuelModel? apiGetFuelModel;

  late List<bool> isChecks;
  late List<List<String>> data;

  bool isInit = false;
  int modifyMonth = 0;

  @override
  void initState() {
    super.initState();
    refreshFuel();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refreshFuel() {
    setState(() {
      isInit = false;
      getGetFuelFuture = apiFuelService.getFuel(
        userId: UserStorage.userId,
        year: widget.homePageState.selectedYear,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: FutureBuilder<ApiGetFuelModel>(
        future: getGetFuelFuture,
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
              apiGetFuelModel = snapshot.data;

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
    Map fuel = apiGetFuelModel!.fuel;
    List<List<String>> newData = [];

    newData.add(["", "Month", "柴油", "汽油", ""]);

    for (int i = 0; i < ApiUtil.monthKey.length; i++) {
      String key = ApiUtil.monthKey[i];
      Fuel f = fuel[key];

      newData.add([
        "",
        key.substring(0, 3),
        "${f.diesel} L",
        "${f.gasoline} L",
        "",
      ]);
    }

    print(newData);

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
                title: "燃料使用管理表",
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
                    editPageType: EditPageType.fuels,
                    title: data[index][1],
                    fuelsPageState: this,
                  );
                },
              ),
              SizedBox(height: 15.h),
              BarChart(
                title: "燃燒排放量",
                chartData: apiGetFuelModel!.fuel.entries
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
                      y: [
                        entry.value.dieselValue!,
                        entry.value.gasolineValue!,
                      ],
                    );
                  },
                ).toList(),
                names: ["柴油", "汽油"],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
