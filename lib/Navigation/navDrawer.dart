import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nas_app/Pages/logInPage.dart';

import "../globals.dart" as globals;
import '../settings.dart' as settings;

class NavDrawerWidget extends StatelessWidget {
  void logoutUser(BuildContext context) {
    final storage = new FlutterSecureStorage();
    List<Future<void>> futures = [];
    futures.add(storage.delete(key: "userName"));
    futures.add(storage.delete(key: "password"));

    Future.wait(futures).then((values) => {
          globals.user = null,
          Navigator.pushReplacement(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => new LogInPage()))
        });
  }

  @override
  Widget build(BuildContext context) {
    var navItems = settings.routes.keys.map(getNavItemForRoute).toList();
    navItems.insert(0, _NavigationItem(true, null, null, null));

    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: Container(
          color: Colors.white,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: navItems.length,
            itemBuilder: (BuildContext context, int index) =>
                _buildItem((navItems[index]), context),
          )),
    );
  }

  Widget _buildItem(_NavigationItem data, BuildContext context) => data.header
      // if the item is a header return the header widget
      ? _makeHeaderItem(context)
      // otherwise build and return the default list item
      : _makeListItem(data, context);

  Widget _makeHeaderItem(BuildContext context) {
    var name = globals.user != null ? globals.user.name : "";
    return Container(
        height: 100,
        child: DrawerHeader(
          child: Row(
            children: [
              Text(name, style: TextStyle(color: Colors.white)),
              IconButton(
                  icon: Icon(
                    Icons.logout,
                    size: 16,
                  ),
                  onPressed: () => {logoutUser(context)}),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
          decoration: BoxDecoration(color: Theme.of(context).accentColor),
        ));
  }

  Widget _makeListItem(_NavigationItem data, BuildContext context) {
    var currentRoute = ModalRoute.of(context).settings.name;
    return Card(
      color: data.route == currentRoute
          ? Theme.of(context).accentColor
          : Colors.white,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
      // So we see the selected highlight
      borderOnForeground: true,
      elevation: 0,
      margin: EdgeInsets.zero,
      child: ListTile(
        title: Text(
          data.title,
          style: TextStyle(
            color: data.route == currentRoute
                ? Theme.of(context).textTheme.headline1.color
                : Theme.of(context).primaryColor,
          ),
        ),
        leading: Icon(
          data.icon,
          // if it's selected change the color
          color: data.route == currentRoute
              ? Theme.of(context).accentIconTheme.color
              : Theme.of(context).primaryColor,
        ),
        onTap: () => {_handleItemClick(context, data)},
      ),
    );
  }

  void _handleItemClick(BuildContext context, _NavigationItem item) {
    Navigator.of(context).pushNamed(item.route);
  }
}

_NavigationItem getNavItemForRoute(String route) {
  switch (route) {
    case "/":
      return _NavigationItem(false, "/", "Start", Icons.home);
    case "/images":
      return _NavigationItem(false, "/images", "Bilder", Icons.image);
    case "/calendar":
      return _NavigationItem(false, "/calendar", "Start", Icons.event);
    default:
      return _NavigationItem(true, "/home", "Start", Icons.home);
  }
}

// helper class used to represent navigation list items
class _NavigationItem {
  final bool header;
  final String route;
  final String title;
  final IconData icon;
  _NavigationItem(this.header, this.route, this.title, this.icon);
}
