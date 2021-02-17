import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onTheFiele/common/color.dart';
import 'package:onTheFiele/components/loading.dart';
import 'package:onTheFiele/noticeData/Note.dart';
import 'package:onTheFiele/noticeData/index.dart';
import 'package:onTheFiele/utils/pick_image.dart';
import 'package:onTheFiele/utils/showDialog.dart';
import 'package:onTheFiele/utils/showToast.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class NoteEditorPage extends StatefulWidget {
  String appBarTitle;
  String title;
  String content;
  int time;
  NoteEditorPage(
      {Key key, this.appBarTitle = "新建便签", this.title, this.content, this.time})
      : super(key: key);
  @override
  NoteEditorPageState createState() => NoteEditorPageState();
}

class NoteEditorPageState extends State<NoteEditorPage> {
  /// Allows to control the editor and the document.
  ZefyrController _controller;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;
//定义一个controller
  TextEditingController _TitleController = TextEditingController();
  //导航栏标题文字
  String appbarTitle;
  //标题
  String title = "";
  //编辑还是新建
  bool isEditor = false;
  // 便签id
  int id;
  //数据是否正在加载中
  bool isLoading = true;
  // 是否需要更新数据
  bool isNeedUpdate = false;
  //便签创建事件
  int time;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    //监听输入变化
    _TitleController.addListener(() {
      titleChange(_TitleController.text);
    });
  }

  // 监听标题编辑 事件
  void titleChange(String value) {
    title = value;
  }

  initData() async {
    // 获取路由参数
    Map args = ModalRoute.of(context).settings.arguments;
    if (args['isEditor']) {
      isEditor = true;
      appbarTitle = args['appbarTitle'];
      id = args['id'];
      time = args['time'];
    } else {
      appbarTitle = args['appbarTitle'];
      isEditor = false;
    }
    // 加载写入的文本内容
    final document = await _loadDocument(isEditor: isEditor);
    _controller = ZefyrController(document);
  }

  @override
  Widget build(BuildContext context) {
    initData();
    // 改变样式
    final theme = new ZefyrThemeData(
        toolbarTheme: ToolbarTheme.fallback(context).copyWith(
      color: Colors.white,
      toggleColor: appbarColor,
      iconColor: Colors.black,
      disabledIconColor: Colors.grey.shade500,
    ));
    // 如果数据正在加载中 则显示 loading 加载条
    // 判断是否显示删除按钮
    final removeIcon = isEditor
        ? Builder(
            builder: (context) => IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: _deleteDocument,
                ))
        : Container(height: 0.0, width: 0.0);
    print(isEditor);
    return Scaffold(
      appBar: AppBar(
        title: Text('$appbarTitle'),
        backgroundColor: appbarColor,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // t跳转到上一个页面
              Navigator.pop(context, isNeedUpdate);
            }),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.save),
              onPressed: () => _saveDocument(context),
            ),
          ),
          removeIcon
        ],
      ),
      body: FutureBuilder(
        future: initData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return (_controller == null)
              ? Center(child: Loading())
              : ZefyrScaffold(
                  child: ZefyrTheme(
                      data: theme,
                      child: Column(
                        children: [
                          Container(
                            child: TextField(
                                controller: _TitleController,
                                decoration: InputDecoration(
                                    hintText: '标题',
                                    border: InputBorder.none,
                                    hintStyle:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    contentPadding: EdgeInsets.all(
                                        ScreenUtil().setSp(16)))),
                          ),
                          Expanded(
                              child: ZefyrEditor(
                                  // padding: EdgeInsets.all(ScreenUtil().setSp(16)),
                                  padding: EdgeInsets.fromLTRB(
                                      ScreenUtil().setSp(16),
                                      0,
                                      ScreenUtil().setSp(16),
                                      ScreenUtil().setSp(16)),
                                  controller: _controller,
                                  focusNode: _focusNode,
                                  imageDelegate: CustomImageDelegate())),
                        ],
                      )));
        },
      ),
    );
  }

  // 将json 转为 delta
  Delta getDelta(doc) {
    return Delta.fromJson(json.decode(doc) as List);
  }

  //  读取便签内容
  Future<NotusDocument> _loadDocument({bool isEditor}) async {
    //如果为编辑 则从数据库取出对应的数据
    if (isEditor) {
      List<Note> res = await DBProvider().findNoteListData(id);
      _TitleController.text = res[0].title;
      titleChange(_TitleController.text);
      Delta deltaData = getDelta(res[0].content);
      return NotusDocument.fromDelta(deltaData);
    } else {
      // 返回默认值
      final delta = Delta()..insert('请输入内容\n');
      return NotusDocument.fromDelta(delta);
    }
  }

  // 写入并保存文本内容
  void _saveDocument(BuildContext context) async {
    isNeedUpdate = true;
    // 读取便签内容
    final contents = jsonEncode(_controller.document);
    if (title == null || contents == null) {
      return showToast('标题或内容不能为空');
    }
    //如果isEditor 则 更新数据 否者写入数据
    if (isEditor) {
      // 写入文本内容
      Note note = Note(title: title, content: contents, id: id, time: time);
      print(note.time);
      int res = await DBProvider().update(note);
      if (res > 0) {
        showToast('更新成功');
      } else {
        showToast('更新失败');
      }
    } else {
      // 写入文本内容
      Note note = Note(
          title: title,
          content: contents,
          time: DateTime.now().microsecondsSinceEpoch);
      int res = await DBProvider().saveData(note);
      if (res > 0) {
        showToast('保存成功');
      } else {
        showToast('保存失败');
      }
    }
  }

  //删除便签
  void _deleteDocument() async {
    isNeedUpdate = true;
    // 弹出对话框判断用户是否真的需要删除
    var res = await showConfirmDialog(context, message: '确定删除当前便签吗');
    if (res != null) {
      int res = await DBProvider().deleteData(id);
      if (res > 0) {
        showToast('删除成功');
        // 跳转到上一个页面
        Navigator.pop(context, true);
      } else {
        showToast('删除失败');
      }
    }
  }
}
