// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:nas_app/Controllers/PushNotificationController.dart';
import 'package:nas_app/redux/User/UserAction.dart';
import 'package:nas_app/redux/User/UserState.dart';
import 'package:nas_app/redux/store.dart';

import './settings.dart' as settings;

void main() async {
  await Redux.init();

  runApp(MyApp());
  new PushNotificationsManager().init();
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: Redux.store,
        child: StoreConnector<AppState, UserState>(
            converter: (store) => store.state.userState,
            onInit: (store) =>
                store.dispatch((store) => fetchGetUserSettingsAction(store)),
            builder: (context, userState) {
               var theme = new ThemeData();
              var userSettings = userState.userSettings;
              if(userSettings != null){
               theme = new ThemeData(
                  primaryColor: userSettings.primaryColor,
                  accentColor: userSettings.accentColor,
                  fontFamily: userSettings.useComicSansFont ? 'ComicSans' : "");
              }
              return MaterialApp(
                  title: 'Home App',
                  theme: theme,
                  initialRoute: '/home',
                  routes: settings.routes);
            }));
  }
}
