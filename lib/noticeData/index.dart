import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'Note.dart';

class DBProvider {
  static final DBProvider _singleton = DBProvider._internal();

  factory DBProvider() {
    return _singleton;
  }

  DBProvider._internal();

  static Database _db;
  // 获取db 实例对象 操作数据库
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await _initDB();
    return _db;
  }

  // 初始化数据库
  Future<Database> _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'dbName');
    print(path);
    return await openDatabase(path,
        version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  /// 创建Table
  Future _onCreate(Database db, int version) async {
    return await db.execute("CREATE TABLE NoteList ("
        "id integer primary key AUTOINCREMENT,"
        "title TEXT,"
        "content TEXT,"
        "time INTEGER "
        ""
        ")");
  }

  /// 更新Table
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  // 保存储存数据
  Future saveData(Note note) async {
    var _db = await db;
    //  向数据库插入
    return await _db.insert('NoteList', note.toJson());
  }

  // 查询所有数据
  Future<List<Note>> findAll() async {
    var _db = await db;
    List<Map> result = await _db.query('NoteList');
    return result.isNotEmpty
        ? result.map((e) {
            return Note.fromJson(e);
          }).toList()
        : [];
  }

  //根据id 查询数据
  Future<List<Note>> findNoteListData(int id) async {
    var _db = await db;
    List<Map<String, dynamic>> result =
        await _db.query('NoteList', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty
        ? result.map((e) {
            return Note.fromJson(e);
          }).toList()
        : [];
  }

  // 根据 note id 更新数据
  Future<int> update(Note note) async {
    var _db = await db;
    return await _db.update('NoteList', note.toJson(),
        where: 'id = ?', whereArgs: [note.id]);
  }

  // 根据 note id 删除数据
  Future<int> deleteData(int id) async {
    var _db = await db;
    return await _db.delete('NoteList', where: 'id = ?', whereArgs: [id]);
  }

  //  根据标题 模糊查询
  Future<List<Note>> findTitleNoteList(String title) async {
    var _db = await db;
    List<Map<String, dynamic>> result = await _db
        .rawQuery("SELECT * FROM NoteList WHERE title LIKE '%$title%'");
    return result.isNotEmpty
        ? result.map((e) {
            return Note.fromJson(e);
          }).toList()
        : [];
  }
}
