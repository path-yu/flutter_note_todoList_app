import "package:flutter/material.dart";

// 弹出对话框
Future<bool> showConfirmDialog(BuildContext context,
    {String tips = "提示",
    String message = "你确定要删除吗",
    String cancelText = "取消",
    String confirmText = "删除"}) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(tips),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text(cancelText),
            onPressed: () => Navigator.of(context).pop(), // 关闭对话框
          ),
          FlatButton(
            child: Text(confirmText),
            onPressed: () {
              //关闭对话框并返回true
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
