import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mcm_app/api/api_public_service.dart';
import 'package:mcm_app/api/api_refrigerant_service.dart';
import 'package:mcm_app/api/models/api_public_model.dart' as p;
import 'package:mcm_app/api/models/api_refrigerant_model.dart';
import 'package:mcm_app/pages/home/edit/edit_page.dart';
import 'package:mcm_app/pages/home/home_page.dart';
import 'package:mcm_app/storages/user_storage.dart';
import 'package:mcm_app/widgets/bar_chart.dart';
import 'package:mcm_app/widgets/my_data_table.dart';

class RefrigerantPage extends StatefulWidget {
  const RefrigerantPage({
    super.key,
    required this.homePageState,
  });

  final HomePageState homePageState;

  @override
  RefrigerantPageState createState() {
    return RefrigerantPageState();
  }
}

class RefrigerantPageState extends State<RefrigerantPage> {
  final ApiPublicService apiPublicService = ApiPublicService();
  final ApiRefrigerantService apiRefrigerantService = ApiRefrigerantService();

  Future<p.ApiGetDeviceTypesModel>? getDeviceTypesFuture;
  Future<p.ApiGetRefrigerantTypesModel>? getRefrigerantTypesFuture;
  Future<ApiGetRefrigerantModel>? getRefrigerantFuture;

  p.ApiGetDeviceTypesModel? apiGetDeviceTypesModel;
  p.ApiGetRefrigerantTypesModel? apiGetRefrigerantTypesModel;
  ApiGetRefrigerantModel? apiGetRefrigerantModel;

  late List<List<String>> data;
  late List<bool> isChecks;

  bool isInit = false;
  int modifyIndex = 0;

  @override
  void initState() {
    super.initState();
    refreshRefrigerant();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refreshRefrigerant() {
    setState(() {
      isInit = false;
      getDeviceTypesFuture = apiPublicService.getDeviceTypes();
      getRefrigerantTypesFuture = apiPublicService.getRefrigerantTypes();
      getRefrigerantFuture = apiRefrigerantService.getRefrigerant(
        userId: UserStorage.userId,
        year: widget.homePageState.selectedYear,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          getRefrigerantFuture ?? Future.value(null),
          getDeviceTypesFuture ?? Future.value(null),
          getRefrigerantTypesFuture ?? Future.value(null),
        ]),
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
              List<dynamic> data = snapshot.data!;

              apiGetRefrigerantModel = data[0] as ApiGetRefrigerantModel;
              apiGetDeviceTypesModel = data[1] as p.ApiGetDeviceTypesModel;
              apiGetRefrigerantTypesModel =
                  data[2] as p.ApiGetRefrigerantTypesModel;

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
    List<Refrigerant> refrigerant = apiGetRefrigerantModel!.refrigerant;
    List<List<String>> newData = [];

    newData.add(["", "設備名稱", "冷媒型號", "冷媒補充量", "使用月數", ""]);

    for (int i = 0; i < refrigerant.length; i++) {
      Refrigerant r = refrigerant[i];

      newData.add([
        "",
        r.name!,
        getRefrigerantTypeName(r.refrigerantType!),
        "${r.refrigerantSupplement} kg",
        "${r.useMonth} 月",
        "",
      ]);
    }

    data = newData;

    isChecks = List.generate(
      newData.length,
      (index) => true,
    );
  }

  String getRefrigerantTypeName(int id) {
    List<p.RefrigerantType> data =
        apiGetRefrigerantTypesModel!.refrigerantTypes;

    for (int i = 0; i < data.length; i++) {
      if (data[i].id == id) {
        return data[i].name!;
      }
    }

    return "";
  }

  String getDeviceTypeName(int id) {
    List<p.DeviceType> data = apiGetDeviceTypesModel!.deviceTypes;

    for (int i = 0; i < data.length; i++) {
      if (data[i].id == id) {
        return data[i].name!;
      }
    }

    return "";
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
                title: "冷媒設備管理表",
                data: data,
                isChecks: isChecks,
                onCheckTap: (index) {
                  setState(() {
                    isChecks[index] = !isChecks[index];
                  });
                },
                onRowTap: (index) {
                  modifyIndex = index - 1;
                  widget.homePageState.goEdit(
                    editPageType: EditPageType.refrigerant,
                    title: data[index][1],
                    refrigerantPageState: this,
                  );
                },
              ),
              SizedBox(height: 15.h),
              apiGetRefrigerantModel!.refrigerant.isEmpty
                  ? Container()
                  : BarChart(
                      title: "冷媒逸散排放量",
                      chartData: apiGetRefrigerantModel!.refrigerant
                          .asMap()
                          .entries
                          .where((indexedEntry) {
                        return isChecks[indexedEntry.key + 1];
                      }).map(
                        (indexedEntry) {
                          final refrigerantItem = indexedEntry.value;
                          return BarChartData(
                            x: refrigerantItem.name!,
                            y: [refrigerantItem.value!],
                          );
                        },
                      ).toList(),
                      names: ["排放量"],
                    ),
              SizedBox(height: 15.h),
              Container(
                height: 50.h,
                width: 1.sw,
                child: CupertinoButton(
                  color: const Color(0xFF448fda),
                  borderRadius: BorderRadius.circular(25.r),
                  child: Text(
                    "新增設備",
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                  onPressed: () {
                    widget.homePageState.goEdit(
                      editPageType: EditPageType.createRefrigerant,
                      title: "新增冷媒設備",
                      refrigerantPageState: this,
                    );
                  },
                ),
              ),
              SizedBox(height: 75.h),
            ],
          ),
        ),
      ),
    );
  }
}
