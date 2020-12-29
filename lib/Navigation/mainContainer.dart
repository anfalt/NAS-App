import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nas_app/Navigation/floatinActionButtons/fabImagesPage.dart';
import 'package:nas_app/Pages/calendarPage.dart';
import 'package:nas_app/Pages/homePage.dart';
import 'package:nas_app/Pages/imagesPage.dart';

import './navDrawer.dart';
import '../bloc/nav_drawer_bloc.dart';
import '../bloc/nav_drawer_state.dart';
import "../globals.dart" as globals;

class MainContainer extends StatefulWidget {
  @override
  _MainContainerState createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NavDrawerBloc>(
      create: (BuildContext context) => NavDrawerBloc(),
      child: BlocBuilder<NavDrawerBloc, NavDrawerState>(
        builder: (BuildContext context, NavDrawerState state) => Scaffold(
            key: _scaffoldKey,
            drawer: NavDrawerWidget(globals.user.name),
            appBar: AppBar(
              title: Text(_getTextForItem(state.selectedItem)),
            ),
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
            body: _bodyForState(state)),
        //floatingActionButton: _getFabForItem(state.selectedItem)),
      ),
    );
  }

  _getTextForItem(NavItem item) {
    switch (item) {
      case NavItem.calendarPage:
        {
          return "Kalendar";
        }
        break;

      case NavItem.homePage:
        {
          return "Start";
        }
        break;

      case NavItem.imagePage:
        {
          return "Bilder";
        }
        break;
    }
  }

  _bodyForState(NavDrawerState state) {
    switch (state.selectedItem) {
      case NavItem.calendarPage:
        {
          return new CalendarPage();
        }
        break;

      case NavItem.homePage:
        {
          return new HomePage();
        }
        break;

      case NavItem.imagePage:
        {
          return new ImagesPage();
        }
        break;
    }
  }

  _getFabForItem(NavItem item) {
    switch (item) {
      case NavItem.calendarPage:
        {
          return new FabImagesPage();
        }
        break;

      case NavItem.homePage:
        {
          return new FabImagesPage();
        }
        break;

      case NavItem.imagePage:
        {
          return new FabImagesPage();
        }
        break;
    }
  }
}
