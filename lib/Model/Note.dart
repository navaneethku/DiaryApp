class Note {
  int id;
  String date, title, content;
  Note();

  Note.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    date = map['date'].toString();
    title = map['title'];
    content = map['content'];
  }

  toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'title': title,
      'content': content,
    };
  }
}
