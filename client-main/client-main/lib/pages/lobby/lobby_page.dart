import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcm_app/api/api_public_service.dart';
import 'package:mcm_app/api/models/api_public_model.dart';
import 'package:mcm_app/pages/home/edit/widgets/edit_page_input.dart';
import 'package:mcm_app/pages/home/home_page.dart';
import 'package:mcm_app/pages/lobby/register_page.dart';
import 'package:mcm_app/storages/user_storage.dart';
import 'package:mcm_app/widgets/loading_mask.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({super.key});

  @override
  LobbyPageState createState() {
    return LobbyPageState();
  }
}

class LobbyPageState extends State<LobbyPage> {
  final ApiPublicService apiPublicService = ApiPublicService();

  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;
  String? accountError;
  String? passwordError;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool checkForm() {
    if (_accountController.text.isEmpty) {
      setState(() {
        accountError = "帳號不可為空";
        isLoading = false;
      });
      return false;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        passwordError = "密碼不可為空";
        isLoading = false;
      });
      return false;
    }

    return true;
  }

  Future<void> login() async {
    setState(() {
      isLoading = true;
      accountError = null;
      passwordError = null;
    });

    if (!checkForm()) return;

    ApiLoginModel apiLoginModel = await apiPublicService.login(
      account: _accountController.text,
      password: _passwordController.text,
    );

    if (apiLoginModel.apiModel.code != 0) {
      String? accountError;
      String? passwordError;

      if (apiLoginModel.apiModel.code == 1) {
        accountError = apiLoginModel.apiModel.message;
      }

      if (apiLoginModel.apiModel.code == 2) {
        passwordError = apiLoginModel.apiModel.message;
      }

      if (accountError == null && passwordError == null) {
        accountError = "未知錯誤";
      }

      setState(() {
        isLoading = false;
        this.accountError = accountError;
        this.passwordError = passwordError;
      });

      return;
    }

    setState(() {
      isLoading = false;
    });

    UserStorage.userId = apiLoginModel.userId!;
    UserStorage.token = apiLoginModel.token!;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  Widget logo() {
    TextStyle textStyle = GoogleFonts.notoSansJp(
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 45.sp,
        fontWeight: FontWeight.w900,
      ),
    );

    return Container(
      height: 300.h,
      width: 1.sw,
      color: const Color(0xFF448fda),
      child: Padding(
        padding: EdgeInsets.only(
          left: 25.w,
          right: 25.w,
          top: 50.h,
          bottom: 25.h,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Micro",
              style: textStyle,
            ),
            Text(
              "Carbon",
              style: textStyle,
            ),
            Text(
              "Management",
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget form() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          EditPageInput(
            keyboardType: TextInputType.text,
            title: "帳號",
            controller: _accountController,
            errorText: accountError,
          ),
          SizedBox(height: 20.h),
          EditPageInput(
            keyboardType: TextInputType.text,
            title: "密碼",
            controller: _passwordController,
            errorText: passwordError,
            isPassword: true,
          ),
          SizedBox(height: 60.h),
          Container(
            width: 150.w,
            height: 50.h,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(25.r),
              color: Color(0xFF448fda),
              onPressed: () async {
                await login();
              },
              child: Text(
                "登入",
                style: GoogleFonts.notoSansJp(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.75.w,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            width: 150.w,
            height: 50.h,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(25.r),
              color: CupertinoColors.systemGrey,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(),
                  ),
                );
              },
              child: Text(
                "註冊",
                style: GoogleFonts.notoSansJp(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.75.w,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                logo(),
                SizedBox(height: 50.h),
                form(),
              ],
            ),
          ),
          LoadingMask(isActive: isLoading),
        ],
      ),
    );
  }
}
