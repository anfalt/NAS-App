
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:nas_app/Model/List.dart';
import 'package:nas_app/Navigation/appBottomNavBar.dart';
import 'package:nas_app/Services/ListService.dart';
import 'package:nas_app/Widgets/Lists/ListItemGallery.dart';
import 'package:nas_app/redux/List/ListState.dart';
import 'package:nas_app/redux/List/ListStateAction.dart';
import 'package:nas_app/redux/User/UserState.dart';
import 'package:nas_app/redux/store.dart';
import 'package:redux/redux.dart';

class ListItemsPage extends StatefulWidget {
  const ListItemsPage({Key key = const Key("key")}) : super(key: key);
  @override
  _ListItemsPageState createState() => new _ListItemsPageState();
}

class _ListItemsPageState extends State<ListItemsPage> {
  ListService? listService;
  String? listId;

  @override
  void initState() {
    listService = new ListService();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    listId = arguments["listId"];

    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) => store
            .dispatch((store) => fetchSetCurrrentListAction(store, listId!)),
        builder: (context, appState) {
          return Scaffold(
              appBar: AppBar(
                title: (() {
                  var currentList = getCurrentListByID(appState.listState!);
                  if (currentList != null) {
                    return Text(currentList.title!);
                  } else {
                    return Text("Loading");
                  }
                }()),
                actions:
                    getAppBarActions(appState.listState!, appState.userState!),
              ),
              bottomNavigationBar: AppBottomNav(),
              body: (() {
                if (!appState.listState!.isLoading!) {
                  if (appState.listState!.isError!) {
                    SchedulerBinding.instance!.addPostFrameCallback((_) {
                      showFailedDialog(
                          context, appState.listState!.errorMessage!);
                    });
                  } else {
                    var currentList = getCurrentListByID(appState.listState!);
                    if (currentList != null) {
                      return ListItemGallery(currentList.items);
                    } else {
                      Navigator.pushNamed(context, "/lists");
                    }
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }()));
        });
  }

  showFailedDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Fehler beim Laden der Bilder"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget getFloatingActionButton() {
    return Container();
  }

  List<Widget> getAppBarActions(ListState listState, UserState userState) {
    List<Widget> appBarActions = [];

    appBarActions.add(IconButton(
        icon: Icon(Icons.refresh), onPressed: () => {reloadLists(userState)}));
    return appBarActions;
  }

  void reloadLists(UserState userState) {
    Redux.store!.dispatch((Store<AppState> store) =>
        fetchAllListsAction(store, listService!, userState.user!));
  }

  ListElement? getCurrentListByID(ListState listState) {
    if (listState != null &&
        listState.allLists != null &&
        listState.currentListId != null) {
      return listState.allLists!
          .firstWhere((element) => element.iD == listState.currentListId);
    } else {
      return null;
    }
  }
}
