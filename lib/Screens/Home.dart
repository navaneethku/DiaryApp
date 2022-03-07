import 'package:diary/Screens/HomeForm.dart';
import 'package:diary/Screens/LoginForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diary/Model/Note.dart';
import 'package:diary/Screens/Edit.dart';
import 'package:diary/DatabaseHandler/db.dart';
import 'package:diary/widgets/loading.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  List<Note> notes;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[200],
        leading :IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => LoginForm()),
              (Route<dynamic> route) => false),
        ),
        title: Text('Diary'),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigo[200],
        child: Icon(Icons.add),
        onPressed: () {
          setState(() => loading = true);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Edit(note: new Note()))).then((v) {
            refresh();
          });
        },
      ),
      body: loading
          ? Loading()
          : Column(
            children: [
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.all(5.0),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      Note note = notes[index];
                      String date1 = note.date.toString();
                      return Card(
                        color: Colors.indigo[50],
                        child: ListTile(
                          title: Text(note.title),
                          subtitle: Text(
                            note.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(note.date),
                          onTap: () {
                            setState(() => loading = true);
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Edit(note: note)))
                                .then((v) {
                              refresh();
                            });
                          },
                        ),
                      );
                    },
                  ),
              ),
                Container(
            margin: EdgeInsets.fromLTRB(30, 30, 30, 100),
            width: double.infinity,
            child: FlatButton(
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => HomeForm()),
                  (Route<dynamic> route) => false),
              child: Text(
                'Profiles',
                style: TextStyle(color: Colors.white),
              ),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(143, 148, 251, 1),
                  Color.fromRGBO(143, 148, 251, .6),
                ])),
          ),
            ],
          ),
    );
  }

  Future<void> refresh() async {
    notes = await DB().getNotes();
    setState(() => loading = false);
  }
}
