import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcm_app/api/api_service.dart';
import 'package:mcm_app/pages/home/home_page.dart';
import 'package:mcm_app/storages/user_storage.dart';

class YearMenu extends StatelessWidget {
  const YearMenu({
    super.key,
    required this.homePageState,
  });

  final HomePageState homePageState;

  Widget head() {
    return Text(
      homePageState.selectedYear.toString(),
      style: GoogleFonts.notoSansJp(
        textStyle: TextStyle(
          color: Colors.black,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5.w,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFebeff0),
      padding: EdgeInsets.only(
        top: 60.h,
        left: 16.w,
        right: 16.w,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              head(),
              SizedBox(height: 13.h),
              Divider(
                height: 0,
                color: CupertinoColors.systemGrey,
              ),
              SizedBox(height: 13.h),
              SingleChildScrollView(
                child: Column(
                  children: homePageState.apiGetYearsModel!.years.map(
                    (year) {
                      return InkWell(
                        onTap: () {
                          if (year == homePageState.selectedYear) {
                            return;
                          }

                          homePageState.selectYear(year);
                        },
                        child: Container(
                          height: 35.h,
                          child: Text(
                            year.toString(),
                            style: GoogleFonts.notoSansJp(
                              textStyle: TextStyle(
                                color: homePageState.selectedYear == year
                                    ? CupertinoColors.activeBlue
                                    : Colors.black,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50.h,
                width: 1.sw,
                child: CupertinoButton(
                  color: CupertinoColors.systemGrey,
                  borderRadius: BorderRadius.circular(7.5.r),
                  child: Text(
                    "登出",
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                height: 50.h,
                width: 1.sw,
                child: CupertinoButton(
                  color: CupertinoColors.systemRed,
                  borderRadius: BorderRadius.circular(7.5.r),
                  child: Text(
                    "刪除",
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                  onPressed: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog(
                        title: Text('確認刪除'),
                        content: Text('您確定要刪除帳號嗎？此操作無法復原'),
                        actions: [
                          CupertinoDialogAction(
                            child: Text('取消'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            child: Text('刪除'),
                            onPressed: () async {
                              ApiService apiService = ApiService();
                              await apiService.deleteUser(
                                userId: UserStorage.userId,
                              );
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ],
      ),
    );
  }
}
