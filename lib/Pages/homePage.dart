import 'package:flutter/material.dart';

import '../Navigation/navDrawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Start"),
      ),
      drawer: NavDrawerWidget(),
      body: Container(child: Text("Home")),
    );
  }
}
