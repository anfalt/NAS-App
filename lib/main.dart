// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import './settings.dart' as settings;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Home App',
        theme: ThemeData(
            primarySwatch: Colors.amber, scaffoldBackgroundColor: Colors.white),
        initialRoute: '/',
        routes: settings.routes);
  }
}
