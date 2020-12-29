// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:nas_app/Navigation/mainContainer.dart';
import 'package:nas_app/Pages/logInPage.dart';

import './globals.dart' as globals;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Home App',
        theme: ThemeData(
            primarySwatch: Colors.amber, scaffoldBackgroundColor: Colors.white),
        home: getHomePage());
  }

  Widget getHomePage() {
    if (globals.user != null && globals.user.photoSessionId != null) {
      return MainContainer();
    } else {
      return LogInPage();
    }
  }
}
