import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../common/color.dart';
import '../components/searchBar.dart';
import '../components/todo_list.dart';
import '../utils//notice.dart';
import '../utils/showToast.dart';

class ToDolistPage extends StatefulWidget {
  ToDolistPage({Key key}) : super(key: key);

  @override
  _ToDolistPageState createState() => _ToDolistPageState();
}

class _ToDolistPageState extends State<ToDolistPage> {
  @override
  // 输入框输入值
  String _inputValue = "";
  // 正在进行的任务列表
  List underwayList = [];
  //全部的任务列表
  List todoAllList = [];
  // 已经完成的任务列表
  List completeToDoList = [];
  var localStorage = null;
  //定义一个controller
  TextEditingController _todoController = TextEditingController();
  // 监听键盘点击了确认按钮
  void addConfrim(String value) {
    if (value.isEmpty) {
      showToast('不能为空');
    } else {
      DateTime now = DateTime.now();
      // 储存当前时间并格式化
      var currentTime = formatDate(
          DateTime(
            now.year,
            now.month,
            now.day,
          ),
          [
            yyyy,
            '/',
            mm,
            '/',
            dd,
          ]);
      todoAllList.add({"value": value, "done": false, 'time': currentTime});
      localStorage.setString('todoList', json.encode(todoAllList));
      changeState();
      // 向通知栏添加一个消息
      showNotification('您添加了一条新todo, 请尽快完成哦');
    }
    setState(() {
      // 清空输入框的 和value的主
      _todoController.text = _inputValue = "";
    });
  }

  // 监听输入值值变化
  void filedOnChange(String value) {
    setState(() {
      _inputValue = value;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
    //监听输入变化
    _todoController.addListener(() {
      filedOnChange(_todoController.text);
    });
  }

  void init() async {
    WidgetsFlutterBinding.ensureInitialized();
    final preferences = await StreamingSharedPreferences.instance;
    localStorage = preferences;
    Preference<String> todoList =
        preferences.getString("todoList", defaultValue: "");
    List data = getLocalStorageData('todoList');
    if (data.isEmpty) {
      localStorage.setString('todoList', '[]');
      setState(() {
        todoAllList = [];
      });
    } else {
      setState(() {
        changeState();
      });
    }
  }

  void changeState() {
    setState(() {
      List data = getLocalStorageData('todoList');
      todoAllList = data;
      underwayList = filterListData(todoAllList, false);
      completeToDoList = filterListData(todoAllList, true);
    });
  }

  //获取数据持久化数据并返回json 对象
  List getLocalStorageData(String key) {
    Preference<String> todoList =
        localStorage.getString(key, defaultValue: "[]");
    String data = todoList.getValue();
    return json.decode(data);
  }

  void deleteToDoListItem(target) {
    todoAllList.remove(target);
    localStorage.setString('todoList', json.encode(todoAllList));
    changeState();
  }

  void checkBoxChange(bool value, Map target) {
    int index = todoAllList.indexOf(target);
    todoAllList[index]['done'] = value;
    localStorage.setString('todoList', json.encode(todoAllList));
    changeState();
    // 如果underwayList 为空则 任务全部完成, 则向通知栏添加一条消息
    if (underwayList.isEmpty) {
      showNotification('今日的todo已经完成, 请再接再厉');
    }
  }

  //筛选listdata数据 返回正在进行中的todolist 或者已经完成的todoList
  List filterListData(List arr, bool done) {
    return arr.where((element) => element['done'] == done).toList();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('todoList'),
        centerTitle: true,
        backgroundColor: appbarColor,
      ),
      resizeToAvoidBottomPadding: false, //输入框抵住键盘 内容不随键盘滚动
      body: Container(
        color: appBackgroundColor,
        height: double.infinity,
        child: Column(
          children: [
            Container(
              color: Color(0xffEDEDED),
              padding: EdgeInsets.all(ScreenUtil().setSp(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Center(
                          child: SearchBar(
                    _todoController,
                    addConfrim,
                    TextInputAction.go,
                    '添加todo',
                    prefixIcon: Icon(Icons.add),
                  )))
                ],
              ),
            ),
            TodoList(
              title: '正在进行',
              listData: underwayList,
              deleteToDoListItem: deleteToDoListItem,
              checkBoxChange: checkBoxChange,
            ),
            TodoList(
              title: '已经完成',
              listData: completeToDoList,
              deleteToDoListItem: deleteToDoListItem,
              checkBoxChange: checkBoxChange,
            )
          ],
        ),
      ),
    );
  }
}
