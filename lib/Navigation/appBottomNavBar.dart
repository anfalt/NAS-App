import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:nas_app/redux/User/UserState.dart';
import 'package:nas_app/redux/store.dart';

import '../settings.dart' as settings;

class AppBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserState>(
        converter: (store) => store.state.userState,
        builder: (context, userState) {
          if (userState.isLoading) {
            return Container();
          }
          var navItems = settings.routes.keys
              .where((element) => element != "/lists/items")
              .map(getNavItemForRoute)
              .toList();
          var userSeesLists =
              settings.taskListUsers.indexOf(userState.user.name) > -1;
          if (!userSeesLists) {
            navItems = navItems.where((element) => element.route != "/lists");
          }
          var currentRoute = ModalRoute.of(context).settings.name;
          var currentIndex = navItems
              .indexWhere((element) => currentRoute.contains(element.route));

          return BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) =>
                  {Navigator.of(context).pushNamed(navItems[index].route)},
              type: BottomNavigationBarType.fixed,
              items: (() {
                List<BottomNavigationBarItem> widgets = [];
                for (var i = 0; i < navItems.length; i++) {
                  widgets.add(_makeListItem((navItems[i]), context));
                }
                return widgets;
              }()));
        });
  }

  BottomNavigationBarItem _makeListItem(
      _NavigationItem data, BuildContext context) {
    return BottomNavigationBarItem(icon: Icon(data.icon), label: data.title);
  }
}

_NavigationItem getNavItemForRoute(String route) {
  switch (route) {
    case "/home":
      return _NavigationItem(false, "/home", "Start", Icons.home, true);
    case "/images":
      return _NavigationItem(false, "/images", "Bilder", Icons.image, true);
    case "/lists":
      return _NavigationItem(false, "/lists", "Listen", Icons.fact_check, true);
    case "/settings":
      return _NavigationItem(
          false, "/settings", "Einstellungen", Icons.settings, true);
    default:
      return _NavigationItem(true, "/home", "Start", Icons.home, false);
  }
}

// helper class used to represent navigation list items
class _NavigationItem {
  final bool header;
  final String route;
  final String title;
  final IconData icon;
  final bool showInBottomBar;
  _NavigationItem(
      this.header, this.route, this.title, this.icon, this.showInBottomBar);
}
