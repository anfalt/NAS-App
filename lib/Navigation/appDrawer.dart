// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../Pages/calendarPage.dart';
import '../Pages/imagesPage.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Bilder'),
            leading: Icon(Icons.image),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ImagesPage()));
            },
          ),
          ListTile(
            title: Text('Kalendar'),
            leading: Icon(Icons.event),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => CalendarPage()));
            },
          ),
        ],
      ),
    );
  }
}
