import 'package:flutter/material.dart';
import 'package:diary/Model/Note.dart';
import 'package:diary/DatabaseHandler/db.dart';
import 'package:diary/widgets/loading.dart';
import 'package:flutter/services.dart';

class Edit extends StatefulWidget {
  final Note note;
  Edit({this.note});
  @override
  EditState createState() => EditState();
}

class EditState extends State<Edit> {
  TextEditingController date, title, content;
  bool loading = false, editmode = false;
  String dateTime;

  @override
  void initState() {
    super.initState();
    date = new TextEditingController(
        text: DateTime.now().toString().substring(0, 10));
    title = new TextEditingController(text: 'Title');
    content = new TextEditingController(text: 'Content');
    if (widget.note.id != null) {
      editmode = true;
      date.text = widget.note.date.toString();
      title.text = widget.note.title;
      content.text = widget.note.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[200],
        title: Text(editmode ? 'Edit' : 'New'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              setState(() => loading = true);
              save();
              Navigator.pop(context);
            },
          ),
          if (editmode)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() => loading = true);
                delete();
              },
            ),
        ],
      ),
      body: loading
          ? Loading()
          : ListView(
              padding: EdgeInsets.all(13.0),
              children: <Widget>[
                TextField(
                  controller: date,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    fillColor: Colors.indigo[50],
                    filled: true,
                  ),
                ),
                SizedBox(height: 10.0),
                TextField(
                  controller: title,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    fillColor: Colors.indigo[50],
                    filled: true,
                  ),
                ),
                SizedBox(height: 10.0),
                TextField(
                  minLines: 1,
                  maxLines: 20,
                  keyboardType: TextInputType.multiline,
                  controller: content,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    fillColor: Colors.indigo[50],
                    filled: true,
                  ),
                  maxLength: 1000,
                ),
              ],
            ),
    );
  }

  Future<void> save() async {
    if (title.text != '') {
      widget.note.date = date.text;
      widget.note.title = title.text;
      widget.note.content = content.text;
      if (editmode)
        await DB().update(widget.note);
      else
        await DB().add(widget.note);
    }
    setState(() => loading = false);
  }

  Future<void> delete() async {
    await DB().delete(widget.note);
    Navigator.pop(context);
  }
}
