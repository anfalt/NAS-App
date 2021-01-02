library nas_app.settings;

import 'package:flutter/material.dart';
import 'package:nas_app/Pages/imagesPage.dart';
import 'package:nas_app/Pages/logInPage.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => LogInPage(),
  '/images': (context) => ImagesPage(),
  // '/calendar': (context) => CalendarPage(),
};
