import 'package:onTheFiele/main.dart';
import 'package:permission_handler/permission_handler.dart';

import './showDialog.dart';

// 获取app 是否具有通知权限 如果没有则弹出对话框 跳转到设置界面
Future requesNoticetPermission() async {
  // 判断是否没有通知权限 如果没有则弹出对话框 打开设置界面提示用户添加权限
  if (await Permission.notification.isDenied) {
    // 打开对话框 提示用户是否前往设置界面设置权限
    bool result = await showConfirmDialog(
        navigatorKey.currentState.overlay.context,
        message: '暂无通知权限, 是否前往设置界面设置权限',
        confirmText: '确定');
    //判断result是否为空, 不为空说明点击了确定按钮
    if (result != null) {
      openAppSettings();
    }
    return false;
  } else {
    return true;
  }
}
