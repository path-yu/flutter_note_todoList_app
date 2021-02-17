import './components/tabs.dart';
import './page//note_editor_page.dart';
import './page/note_page.dart';
import "./page/todo_list_page.dart";

final routes = {
  '/todo_list_page': (context) => ToDolistPage(),
  '/': (context) => Tabs(),
  '/note_list_page': (context) => NoteListPage(),
  '/create_note_or_editor_page': (context) => NoteEditorPage(),
};
