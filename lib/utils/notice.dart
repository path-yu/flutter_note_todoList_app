import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:onTheFiele/main.dart';

import 'index.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void init() async {}

// 显示通知栏
Future<void> showNotification(String message) async {
  var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: android);
  // 初始化配置通知插件参数
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);
  if (await requesNoticetPermission()) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', '简单的todo',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'message');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'message', message, platformChannelSpecifics,
        payload: '/todo_list_page');
  }
}

// 点击通知栏触发的事件 跳转到todoListpage 页面
Future selectNotification(
  String payload,
) async {
  if (payload != null) {
    navigatorKey.currentState.pushNamed(payload);
  }
}
