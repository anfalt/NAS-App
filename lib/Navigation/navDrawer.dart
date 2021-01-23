import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:nas_app/Model/User.dart';
import 'package:nas_app/redux/User/UserAction.dart';
import 'package:nas_app/redux/User/UserState.dart';
import 'package:nas_app/redux/store.dart';

import '../settings.dart' as settings;

class NavDrawerWidget extends StatelessWidget {
  void logoutUser(
    BuildContext context,
  ) {
    Redux.store.dispatch(fetchUserLogOutAction);
    Navigator.of(context).pushNamed("/home");
  }

  @override
  Widget build(BuildContext context) {
    var navItems = settings.routes.keys.map(getNavItemForRoute).toList();
    navItems.insert(0, _NavigationItem(true, null, null, null));

    return StoreConnector<AppState, UserState>(
        converter: (store) => store.state.userState,
        builder: (context, userState) {
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
                      _buildItem((navItems[index]), context, userState.user),
                )),
          );
        });
  }

  Widget _buildItem(_NavigationItem data, BuildContext context, User user) =>
      data.header
          // if the item is a header return the header widget
          ? _makeHeaderItem(context, user)
          // otherwise build and return the default list item
          : _makeListItem(data, context);

  Widget _makeHeaderItem(BuildContext context, User user) {
    var name = user != null ? user.name : "";
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
    case "/home":
      return _NavigationItem(false, "/home", "Start", Icons.home);
    case "/images":
      return _NavigationItem(false, "/images", "Bilder", Icons.image);
    case "/lists":
      return _NavigationItem(false, "/lists", "Listen", Icons.fact_check);
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
