import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mcm_app/api/api_employee_service.dart';
import 'package:mcm_app/api/api_util.dart';
import 'package:mcm_app/api/models/api_employee_model.dart';
import 'package:mcm_app/api/models/api_employee_model.dart';
import 'package:mcm_app/pages/home/edit/edit_page.dart';
import 'package:mcm_app/pages/home/home_page.dart';
import 'package:mcm_app/storages/user_storage.dart';
import 'package:mcm_app/widgets/bar_chart.dart';
import 'package:mcm_app/widgets/my_data_table.dart';
import 'package:mcm_app/widgets/nav_bar.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({
    super.key,
    required this.homePageState,
  });

  final HomePageState homePageState;

  @override
  EmployeesPageState createState() {
    return EmployeesPageState();
  }
}

class EmployeesPageState extends State<EmployeesPage> {
  final ApiEmployeeService apiEmployeeService = ApiEmployeeService();
  Future<ApiGetEmployeeModel>? getEmployeeFuture;
  ApiGetEmployeeModel? apiEmployeeModel;

  late List<bool> isChecks;
  late List<List<String>> data;

  bool isInit = false;
  int modifyMonth = 0;

  @override
  void initState() {
    super.initState();

    data = [
      ["", "MONTH", "用電度數", ""],
      ["", "January", "5 度", ""],
      ["", "February", "1 度", ""],
    ];

    isChecks = List.generate(data.length, (index) => true);
    refreshEmployee();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refreshEmployee() {
    setState(() {
      isInit = false;
      getEmployeeFuture = apiEmployeeService.getEmployee(
        userId: UserStorage.userId,
        year: widget.homePageState.selectedYear,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: FutureBuilder<ApiGetEmployeeModel>(
        future: getEmployeeFuture,
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
              apiEmployeeModel = snapshot.data;

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
    Map employee = apiEmployeeModel!.employee;
    List<List<String>> newData = [];

    newData.add(["", "Month", "用電度數", "每日工時", "月工作天數", ""]);

    for (int i = 0; i < ApiUtil.monthKey.length; i++) {
      String key = ApiUtil.monthKey[i];
      Employee e = employee[key];

      newData.add([
        "",
        key.substring(0, 3),
        "${e.employeesCount} 人",
        "${e.workingHoursPerDay} hr",
        "${e.workingDaysPerMonth} 天",
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
                title: "員工工時管理表",
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
                    editPageType: EditPageType.employees,
                    title: data[index][1],
                    employeesPageState: this,
                  );
                },
              ),
              SizedBox(height: 15.h),
              BarChart(
                title: "員工糞肥管理",
                chartData: apiEmployeeModel!.employee.entries
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
