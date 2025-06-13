import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcm_app/api/api_electricity_service.dart';
import 'package:mcm_app/api/api_employee_service.dart';
import 'package:mcm_app/api/api_fuel_service.dart';
import 'package:mcm_app/api/api_refrigerant_service.dart';
import 'package:mcm_app/api/api_util.dart';
import 'package:mcm_app/api/models/api_model.dart';
import 'package:mcm_app/api/models/api_public_model.dart' as p;
import 'package:mcm_app/api/models/api_refrigerant_model.dart';
import 'package:mcm_app/pages/home/edit/widgets/edit_page_input.dart';
import 'package:mcm_app/pages/home/edit/widgets/edit_page_input_dropdown.dart';
import 'package:mcm_app/pages/home/electricity/electricity_page.dart';
import 'package:mcm_app/pages/home/employees/employees_page.dart';
import 'package:mcm_app/pages/home/fuels/fuels_page.dart';
import 'package:mcm_app/pages/home/home_page.dart';
import 'package:mcm_app/pages/home/refrigerant/refrigerant_page.dart';
import 'package:mcm_app/storages/user_storage.dart';
import 'package:mcm_app/widgets/loading_mask.dart';

enum EditPageType {
  electricity,
  employees,
  fuels,
  refrigerant,
  createRefrigerant,
}

class EditPage extends StatefulWidget {
  const EditPage({
    super.key,
    required this.editPageType,
    required this.title,
    required this.homePageState,
    this.electricityPageState,
    this.employeesPageState,
    this.fuelsPageState,
    this.refrigerantPageState,
  });

  final EditPageType editPageType;
  final String title;

  final HomePageState homePageState;
  final ElectricityPageState? electricityPageState;
  final EmployeesPageState? employeesPageState;
  final FuelsPageState? fuelsPageState;
  final RefrigerantPageState? refrigerantPageState;

  @override
  EditPageState createState() {
    return EditPageState();
  }
}

class EditPageState extends State<EditPage> {
  late TextEditingController controller1;
  late TextEditingController controller2;
  late TextEditingController controller3;
  late TextEditingController controller4;
  final GlobalKey<EditPageInputDropdownState> key1 = GlobalKey();
  final GlobalKey<EditPageInputDropdownState> key2 = GlobalKey();

  String? errorText1;
  String? errorText2;
  String? errorText3;
  String? errorText4;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    controller1 = TextEditingController();
    controller2 = TextEditingController();
    controller3 = TextEditingController();
    controller4 = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void init() {
    switch (widget.editPageType) {
      case EditPageType.electricity:
        ElectricityPageState state = widget.electricityPageState!;
        String month = ApiUtil.monthKey[state.modifyMonth];
        Map<dynamic, dynamic> electricity =
            state.apiElectricityModel!.electricity;
        controller1.text =
            electricity[month]!.electricityConsumption.toString();
        break;
      case EditPageType.employees:
        EmployeesPageState state = widget.employeesPageState!;
        String month = ApiUtil.monthKey[state.modifyMonth];
        Map<dynamic, dynamic> employee = state.apiEmployeeModel!.employee;
        controller1.text = employee[month]!.employeesCount.toString();
        controller2.text = employee[month]!.workingHoursPerDay.toString();
        controller3.text = employee[month]!.workingDaysPerMonth.toString();
        break;
      case EditPageType.fuels:
        FuelsPageState state = widget.fuelsPageState!;
        String month = ApiUtil.monthKey[state.modifyMonth];
        Map<dynamic, dynamic> fuel = state.apiGetFuelModel!.fuel;
        controller1.text = fuel[month]!.diesel.toString();
        controller2.text = fuel[month]!.gasoline.toString();
        break;
      case EditPageType.refrigerant:
        RefrigerantPageState state = widget.refrigerantPageState!;
        ApiGetRefrigerantModel model = state.apiGetRefrigerantModel!;
        Refrigerant r = model.refrigerant[state.modifyIndex];
        controller1.text = r.name!;
        controller2.text = r.count.toString();
        controller3.text = r.refrigerantSupplement.toString();
        controller4.text = r.useMonth.toString();

        List<p.DeviceType> deviceTypes =
            state.apiGetDeviceTypesModel!.deviceTypes;
        List<p.RefrigerantType> refrigerantTypes =
            state.apiGetRefrigerantTypesModel!.refrigerantTypes;

        key1.currentState!.select(
            deviceTypes.indexWhere((element) => element.id == r.deviceType));
        key2.currentState!.select(refrigerantTypes
            .indexWhere((element) => element.id == r.refrigerantType));
        break;
      default:
        break;
    }
  }

