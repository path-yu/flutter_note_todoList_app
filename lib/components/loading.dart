import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SizedBox(
          width: ScreenUtil().setWidth(25),
          height: ScreenUtil().setHeight(25),
          child: // 模糊进度条(会执行一个旋转动画)
              CircularProgressIndicator(
            backgroundColor: Colors.grey[200],
            strokeWidth: ScreenUtil().setSp(2),
            valueColor: AlwaysStoppedAnimation(Colors.blue),
          ),
        ),
      ),
    );
  }
}
