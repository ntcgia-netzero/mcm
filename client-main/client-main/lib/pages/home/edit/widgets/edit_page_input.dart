import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class EditPageInput extends StatefulWidget {
  const EditPageInput({
    super.key,
    required this.keyboardType,
    required this.title,
    required this.controller,
    this.errorText,
    this.isPassword = false,
  });

  final TextInputType keyboardType;
  final String title;
  final TextEditingController controller;
  final String? errorText;
  final bool isPassword;

  @override
  EditPageInputState createState() {
    return EditPageInputState();
  }
}

class EditPageInputState extends State<EditPageInput> {
  FocusNode focusNode = FocusNode();
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {
        isFocused = focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    focusNode.removeListener(() {});
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: GoogleFonts.notoSansJp(
            textStyle: TextStyle(
              color: CupertinoColors.black,
              fontSize: 14.5.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5.w,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          height: 40.h,
          child: CupertinoTextField(
            controller: widget.controller,
            focusNode: focusNode,
            obscureText: widget.isPassword,
            keyboardType: widget.keyboardType,
            padding: isFocused
                ? EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w)
                : EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            decoration: BoxDecoration(
              color: const Color(0xFFefefef),
              borderRadius: BorderRadius.circular(8.r),
              border: isFocused
                  ? Border.all(
                      color: CupertinoColors.link,
                      width: 2.w,
                    )
                  : null,
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              widget.errorText!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
