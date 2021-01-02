// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:nas_app/redux/store.dart';

import './settings.dart' as settings;

void main() async {
  await Redux.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: Redux.store,
        child: MaterialApp(
            title: 'Home App',
            theme: ThemeData(
                primaryColor: Colors.blue[700],
                accentColor: Colors.amber,
                scaffoldBackgroundColor: Colors.white),
            initialRoute: '/',
            routes: settings.routes));
  }
}
