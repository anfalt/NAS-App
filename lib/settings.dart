library nas_app.settings;

import 'package:flutter/material.dart';
import 'package:nas_app/Pages/homePage.dart';
import 'package:nas_app/Pages/imagesPage.dart';
import 'package:nas_app/Pages/logInPage.dart';

import 'globals.dart' as globals;

Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => getHomePage(),
  '/images': (context) => ImagesPage(),
  // '/calendar': (context) => CalendarPage(),
};

Widget getHomePage() {
  if (globals.user != null && globals.user.photoSessionId != null) {
    return HomePage();
  } else {
    return LogInPage();
  }
}
