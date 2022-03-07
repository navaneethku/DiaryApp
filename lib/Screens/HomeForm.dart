import 'package:diary/DatabaseHandler/DbHelper.dart';
import 'package:diary/Screens/Home.dart';
import 'package:flutter/material.dart';
import 'package:diary/Comm/comHelper.dart';
import 'package:diary/Comm/genTextFormField.dart';
import 'package:diary/Model/UserModel.dart';
import 'package:diary/Screens/LoginForm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeForm extends StatefulWidget {
  @override
  _HomeFormState createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  final _formKey = new GlobalKey<FormState>();
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  DbHelper dbHelper;
  final _conUserId = TextEditingController();
  final _conDelUserId = TextEditingController();
  final _conUserName = TextEditingController();
  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();

    dbHelper = DbHelper();
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      _conUserId.text = sp.getString("user_id");
      _conDelUserId.text = sp.getString("user_id");
      _conUserName.text = sp.getString("user_name");
      _conPassword.text = sp.getString("password");
    });
  }

  update() async {
    String uid = _conUserId.text;
    String uname = _conUserName.text;
    String email = _conEmail.text;
    String passwd = _conPassword.text;

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      UserModel user = UserModel(uid, uname, passwd);
      await dbHelper.updateUser(user).then((value) {
        if (value == 1) {
          alertDialog(context, "Successfully Updated");

          updateSP(user, true).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginForm()),
                (Route<dynamic> route) => false);
          });
        } else {
          alertDialog(context, "Error Update");
        }
      }).catchError((error) {
        print(error);
        alertDialog(context, "Error");
      });
    }
  }

  delete() async {
    String delUserID = _conDelUserId.text;

    await dbHelper.deleteUser(delUserID).then((value) {
      if (value == 1) {
        alertDialog(context, "Successfully Deleted");

        updateSP(null, false).whenComplete(() {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => LoginForm()),
              (Route<dynamic> route) => false);
        });
      }
    });
  }

  Future updateSP(UserModel user, bool add) async {
    final SharedPreferences sp = await _pref;

    if (add) {
      sp.setString("user_name", user.user_name);
      sp.setString("password", user.password);
    } else {
      sp.remove('user_id');
      sp.remove('user_name');
      sp.remove('password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[200],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
         onPressed : ()=> Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => Home()),
                (Route<dynamic> route) => false),
        ),
        title: Text("Diary"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Update
                  getTextFormField(
                      controller: _conUserId,
                      isEnable: false,
                      icon: Icons.person,
                      hintName: 'User ID'),
                  SizedBox(height: 10.0),
                  getTextFormField(
                      controller: _conUserName,
                      icon: Icons.person_outline,
                      inputType: TextInputType.name,
                      hintName: 'User Name'),
                  SizedBox(height: 10.0),
                  getTextFormField(
                    controller: _conPassword,
                    icon: Icons.lock,
                    hintName: 'Password',
                    isObscureText: true,
                  ),
                  //Delete
                  Container(
                    margin: EdgeInsets.all(30.0),
                    width: double.infinity,
                    child: FlatButton(
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: delete,
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
            ),
          ),
        ),
      ),
    );
  }
}
