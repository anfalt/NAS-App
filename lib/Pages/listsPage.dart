
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:nas_app/Model/List.dart';
import 'package:nas_app/Navigation/appBottomNavBar.dart';
import 'package:nas_app/Services/ListService.dart';
import 'package:nas_app/Widgets/Lists/ListGallery.dart';
import 'package:nas_app/redux/List/ListState.dart';
import 'package:nas_app/redux/List/ListStateAction.dart';
import 'package:nas_app/redux/User/UserState.dart';
import 'package:nas_app/redux/store.dart';
import 'package:redux/redux.dart';

import "../Widgets/FloatingActionButtons/ListPage/ListFloatingActionButton.dart";

class ListsPage extends StatefulWidget {
  @override
  _ListsPageState createState() => new _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  ListService? listService;
  TextEditingController _textController = new TextEditingController();
  @override
  void initState() {
    listService = new ListService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) => store.dispatch((store) => fetchAllListsAction(
            store, listService!, store.state.userState.user)),
        builder: (context, appState) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Listen"),
                actions:
                    getAppBarActions(appState.listState!, appState.userState!),
              ),
              floatingActionButton: ListFloatingActionButton(),
              bottomNavigationBar: AppBottomNav(),
              body: (() {
                if (!appState.listState!.isLoading!) {
                  if (appState.listState!.isError!) {
                    SchedulerBinding.instance!.addPostFrameCallback((_) {
                      showFailedDialog(
                          context, appState.listState!.errorMessage!);
                    });
                  } else {
                    return ListGallery(allLists: appState.listState!.allLists!);
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
    List<ListElement> markedLists = [];
    if (listState.allLists == null) {
      return appBarActions;
    } else {
      markedLists = listState.allLists!.where((el) {
        return el.isMarked!;
      }).toList();
    }

    if (markedLists.length > 0) {
      appBarActions.add(IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => {deleteLists(markedLists, userState)}));
    }

    if (markedLists.length == 1) {
      appBarActions.add(IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => {displayAlbumEditDialog(context, markedLists[0])}));
    }

    appBarActions.add(IconButton(
        icon: Icon(Icons.refresh), onPressed: () => {reloadAsset(userState)}));
    return appBarActions;
  }

  void reloadAsset(UserState userState) {
    Redux.store!.dispatch((Store<AppState> store) =>
        fetchAllListsAction(store, listService!, userState.user!));
  }

  void displayAlbumEditDialog(BuildContext context, ListElement list) {
    _textController.text = list.title!;
    var dialog = new Dialog(
        child: Padding(
            padding: EdgeInsets.all(10),
            child: new Container(
                height: 100,
                child: ListView(
                  children: <Widget>[
                    new TextField(
                      decoration: new InputDecoration(hintText: "Album Name"),
                      controller: _textController,
                    ),
                    new TextButton(
                      child: new Text("Speichern "),
                      onPressed: () {
                        updateList(list.iD!, _textController.text);
                        Navigator.pop(context);
                      },
                    )
                  ],
                ))));

    showDialog(context: context, builder: (_) => dialog);
  }

  void updateList(String listId, String newListName) {
    Redux.store!.dispatch((store) {
      fetchUpdateListAction(store, listService!, newListName, listId);
    });
  }

  void deleteLists(Iterable<ListElement> lists, UserState userState) {
    var listIds = lists.map((el) => el.iD).toList();

    if (listIds.length > 0) {
      listIds.forEach((listId) {
        Redux.store!.dispatch(
            (store) => fetchDeleteListAction(store, listService!, listId!));
      });
    }
  }
}
