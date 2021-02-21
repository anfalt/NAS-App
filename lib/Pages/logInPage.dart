import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:nas_app/redux/User/UserAction.dart';
import 'package:nas_app/redux/User/UserState.dart';
import 'package:nas_app/redux/store.dart';

import '../Services/AuthService.dart';

class LogInPage extends StatefulWidget {
  final Widget child;
  LogInPage(this.child);
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LogInPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthService authService = new AuthService();
  Widget loginWidget;
  Widget loginFromStorage;

  _LoginPageState() {
    init();
  }

  init() {
    loginWidget = Scaffold(
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
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
                    child: ElevatedButton(
                
                      child: Text('Login'),
                      onPressed: () {
                        Redux.store.dispatch((store) => {
                              fetchUserAction(store, authService,
                                  nameController.text, passwordController.text)
                            });
                      },
                    )),
              ],
            )));

    loginFromStorage = StoreConnector<AppState, UserState>(
        converter: (store) => store.state.userState,
        onInit: (store) => store.dispatch(
            (store) => {fetchUserActionFromStorage(store, authService)}),
        builder: (context, userState) {
          return (() {
            if (!userState.isLoading) {
              if (userState.isError) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  showLoginFailedDialog(context, userState.errorMessage);
                });
              }
              if (userState.user == null || !userState.credentialsInStorage) {
                return loginWidget;
              } else {
                return widget.child;
              }
            } else {
              return Scaffold(
                  body: Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(child: CircularProgressIndicator())));
            }
          }());
        });
  }

  @override
  Widget build(BuildContext context) {
    var user = Redux.store.state.userState.user;
    return (() {
      if (user != null && user.photoSessionId != null) {
        return widget.child;
      } else {
        return loginFromStorage;
      }
    }());
  }

  showLoginFailedDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Anmeldung fehlgeschlagen"),
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
