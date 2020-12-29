import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nas_app/Navigation/mainContainer.dart';

import '../Controllers/AuthController.dart';
import '../Services/AuthService.dart';

class LogInPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LogInPage> {
  static AuthController _authController = new AuthController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Widget loginWidget;

  _LoginPageState() {
    init();
  }

  init() {
    loginWidget = ListView(
      children: <Widget>[
        Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Text(
              'Anmelden',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 30),
            )),
        Container(
          padding: EdgeInsets.all(10),
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name',
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextField(
            obscureText: true,
            controller: passwordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Passwort',
            ),
          ),
        ),
        Container(
            height: 50,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: RaisedButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: Text('Login'),
              onPressed: () {
                _authController
                    .authenticateUser(
                        nameController.text, passwordController.text)
                    .then((value) => {
                          if (!value.success)
                            {showLoginFailedDialog(context, value.errorMessage)}
                          else
                            {
                              Navigator.pushReplacement(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          new MainContainer()))
                            }
                        });
              },
            )),
      ],
    );
  }

  Future<bool> _checkUserCredentialsFromStorage = Future<bool>(() async {
    final storage = new FlutterSecureStorage();
    var userName = await storage.read(key: "userName");
    var password = await storage.read(key: "password");
    AuthenticationResult result;
    if (userName != null && password != null) {
      result = await _authController.authenticateUser(userName, password);
    } else {
      return false;
    }

    return result.success;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(10),
            child: new FutureBuilder<bool>(
                future: _checkUserCredentialsFromStorage,
                builder: (context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (!snapshot.data) {
                      return loginWidget;
                    } else {
                      return MainContainer();
                    }
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                })));
  }

  showLoginFailedDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Login failed"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
