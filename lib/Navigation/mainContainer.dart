import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nas_app/Pages/calendarPage.dart';
import 'package:nas_app/Pages/homePage.dart';
import 'package:nas_app/Pages/imagesPage.dart';

import './navDrawer.dart';
import '../bloc/nav_drawer_bloc.dart';
import '../bloc/nav_drawer_state.dart';

class MainContainerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NavDrawerBloc>(
        create: (BuildContext context) => NavDrawerBloc(),
        child: BlocBuilder<NavDrawerBloc, NavDrawerState>(
          builder: (BuildContext context, NavDrawerState state) => Scaffold(
            drawer: NavDrawerWidget("Joe Shmoe", "shmoe@joesemail.com"),
            appBar: AppBar(
              title: Text(_getTextForItem(state.selectedItem)),
            ),
            body: _bodyForState(state),
            //floatingActionButton: _getFabForItem(state.selectedItem)),
          ),
        ));
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

  // _getFabForItem(NavItem item) {
  //   switch (item) {
  //     case NavItem.calendarPage:
  //       {
  //         return "Kalendar";
  //       }
  //       break;

  //     case NavItem.homePage:
  //       {
  //         return "Start";
  //       }
  //       break;

  //     case NavItem.imagePage:
  //       {
  //         return "Bilder";
  //       }
  //       break;
  //   }
  //}
}
