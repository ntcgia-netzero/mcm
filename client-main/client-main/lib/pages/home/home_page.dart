import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mcm_app/api/api_public_service.dart';
import 'package:mcm_app/api/models/api_public_model.dart';
import 'package:mcm_app/icons/my_flutter_app_icons.dart';
import 'package:mcm_app/pages/home/dashboard/dashboard_page.dart';
import 'package:mcm_app/pages/home/edit/edit_page.dart';
import 'package:mcm_app/pages/home/electricity/electricity_page.dart';
import 'package:mcm_app/pages/home/employees/employees_page.dart';
import 'package:mcm_app/pages/home/fuels/fuels_page.dart';
import 'package:mcm_app/pages/home/refrigerant/refrigerant_page.dart';
import 'package:mcm_app/pages/home/year_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ElectricityPageState> electricityKey =
      GlobalKey<ElectricityPageState>();
  final GlobalKey<EmployeesPageState> employeesKey =
      GlobalKey<EmployeesPageState>();
  final GlobalKey<FuelsPageState> fuelsKey = GlobalKey<FuelsPageState>();
  final GlobalKey<RefrigerantPageState> refrigerantKey =
      GlobalKey<RefrigerantPageState>();
  final GlobalKey<DashboardPageState> dashboardKey =
      GlobalKey<DashboardPageState>();

  final ApiPublicService apiPublicService = ApiPublicService();
  Future<ApiGetYearsModel>? getYearsFuture;
  ApiGetYearsModel? apiGetYearsModel;
  int selectedYear = 0;

  int _selectedIndex = 0;
  String _appbarTitle = "MCM";

  GlobalKey<SliderDrawerState> key = GlobalKey<SliderDrawerState>();

  bool isInit = false;

  @override
  void initState() {
    super.initState();
    _setAppbarTitle();
    refreshYears();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refreshAll() {
    electricityKey.currentState?.refreshElectricity();
    employeesKey.currentState?.refreshEmployee();
    fuelsKey.currentState?.refreshFuel();
    refrigerantKey.currentState?.refreshRefrigerant();
    dashboardKey.currentState?.refreshDashboard();
  }

  void refreshDashboard(){
    dashboardKey.currentState?.refreshDashboard();
  }

  void refreshYears() {
    setState(() {
      getYearsFuture = apiPublicService.getYears();
    });
  }

  void selectYear(int year) {
    setState(() {
      selectedYear = year;
      refreshAll();
      key.currentState?.closeSlider();
    });
  }

  void goEdit({
    required EditPageType editPageType,
    required String title,
    ElectricityPageState? electricityPageState,
    EmployeesPageState? employeesPageState,
    FuelsPageState? fuelsPageState,
    RefrigerantPageState? refrigerantPageState,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPage(
          title: title,
          editPageType: editPageType,
          homePageState: this,
          electricityPageState: electricityPageState,
          employeesPageState: employeesPageState,
          fuelsPageState: fuelsPageState,
          refrigerantPageState: refrigerantPageState,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ApiGetYearsModel>(
        future: getYearsFuture,
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
              if (!isInit) {
                apiGetYearsModel = snapshot.data;
                selectedYear = apiGetYearsModel!.years[0];
              }

              isInit = true;

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

  Widget content() {
    return SliderDrawer(
      key: key,
      appBar: SliderAppBar(
        appBarColor: const Color(0xFF448fda),
        appBarHeight: 100.h,
        appBarPadding: EdgeInsets.only(top: 50.h),
        isTitleCenter: true,
        drawerIconColor: Colors.white,
        title: Text(
          _appbarTitle,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      slider: YearMenu(homePageState: this),
      sliderOpenSize: 200.w,
      child: CupertinoPageScaffold(
        child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(MyFlutterApp.flash_outline, size: 20.sp),
                label: 'Electricity',
              ),
              BottomNavigationBarItem(
                icon: Icon(MyFlutterApp.user_friends, size: 20.sp),
                label: 'Employees',
              ),
              BottomNavigationBarItem(
                icon: Icon(MyFlutterApp.flame, size: 20.sp),
                label: 'Fuels',
              ),
              BottomNavigationBarItem(
                icon: Icon(MyFlutterApp.snowflake, size: 20.sp),
                label: 'Refrigerant',
              ),
              BottomNavigationBarItem(
                icon: Icon(MyFlutterApp.chart_pie, size: 20.sp),
                label: 'Dashboard',
              ),
            ],
            onTap: _onItemTapped,
            currentIndex: _selectedIndex,
          ),
          tabBuilder: (context, index) {
            return CupertinoTabView(
              builder: (context) {
                switch (index) {
                  case 0:
                    return ElectricityPage(
                      key: electricityKey,
                      homePageState: this,
                    );
                  case 1:
                    return EmployeesPage(
                      key: employeesKey,
                      homePageState: this,
                    );
                  case 2:
                    return FuelsPage(
                      key: fuelsKey,
                      homePageState: this,
                    );
                  case 3:
                    return RefrigerantPage(
                      key: refrigerantKey,
                      homePageState: this,
                    );
                  case 4:
                    return DashboardPage(
                      key: dashboardKey,
                      homePageState: this,
                    );
                  default:
                    return CupertinoPageScaffold(
                        child: Center(child: Text('页面不存在')));
                }
              },
            );
          },
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _setAppbarTitle();
    });
  }

  void _setAppbarTitle() {
    switch (_selectedIndex) {
      case 0:
        _appbarTitle = "電力使用管理";
        break;
      case 1:
        _appbarTitle = "員工工時管理";
        break;
      case 2:
        _appbarTitle = "月用油量管理";
        break;
      case 3:
        _appbarTitle = "空調設備";
        break;
      case 4:
        _appbarTitle = "碳排放總覽";
        break;
      default:
        _appbarTitle = "MCM";
    }
  }
}
