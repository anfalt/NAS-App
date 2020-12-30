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
      body: Text("Home"),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            //First action menu widget
            // Bottom that pops up from the bottom of the screen.
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),

            //Third action menu widget for overflow action
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
