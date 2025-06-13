import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mcm_app/api/api_public_service.dart';
import 'package:mcm_app/api/models/api_model.dart';
import 'package:mcm_app/api/models/api_public_model.dart';
import 'package:mcm_app/pages/home/edit/widgets/edit_page_input.dart';
import 'package:mcm_app/pages/home/edit/widgets/edit_page_input_dropdown.dart';
import 'package:mcm_app/widgets/loading_mask.dart';
import 'package:mcm_app/widgets/nav_bar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  final ApiPublicService apiPublicService = ApiPublicService();
  Future<ApiGetIndustryTypesModel>? industryTypeFuture;
  ApiGetIndustryTypesModel? apiGetIndustryTypesModel;

  late TextEditingController accountController;
  late TextEditingController passwordController;
  late TextEditingController shopNameController;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController zipCodeController;
  late TextEditingController areaController;
  late TextEditingController addressController;
  final GlobalKey<EditPageInputDropdownState> dropdown = GlobalKey();

  String? accountError;
  String? passwordError;
  String? shopNameError;
  String? nameError;
  String? phoneError;
  String? emailError;
  String? zipCodeError;
  String? areaError;
  String? addressError;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    accountController = TextEditingController();
    passwordController = TextEditingController();
    shopNameController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    zipCodeController = TextEditingController();
    areaController = TextEditingController();
    addressController = TextEditingController();

    refreshIndustryTypes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refreshIndustryTypes() {
    setState(() {
      industryTypeFuture = apiPublicService.getIndustryTypes();
    });
  }

  Future<void> register() async {
    setState(() {
      isLoading = true;
      accountError = null;
      passwordError = null;
      shopNameError = null;
      nameError = null;
      phoneError = null;
      emailError = null;
      zipCodeError = null;
      areaError = null;
      addressError = null;
    });

    if (accountController.text.isEmpty) {
      setState(() {
        isLoading = false;
        accountError = "帳號不可為空";
      });
      return;
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        isLoading = false;
        passwordError = "密碼不可為空";
      });
      return;
    }

    if (shopNameController.text.isEmpty) {
      setState(() {
        isLoading = false;
        shopNameError = "店家名稱不可為空";
      });
      return;
    }

    if (nameController.text.isEmpty) {
      setState(() {
        isLoading = false;
        nameError = "負責人不可為空";
      });
      return;
    }

    if (phoneController.text.isEmpty) {
      setState(() {
        isLoading = false;
        phoneError = "連絡電話不可為空";
      });
      return;
    }

    if (emailController.text.isEmpty) {
      setState(() {
        isLoading = false;
        emailError = "EMAIL不可為空";
      });
      return;
    }

    if (zipCodeController.text.isEmpty) {
      setState(() {
        isLoading = false;
        zipCodeError = "郵遞區號不可為空";
      });
      return;
    }

    if (areaController.text.isEmpty) {
      setState(() {
        isLoading = false;
        areaError = "地區不可為空";
      });
      return;
    }

    if (addressController.text.isEmpty) {
      setState(() {
        isLoading = false;
        addressError = "地址不可為空";
      });
      return;
    }

    ApiModel apiModel = await apiPublicService.register(
      account: accountController.text,
      password: passwordController.text,
      shopName: shopNameController.text,
      phone: phoneController.text,
      industryType: apiGetIndustryTypesModel!
              .industryTypes[dropdown.currentState!.selectedIndex].id ??
          1,
      email: emailController.text,
      postalCode: zipCodeController.text,
      region: areaController.text,
      address: addressController.text,
    );

    if (apiModel.code != 0) {
      String? accountError;

      if (apiModel.code == 1) {
        accountError = apiModel.message;
      }

      if (accountError == null && passwordError == null) {
        accountError = "未知錯誤";
      }

      setState(() {
        isLoading = false;
        this.accountError = accountError;
      });

      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        height: 1.sh,
        width: 1.sw,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                NavBar(
                  title: "註冊",
                  onPressed: () async {
                    await register();
                  },
                ),
                Expanded(
                  child: content(),
                ),
              ],
            ),
            LoadingMask(
              isActive: isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget content() {
    return FutureBuilder<ApiGetIndustryTypesModel>(
      future: industryTypeFuture,
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
            apiGetIndustryTypesModel = snapshot.data;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SingleChildScrollView(
                child: Column(
                  children: form(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
        }
        return Container();
      },
    );
  }

  List<Widget> form() {
    return [
      SizedBox(height: 30.h),
      EditPageInput(
        keyboardType: TextInputType.text,
        title: "帳號",
        controller: accountController,
        errorText: accountError,
      ),
      SizedBox(height: 15.h),
      EditPageInput(
        keyboardType: TextInputType.text,
        title: "密碼",
        controller: passwordController,
        errorText: passwordError,
        isPassword: true,
      ),
      SizedBox(height: 15.h),
      EditPageInput(
        keyboardType: TextInputType.text,
        title: "店家名稱",
        controller: shopNameController,
        errorText: shopNameError,
      ),
      SizedBox(height: 15.h),
      EditPageInput(
        keyboardType: TextInputType.text,
        title: "負責人",
        controller: nameController,
        errorText: nameError,
      ),
      SizedBox(height: 15.h),
      EditPageInput(
        keyboardType: TextInputType.number,
        title: "連絡電話",
        controller: phoneController,
        errorText: phoneError,
      ),
      SizedBox(height: 15.h),
      EditPageInputDropdown(
        key: dropdown,
        title: "行業別",
        items: apiGetIndustryTypesModel!.industryTypes
            .map((type) => type.name ?? '')
            .toList(),
      ),
      SizedBox(height: 15.h),
      EditPageInput(
        keyboardType: TextInputType.emailAddress,
        title: "EMAIL",
        controller: emailController,
        errorText: emailError,
      ),
      SizedBox(height: 15.h),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: EditPageInput(
              keyboardType: TextInputType.number,
              title: "郵遞區號",
              controller: zipCodeController,
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: EditPageInput(
              keyboardType: TextInputType.text,
              title: "地區",
              controller: areaController,
            ),
          ),
        ],
      ),
      SizedBox(height: 15.h),
      EditPageInput(
        keyboardType: TextInputType.streetAddress,
        title: "地址",
        controller: addressController,
        errorText: addressError,
      ),
      SizedBox(height: 30.h),
    ];
  }
}
