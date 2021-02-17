import "package:flutter/cupertino.dart";
import 'package:flutter/material.dart';

import '../page/home_page.dart';
import "../page/tool_kit_page.dart";

class Tabs extends StatefulWidget {
  Tabs({Key key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  final List<BottomNavigationBarItem> bottomTabsList = [
    BottomNavigationBarItem(
        icon: Icon(
          CupertinoIcons.home,
        ),
        label: "首页"),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.toc_outlined,
        ),
        label: "工具箱"),
  ];
  final tabsList = [
    MyHomePage(),
    ToolKitPage(),
  ];
  //
  int currentIndex = 1;
  Widget currentPage;

  @override
  void initState() {
    currentPage = tabsList[currentIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 0.5),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: bottomTabsList,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            currentPage = tabsList[currentIndex];
          });
        },
      ),
      body: currentPage,
    );
  }
}
