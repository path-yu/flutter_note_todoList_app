import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/color.dart';
import '../utils/showToast.dart';

class ToolKitPage extends StatefulWidget {
  ToolKitPage({Key key}) : super(key: key);

  @override
  _ToolKitPageState createState() => _ToolKitPageState();
}

class _ToolKitPageState extends State<ToolKitPage> {
  // '备忘录', '翻译', '大字版', '天气查询', '新华字典'
  final List<Map> toolList = [
    {"RouterPath": '', "label": '备忘录'},
    {"RouterPath": '', "label": '翻译'},
    {"RouterPath": '', "label": '大字版'},
    {"RouterPath": '', "label": '天气查询'},
    {"RouterPath": '', "label": '新华字典'},
    {"RouterPath": '/note_list_page', "label": '便签'},
    {"RouterPath": '', "label": '计算器'},
    {"RouterPath": '/todo_list_page', "label": 'todoList'},
  ];
  Function toRouterPage(String path) {
    Function fn = () async {
      if (path.isEmpty) {
        showToast('暂未开发');
      } else {
        Navigator.of(context).pushNamed(path);
      }
    };

    return fn;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
            title: Text('工具箱 '),
            centerTitle: true,
            backgroundColor: appbarColor,
          ),
          body: Container(
              margin: EdgeInsets.only(top: ScreenUtil().setSp(20)),
              child: Container(
                width: double.infinity,
                child: Wrap(
                  spacing: ScreenUtil().setSp(10),
                  runSpacing: ScreenUtil().setSp(10),
                  alignment: WrapAlignment.spaceAround, //沿主轴方向居中
                  runAlignment: WrapAlignment.spaceAround,
                  children: toolList.map((e) {
                    Color buttonTextColor;
                    String routerPath = e['RouterPath'];
                    if (routerPath.isEmpty) {
                      buttonTextColor = Colors.grey;
                    } else {
                      buttonTextColor = Colors.black;
                    }
                    return Container(
                      width: ScreenUtil().setWidth(150),
                      height: ScreenUtil().setHeight(30),
                      child: RaisedButton(
                          color: Color.fromRGBO(248, 248, 248, 1.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          onPressed: toRouterPage(e['RouterPath']),
                          child: Center(
                            child: Text(
                              "${e['label']}",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(14),
                                  color: buttonTextColor),
                            ),
                          )),
                    );
                  }).toList(),
                ),
              ))),
    );
  }
}
