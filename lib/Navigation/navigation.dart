import 'package:flutter/material.dart';
import 'package:nas_app/Navigation/appDrawer.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // List<Widget> _widgetOptions = <Widget>[
  //   HomePage(title: "Start"),
  //   HomePage(title: "Bilder"),
  //   HomePage(title: "Kalendar"),
  // ];
  //int _currentSelected = 0;

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _currentSelected = index;
  //   });
  // }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(icon: Icon(Icons.menu), onPressed: openDrawer),
            Spacer(),
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  openDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }
}
