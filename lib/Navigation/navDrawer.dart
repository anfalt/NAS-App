import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/nav_drawer_bloc.dart';
import '../bloc/nav_drawer_event.dart';
import '../bloc/nav_drawer_state.dart';

class NavDrawerWidget extends StatelessWidget {
  final String accountName;
  final String accountEmail;
  final List<_NavigationItem> _listItems = [
    _NavigationItem(true, null, null, null),
    _NavigationItem(false, NavItem.homePage, "First Page", Icons.looks_one),
    _NavigationItem(false, NavItem.imagePage, "Second Page", Icons.looks_two),
    _NavigationItem(false, NavItem.calendarPage, "Third Page", Icons.looks_3)
  ];
  NavDrawerWidget(this.accountName, this.accountEmail);
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
                      _buildItem(_listItems[index], state),
                )),
      ));
  Widget _buildItem(_NavigationItem data, NavDrawerState state) => data.header
      // if the item is a header return the header widget
      ? _makeHeaderItem()
      // otherwise build and return the default list item
      : _makeListItem(data, state);
  Widget _makeHeaderItem() => UserAccountsDrawerHeader(
        accountName: Text(accountName, style: TextStyle(color: Colors.white)),
        accountEmail: Text(accountEmail, style: TextStyle(color: Colors.white)),
        decoration: BoxDecoration(color: Colors.blueGrey),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.amber,
          child: Icon(
            Icons.person,
            size: 54,
          ),
        ),
      );
  Widget _makeListItem(_NavigationItem data, NavDrawerState state) => Card(
        color:
            data.item == state.selectedItem ? Colors.greenAccent : Colors.white,
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
                    ? Colors.blue
                    : Colors.blueGrey,
              ),
            ),
            leading: Icon(
              data.icon,
              // if it's selected change the color
              color: data.item == state.selectedItem
                  ? Colors.blue
                  : Colors.blueGrey,
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
