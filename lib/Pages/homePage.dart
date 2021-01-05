import 'package:flutter/material.dart';

import '../Navigation/navDrawer.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Start"),
      ),
      drawer: NavDrawerWidget(),
      body: Container(child: Text("Home")),
    );
  }
}