  void confirm() async {
    setState(() {
      isLoading = true;
    });

    switch (widget.editPageType) {
      case EditPageType.electricity:
        if (controller1.text.isEmpty) {
          setState(() {
            errorText1 = "用電度數不可為空";
            isLoading = false;
          });
          return;
        }

        ApiElectricityService apiElectricityService = ApiElectricityService();
        ApiModel apiModel = await apiElectricityService.updateElectricity(
          userId: UserStorage.userId,
          year: widget.homePageState.selectedYear,
          month: widget.electricityPageState!.modifyMonth + 1,
          electricityConsumption: double.parse(controller1.text),
        );

        if (apiModel.code != 0) {
          setState(() {
            errorText1 = "未知錯誤";
            isLoading = false;
          });
          return;
        }

        widget.electricityPageState!.refreshElectricity();
        widget.homePageState.refreshDashboard();
        Navigator.pop(context);
        break;
      case EditPageType.employees:
        if (controller1.text.isEmpty) {
          setState(() {
            errorText1 = "員工數不得為空";
            isLoading = false;
          });
          return;
        }

        if (controller2.text.isEmpty) {
          setState(() {
            errorText2 = "每日每人平均工時不得為空";
            isLoading = false;
          });
          return;
        }

        if (controller3.text.isEmpty) {
          setState(() {
            errorText3 = "月工作天數不得為空";
            isLoading = false;
          });
          return;
        }

        ApiEmployeeService apiEmployeeService = ApiEmployeeService();
        ApiModel apiModel = await apiEmployeeService.updateEmployee(
          userId: UserStorage.userId,
          year: widget.homePageState.selectedYear,
          month: widget.employeesPageState!.modifyMonth + 1,
          employeesCount: int.parse(controller1.text),
          workingHoursPerDay: double.parse(controller2.text),
          workingDaysPerMonth: double.parse(controller3.text),
        );

        if (apiModel.code != 0) {
          setState(() {
            errorText1 = "未知錯誤";
            isLoading = false;
          });
          return;
        }

        widget.employeesPageState!.refreshEmployee();
        widget.homePageState.refreshDashboard();
        Navigator.pop(context);
        break;
      case EditPageType.fuels:
        if (controller1.text.isEmpty) {
          setState(() {
            errorText1 = "柴油不可為空";
            isLoading = false;
          });
          return;
        }

        if (controller2.text.isEmpty) {
          setState(() {
            errorText2 = "汽油不可為空";
            isLoading = false;
          });
          return;
        }

        ApiFuelService apiFuelService = ApiFuelService();
        ApiModel apiModel = await apiFuelService.updateFuel(
          userId: UserStorage.userId,
          year: widget.homePageState.selectedYear,
          month: widget.fuelsPageState!.modifyMonth + 1,
          diesel: double.parse(controller1.text),
          gasoline: double.parse(controller2.text),
        );

        if (apiModel.code != 0) {
          setState(() {
            errorText1 = "未知錯誤";
            isLoading = false;
          });
          return;
        }

        widget.fuelsPageState!.refreshFuel();
        widget.homePageState.refreshDashboard();
        Navigator.pop(context);
        break;
      default:
        if (controller1.text.isEmpty) {
          setState(() {
            errorText1 = "設備名稱不得為空";
            isLoading = false;
          });
          return;
        }

        if (controller2.text.isEmpty) {
          setState(() {
            errorText2 = "數量不得為空";
            isLoading = false;
          });
          return;
        }

        if (controller3.text.isEmpty) {
          setState(() {
            errorText3 = "冷媒補充量不得為空";
            isLoading = false;
          });
          return;
        }

        if (controller4.text.isEmpty) {
          setState(() {
            errorText4 = "使用月數不得為空";
            isLoading = false;
          });
          return;
        }

        ApiRefrigerantService apiRefrigerantService = ApiRefrigerantService();
        late ApiModel apiModel;

        List<p.DeviceType> deviceTypes =
            widget.refrigerantPageState!.apiGetDeviceTypesModel!.deviceTypes;

        List<p.RefrigerantType> refrigerantTypes = widget.refrigerantPageState!
            .apiGetRefrigerantTypesModel!.refrigerantTypes;

        if (widget.editPageType == EditPageType.refrigerant) {
          List<Refrigerant> refrigerants =
              widget.refrigerantPageState!.apiGetRefrigerantModel!.refrigerant;

          apiModel = await apiRefrigerantService.updateRefrigerant(
            id: refrigerants[widget.refrigerantPageState!.modifyIndex].id!,
            userId: UserStorage.userId,
            name: controller1.text,
            count: int.parse(controller2.text),
            refrigerantSupplement: double.parse(controller3.text),
            useMonth: int.parse(controller4.text),
            deviceType: deviceTypes[key1.currentState!.selectedIndex].id!,
            refrigerantType:
                refrigerantTypes[key2.currentState!.selectedIndex].id!,
          );
        } else {
          apiModel = await apiRefrigerantService.createRefrigerant(
            userId: UserStorage.userId,
            year: widget.homePageState.selectedYear,
            name: controller1.text,
            count: int.parse(controller2.text),
            refrigerantSupplement: double.parse(controller3.text),
            useMonth: int.parse(controller4.text),
            deviceType: deviceTypes[key1.currentState!.selectedIndex].id!,
            refrigerantType:
                refrigerantTypes[key2.currentState!.selectedIndex].id!,
          );
        }

        if (apiModel.code != 0) {
          setState(() {
            errorText1 = "未知錯誤";
            isLoading = false;
          });
          return;
        }

        widget.refrigerantPageState!.refreshRefrigerant();
        widget.homePageState.refreshDashboard();
        Navigator.pop(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          content(),
          LoadingMask(isActive: isLoading),
        ],
      ),
    );
  }

  Widget content() {
    return Container(
      height: 1.sh,
      width: 1.sw,
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 50.h,
        bottom: 20.h,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          navBar(),
          SizedBox(height: 30.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: getForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget navBar() {
    TextStyle textStyle = GoogleFonts.notoSansJp(
      textStyle: TextStyle(
        color: CupertinoColors.link,
        fontSize: 17.sp,
        fontWeight: FontWeight.w500,
      ),
    );

    return Material(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              "取消",
              style: textStyle,
            ),
          ),
          InkWell(
            onTap: () async {
              confirm();
            },
            child: Text(
              "送出",
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget commonTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Month",
          style: GoogleFonts.notoSansJp(
            textStyle: TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          widget.title,
          style: GoogleFonts.notoSansJp(
            textStyle: TextStyle(
              color: CupertinoColors.darkBackgroundGray,
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> getForm() {
    switch (widget.editPageType) {
      case EditPageType.electricity:
        return [
          commonTitle(),
          SizedBox(height: 30.h),
          EditPageInput(
            keyboardType: TextInputType.number,
            title: "用電度數 (kWh)",
            controller: controller1,
            errorText: errorText1,
          ),
        ];
      case EditPageType.employees:
        return [
          commonTitle(),
          SizedBox(height: 30.h),
          EditPageInput(
            keyboardType: TextInputType.number,
            title: "員工數",
            controller: controller1,
            errorText: errorText1,
          ),
          SizedBox(height: 20.h),
          EditPageInput(
            keyboardType: TextInputType.number,
            title: "每日每人平均工時",
            controller: controller2,
            errorText: errorText2,
          ),
          SizedBox(height: 20.h),
          EditPageInput(
            keyboardType: TextInputType.number,
            title: "月工作天數",
            controller: controller3,
            errorText: errorText3,
          ),
        ];
      case EditPageType.fuels:
        return [
          commonTitle(),
          SizedBox(height: 30.h),
          EditPageInput(
            keyboardType: TextInputType.number,
            title: "柴油用量",
            controller: controller1,
            errorText: errorText1,
          ),
          SizedBox(height: 20.h),
          EditPageInput(
            keyboardType: TextInputType.number,
            title: "汽油用量",
            controller: controller2,
            errorText: errorText2,
          ),
        ];
      default:
        return [
          widget.editPageType == EditPageType.createRefrigerant
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "新增設備",
                    style: GoogleFonts.notoSansJp(
                      textStyle: TextStyle(
                        color: CupertinoColors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          SizedBox(height: 30.h),
          EditPageInput(
            keyboardType: TextInputType.text,
            title: "設備名稱",
            controller: controller1,
            errorText: errorText1,
          ),
          SizedBox(height: 20.h),
          EditPageInputDropdown(
            key: key1,
            title: "設備種類",
            items: widget
                .refrigerantPageState!.apiGetDeviceTypesModel!.deviceTypes
                .map((deviceType) => deviceType.name!)
                .toList(),
          ),
          SizedBox(height: 20.h),
          EditPageInput(
            keyboardType: TextInputType.number,
            title: "數量",
            controller: controller2,
            errorText: errorText2,
          ),
          SizedBox(height: 20.h),
          EditPageInputDropdown(
            key: key2,
            title: "冷媒型號",
            items: widget.refrigerantPageState!.apiGetRefrigerantTypesModel!
                .refrigerantTypes
                .map((refrigerantType) => refrigerantType.name!)
                .toList(),
          ),
          SizedBox(height: 20.h),
          EditPageInput(
            keyboardType: TextInputType.number,
            title: "冷媒補充輛 ( kg )",
            controller: controller3,
            errorText: errorText3,
          ),
          SizedBox(height: 20.h),
          EditPageInput(
            keyboardType: TextInputType.number,
            title: "使用月數",
            controller: controller4,
            errorText: errorText4,
          ),
        ];
    }

    return [];
  }
}
