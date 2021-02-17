import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil_init.dart';

import "./router.dart";
import './utils/localStorage.dart';
import './utils/notice.dart';

// 应用初始化检测
appInit() async {
  // 获取正在进行中的任务列表
  List underwayList =
      filterListData(await getLocalStorageData('todoList'), false);
  // 判断正在进行中任务列表是否为empty
  if (underwayList.isNotEmpty) {
    showNotification('今天的todo还未完成哦,请记得按时完成哦');
  }
}

main() {
  runApp(App());
  appInit();
}

// 通过navigatorKey的方式 保存全局的context
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      allowFontScaling: false,
      builder: () => MaterialApp(
        title: "首页",
        // 注册首页路由
        initialRoute: '/',
        // 注册路由表
        routes: routes,
        // 保存全局navigatorkey
        navigatorKey: navigatorKey,
        // 取消debug显示条
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
