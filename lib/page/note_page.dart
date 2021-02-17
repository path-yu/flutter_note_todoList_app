import 'dart:convert';

import 'package:date_format/date_format.dart';
import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:onTheFiele/components/loading.dart';
import 'package:onTheFiele/noticeData/Note.dart';
import 'package:onTheFiele/noticeData/index.dart';

import '../common/color.dart';
import '../components/searchBar.dart';
import '../utils/showToast.dart';

class NoteListPage extends StatefulWidget {
  NoteListPage({Key key}) : super(key: key);

  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  //定义一个controller
  TextEditingController _noteController = TextEditingController();
  // 所有的标签数据
  List<Note> noteList = [];
  // 数据是否正在加载
  bool isLoading = true;
  // t提示文字
  String messageText = "你还未添加添加便签,请点击按钮添加便签吧!";
  @override
  void initState() {
    // TODO: implement initState
    getData(DBProvider().findAll);
    super.initState();
  }

  //从数据库中读取数据
  void getData(action, [String title = ""]) async {
    setState(() {
      isLoading = true;
    });
    List<Note> result;
    if (title.isNotEmpty) {
      result = await action(title);
      if (result.isEmpty) {
        setState(() {
          messageText = '很遗憾,没有搜索到数据!';
        });
      }
    } else {
      result = await action();
    }
    Future.delayed(
        Duration(seconds: 1),
        () => {
              setState(() {
                noteList = result;
                isLoading = false;
              })
            });
  }

  // 返回便签内容数据
  String getNoteContent(target) {
    String content = json.decode(target.content)[0]['insert'];
    content = content.replaceAll('\n', '');
    return content;
  }

  // 跳转到新建便签 页面
  void toCreateOrEditorNotePage({int id, int time}) {
    if (id != null) {
      // 打开新页面 并等待返回结果
      print(time);
      Navigator.pushNamed(context, '/create_note_or_editor_page', arguments: {
        'appbarTitle': '编辑便签',
        'isEditor': true,
        "id": id,
        'time': time
      }).then((value) {
        if (value) {
          getData(DBProvider().findAll);
        }
      });
    } else {
      Navigator.pushNamed(context, '/create_note_or_editor_page',
          arguments: {'appbarTitle': '新建便签', 'isEditor': false}).then((value) {
        getData(DBProvider().findAll);
      });
    }
  }

  /**
   * 下拉刷新,必须异步async不然会报错
   */
  Future _pullToRefresh() async {
    getData(DBProvider().findAll);
    _noteController.text = "";
    return null;
  }

  Widget buildNoteListCard() {
    if (isLoading) {
      return Loading();
    } else {
      return noteList.isEmpty
          ? Expanded(
              child: SizedBox(
              height: ScreenUtil().setSp(20),
              child: ListView.builder(
                itemCount: 15,
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Center(
                      child: Text(messageText,
                          style: TextStyle(color: Colors.grey)),
                    );
                  } else {
                    return Container(
                      width: 40,
                      height: 40,
                    );
                  }
                },
              ),
            ))
          : Expanded(
              child: StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              itemCount: noteList.length,
              itemBuilder: (BuildContext context, int index) {
                Note target = noteList[index];
                String content = getNoteContent(target);
                var date = DateTime.fromMicrosecondsSinceEpoch(target.time);
                final title = target.title == null
                    ? SizedBox(
                        height: 0,
                      )
                    : Text(
                        '${target.title}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      );
                var currentTime = formatDate(
                    DateTime(
                      date.year,
                      date.month,
                      date.day,
                    ),
                    [yyyy, '年', mm, '月', dd, '日']);
                return InkWell(
                  onTap: () => toCreateOrEditorNotePage(
                      id: target.id, time: target.time),
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setSp(10))),
                      child: Padding(
                        padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            title,
                            Text(
                              '$content',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(color: Color(0xff636363)),
                            ),
                            Text(
                              '$currentTime',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(12),
                                  color: Color(0xff969696)),
                            )
                          ],
                        ),
                      )),
                );
              },
              staggeredTileBuilder: (int index) {
                String content = getNoteContent(noteList[index]);
                int length = content.length;
                double ratio;
                if (length > 12) {
                  ratio = 1.5;
                } else if (index > 24) {
                  ratio = 2.5;
                } else {
                  ratio = 1.2;
                }
                print(ratio);
                return StaggeredTile.count(2, ratio);
              },
              mainAxisSpacing: ScreenUtil().setSp(10),
              crossAxisSpacing: ScreenUtil().setSp(10),
            ));
    }
  }

  // 监听键盘点击了确认按钮
  void addConfrim(String value) async {
    if (value.isEmpty) {
      return showToast('请输入搜索内容');
    } else {
      getData(DBProvider().findTitleNoteList, value);
      return null;
    }
    // 通过标题来查询数据
    await getData(DBProvider().findTitleNoteList, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('便签'),
        centerTitle: true,
        backgroundColor: appbarColor,
      ),
      body: Container(
          padding: EdgeInsets.all(ScreenUtil().setSp(15)),
          // color: appBackgroundColor,
          child: RefreshIndicator(
            onRefresh: _pullToRefresh,
            color: const Color(0xFF4483f6),
            child: Column(
              children: <Widget>[
                Center(
                  child: SearchBar(
                    _noteController,
                    addConfrim,
                    TextInputAction.search,
                    '搜索便签',
                    fillColor: searchBarFillColor,
                    prefixIcon: Icon(
                      Icons.search,
                      size: ScreenUtil().setSp(15),
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                buildNoteListCard(),
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => toCreateOrEditorNotePage(),
        backgroundColor: appbarColor,
        child: Icon(Icons.add),
      ),
    );
  }
}
