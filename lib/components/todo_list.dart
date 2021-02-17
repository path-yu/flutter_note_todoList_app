import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onTheFiele/utils/showDialog.dart';

// import 'dart:convert';
class TodoList extends StatefulWidget {
  // 接受父组件传递的listdata
  List listData;
  String title;
  Function checkBoxChange;
  Function deleteToDoListItem;
  TodoList(
      {Key key,
      this.listData,
      this.title,
      this.checkBoxChange,
      this.deleteToDoListItem})
      : super(key: key);
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setSp(10)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${widget.title}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(20)),
              ),
              ClipOval(
                  child: Container(
                      width: ScreenUtil().setWidth(20),
                      height: ScreenUtil().setHeight(20),
                      color: Color(0xffE6E6FA),
                      child: Center(
                        child: Text(
                          '${widget.listData.length}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(10),
                              color: Color(0xFF666666)),
                        ),
                      ))),
            ],
          ),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: ScreenUtil().setHeight(200)),
            child: ListView(
                shrinkWrap: true,
                children: widget.listData.map((target) {
                  String value = target['value'].toString();
                  bool done = target['done'];
                  String time = target['time'];
                  return Container(
                      color: Colors.white,
                      height: ScreenUtil().setHeight(40),
                      margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                      child: Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                      value: done,
                                      onChanged: (value) {
                                        setState(() {
                                          widget.checkBoxChange(value, target);
                                        });
                                      }),
                                  Text("$value"),
                                ],
                              ),
                              Expanded(
                                  child: Text(
                                '$time',
                                textAlign: TextAlign.center,
                              )),
                              SizedBox(
                                height: ScreenUtil().setHeight(40),
                                child: IconButton(
                                  icon: Icon(Icons.clear),
                                  iconSize: ScreenUtil().setSp(20),
                                  onPressed: () async {
                                    // 弹出对话框并等待其关闭 等获取它的返回值
                                    bool delete = await showConfirmDialog(
                                        context,
                                        message: '确定删除当前todo吗');
                                    if (delete != null) {
                                      widget.deleteToDoListItem(target);
                                    }
                                  },
                                ),
                              ),
                            ]),
                      ));
                }).toList()),
          )
        ],
      ),
    );
  }
}
