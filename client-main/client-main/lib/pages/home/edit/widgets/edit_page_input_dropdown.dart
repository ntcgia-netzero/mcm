import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class EditPageInputDropdown extends StatefulWidget {
  const EditPageInputDropdown({
    super.key,
    required this.title,
    required this.items,
    this.errorText,
  });

  final String title;
  final List<String> items;
  final String? errorText;

  @override
  EditPageInputDropdownState createState() => EditPageInputDropdownState();
}

class EditPageInputDropdownState extends State<EditPageInputDropdown> {
  int selectedIndex = 0;
  bool isFocused = false;

  void select(int index) {
    setState(() {
      selectedIndex = index;
    });
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
        GestureDetector(
          onTap: () => _showCupertinoDialog(),
          child: Container(
            height: 40.h,
            padding: isFocused
                ? EdgeInsets.symmetric(horizontal: 7.w, vertical: 7.h)
                : EdgeInsets.symmetric(horizontal: 9.w, vertical: 9.h),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.items[selectedIndex],
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: CupertinoColors.black,
                  ),
                ),
                Icon(
                  CupertinoIcons.down_arrow,
                  size: 16.sp,
                  color: CupertinoColors.black,
                ),
              ],
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              widget.errorText!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.sp,
              ),
            ),
          ),
      ],
    );
  }

  void _showCupertinoDialog() {
    setState(() {
      isFocused = true;
    });

    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: widget.items.asMap().entries.map((item) {
          int index = item.key;

          return CupertinoActionSheetAction(
            child: Text(widget.items[index]),
            onPressed: () {
              setState(() {
                selectedIndex = index;
                Navigator.pop(context);
              });
            },
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
          isDefaultAction: true,
          child: const Text('取消'),
        ),
      ),
    ).then((_) {
      setState(() {
        isFocused = false;
      });
    });
  }
}
