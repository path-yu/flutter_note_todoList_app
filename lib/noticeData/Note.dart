//记录便列表数据类
class Note {
  int id;
  String title;
  var content;
  int time;

  Note({this.id, this.title, this.content, this.time});
  //将json 序列化为model对象
  Note.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['time'] = this.time;
    return data;
  }
}
