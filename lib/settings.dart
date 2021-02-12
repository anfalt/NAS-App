library nas_app.settings;

import 'package:flutter/material.dart';
import 'package:nas_app/Pages/homePage.dart';
import 'package:nas_app/Pages/imagesPage.dart';
import 'package:nas_app/Pages/listItemPage.dart';
import 'package:nas_app/Pages/listsPage.dart';
import 'package:nas_app/Pages/logInPage.dart';
import 'package:nas_app/Pages/settingsPage.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/home': (context) => LogInPage(HomePage()),
  '/images': (context) => LogInPage(ImagesPage()),
  '/lists': (context) => LogInPage(ListsPage()),
  '/lists/items': (context) => LogInPage(ListItemsPage()),
  '/settings': (context) => LogInPage(SettingsPage()),
};

List<String> taskListUsers = ["adminAndi", "Louise", "Andi"];
