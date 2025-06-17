import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mcm_app/pages/lobby/lobby_page.dart';

// App 為整個 Flutter 應用的根元件

// App 主要負責設定全局樣式並載入首頁
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // 使用 ScreenUtil 適配不同解析度
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return CupertinoApp(
          theme: const CupertinoThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: CupertinoColors.white,
          ),
          color: CupertinoColors.white,
          debugShowCheckedModeBanner: false,
          title: 'Flutter',
          home: child,
        );
      },
      child: LobbyPage(),
    );
  }
}
