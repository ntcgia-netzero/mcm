import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      width: 1.sw,
      color: const Color(0xFF448fda),
      padding: EdgeInsets.only(
        top: 50.h,
      ),
      child: Stack(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: CupertinoNavigationBarBackButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              )),
          Center(
            child: Text(
              title,
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
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onPressed,
              child: Text(
                "送出",
                style: GoogleFonts.notoSansJp(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
