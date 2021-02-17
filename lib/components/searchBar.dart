import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBar extends StatefulWidget {
  final TextEditingController _todoController;
  final Function addConfrim;
  final TextInputAction textInputAction;
  final String placeHolder;
  Color fillColor;
  Icon prefixIcon;
  int inputWidth;
  SearchBar(this._todoController, this.addConfrim, this.textInputAction,
      this.placeHolder,
      {Key key,
      this.prefixIcon,
      this.fillColor = Colors.white,
      this.inputWidth = 250})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  void initState() {
    super.initState();
    print(widget.prefixIcon);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: ScreenUtil().setSp(30),
          maxWidth: ScreenUtil().setSp(widget.inputWidth)),
      child: TextField(
        controller: widget._todoController,
        textInputAction: widget.textInputAction,
        onSubmitted: widget.addConfrim,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 4.0),
          hintText: widget.placeHolder,
          hintStyle: TextStyle(fontSize: ScreenUtil().setSp(15)),
          prefixIcon: widget.prefixIcon,
          // 设置右边图标
          suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              iconSize: ScreenUtil().setSp(15),
              onPressed: () {
                widget._todoController.text = "";
              }),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: widget.fillColor,
        ),
      ),
    );
  }
}
