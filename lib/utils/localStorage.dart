import 'dart:convert';

import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

var localStorage;

// 获取数据持久化存储对象的数据
dynamic getLocalStorageData(key) async {
  // 初始化数据持久化存储对象
  final preferences = await StreamingSharedPreferences.instance;
  Preference<String> value = preferences.getString(key, defaultValue: "[]");
  String data = value.getValue();
  //将string 转为json
  return json.decode(data);
}

//筛选listdata数据 返回正在进行中的todolist 或者已经完成的todoList
List filterListData(List arr, bool done) {
  return arr.where((element) => element['done'] == done).toList();
}
