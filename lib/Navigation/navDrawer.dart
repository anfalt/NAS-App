import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nas_app/Pages/logInPage.dart';

import '../bloc/nav_drawer_bloc.dart';
import '../bloc/nav_drawer_event.dart';
import '../bloc/nav_drawer_state.dart';
import "../globals.dart" as globals;

class NavDrawerWidget extends StatelessWidget {
  final String accountName;
  final List<_NavigationItem> _listItems = [
    _NavigationItem(true, null, null, null),
    _NavigationItem(false, NavItem.homePage, "Start", Icons.home),
    _NavigationItem(false, NavItem.imagePage, "Bilder", Icons.image),
    _NavigationItem(false, NavItem.calendarPage, "Kalender", Icons.event)
  ];
  NavDrawerWidget(this.accountName);

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
  Widget build(BuildContext context) => Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: Container(
        color: Colors.white,
        child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: _listItems.length,
            itemBuilder: (BuildContext context, int index) =>
                BlocBuilder<NavDrawerBloc, NavDrawerState>(
                  builder: (BuildContext context, NavDrawerState state) =>
                      _buildItem(_listItems[index], state, context),
                )),
      ));
  Widget _buildItem(
          _NavigationItem data, NavDrawerState state, BuildContext context) =>
      data.header
          // if the item is a header return the header widget
          ? _makeHeaderItem(context)
          // otherwise build and return the default list item
          : _makeListItem(data, state, context);

  Widget _makeHeaderItem(BuildContext context) => Container(
      height: 100,
      child: DrawerHeader(
        child: Row(
          children: [
            Text(accountName, style: TextStyle(color: Colors.white)),
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

  Widget _makeListItem(
          _NavigationItem data, NavDrawerState state, BuildContext context) =>
      Card(
        color: data.item == state.selectedItem
            ? Theme.of(context).accentColor
            : Colors.white,
        shape: ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
        // So we see the selected highlight
        borderOnForeground: true,
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Builder(
          builder: (BuildContext context) => ListTile(
            title: Text(
              data.title,
              style: TextStyle(
                color: data.item == state.selectedItem
                    ? Theme.of(context).textTheme.headline1.color
                    : Theme.of(context).primaryColor,
              ),
            ),
            leading: Icon(
              data.icon,
              // if it's selected change the color
              color: data.item == state.selectedItem
                  ? Theme.of(context).accentIconTheme.color
                  : Theme.of(context).primaryColor,
            ),
            onTap: () => _handleItemClick(context, data.item),
          ),
        ),
      );
  void _handleItemClick(BuildContext context, NavItem item) {
    BlocProvider.of<NavDrawerBloc>(context).add(NavigateTo(item));
    Navigator.pop(context);
  }
}

// helper class used to represent navigation list items
class _NavigationItem {
  final bool header;
  final NavItem item;
  final String title;
  final IconData icon;
  _NavigationItem(this.header, this.item, this.title, this.icon);
}
