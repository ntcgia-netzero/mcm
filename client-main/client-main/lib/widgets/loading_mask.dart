import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingMask extends StatelessWidget {
  const LoadingMask({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return Container(
        height: 1.sh,
        width: 1.sw,
        color: Colors.black38,
        child: Center(
          child: LoadingAnimationWidget.hexagonDots(
            color: Colors.white,
            size: 100.sp,
          ),
        ),
      );
    }

    return Container();
  }
}
