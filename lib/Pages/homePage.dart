import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:nas_app/Model/List.dart';
import 'package:nas_app/Navigation/appBottomNavBar.dart';
import 'package:nas_app/Services/ListService.dart';
import 'package:nas_app/Services/PhotoService.dart';
import 'package:nas_app/Widgets/Gallery/PhotoSlider.dart' as PhotoSlider;
import 'package:nas_app/Widgets/Lists/ListGallery.dart';
import 'package:nas_app/redux/Asset/AssetStateAction.dart';
import 'package:nas_app/redux/List/ListState.dart';
import 'package:nas_app/redux/List/ListStateAction.dart';
import 'package:nas_app/redux/store.dart';

import '../settings.dart' as settings;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) {
          store.dispatch((store) => fetchLatestAssetMarkedAction(
              store,
              new PhotoService(),
              Redux.store!.state!.userState!.user!.photoSessionId!));
          store.dispatch((store) => fetchAllListsAction(
              store, new ListService(), Redux.store!.state.userState!.user!));
        },
        builder: (context, appState) {
          return Scaffold(
              backgroundColor: Colors.grey[150],
              appBar: AppBar(title: Text("Start")),
              bottomNavigationBar: AppBottomNav(),
              body: SingleChildScrollView(
                  child: (() {
                if (!isStateLoading(appState)) {
                  if (isStateError(appState)) {
                    SchedulerBinding.instance!.addPostFrameCallback((_) {
                      showFailedDialog(context, getStateErrorMessage(appState));
                    });
                  } else {
                    return Column(children: [
                      getLatestImagesCard(context, appState),
                      getLatestListsCard(context, appState)
                    ]);
                  }
                } else {
                  return Container(
                      height: 400,
                      child: Center(child: CircularProgressIndicator()));
                }
              }())));
        });
  }
}

isStateLoading(AppState appState) {
  return appState.assetState!.isLoading! ||
      appState.listState!.isLoading! ||
      appState.userState!.isLoading!;
}

isStateError(AppState appState) {
  return appState.assetState!.isError! ||
      appState.listState!.isError! ||
      appState.userState!.isError!;
}

getStateErrorMessage(AppState appState) {
  return appState.userState!.isError!
      ? appState.userState!.errorMessage
      : appState.listState!.isError!
          ? appState.listState!.errorMessage
          : appState.assetState!.errorMessage;
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

Widget getLatestImagesCard(BuildContext context, AppState appState) {
  if (appState.assetState!.latestAssets!.length == 0) {
    return Padding(padding: EdgeInsets.all(8.0), child:TextButton(
      
      onPressed: () {
        Navigator.pushNamed(context, "/images");
      },
      child: Text(
        "Es wurden keine neuen Bilder hochgeladen.",
        style: TextStyle(fontSize: 18.0),
      ),
    ));
  } else {
    return ListTile(
        title: Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text("Aktuelle Bilder",
                style: TextStyle(fontSize: 20, color: Colors.grey[800]))),
        subtitle: Card(
            child: Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: PhotoSlider.getCarouselForHomePage(
                    context,
                    appState.assetState!.latestAssets!,
                    appState.userState!.user!))));
  }
}

Widget getLatestListsCard(BuildContext context, AppState appState) {
  var userSeesLists =
      settings.taskListUsers.indexOf(appState.userState!.user!.name!) > -1;
  if (!userSeesLists) {
    return Container();
  }

  var latestListItems = getLatestLists(appState.listState!);
  latestListItems.sort((l1, l2) {
    var latestItemL1 = DateTime.parse(l1.items[0].modified!);
    var latestItemL2 = DateTime.parse(l2.items[0].modified!);
    return latestItemL2.difference(latestItemL1).inSeconds;
  });

  if (latestListItems.length == 0) {
    return Padding(padding: EdgeInsets.all(8.0),child:TextButton(
      
      onPressed: () {
        Navigator.pushNamed(context, "/lists");
      },
      child: Text(
        "Es wurden keine neuen Enträge gefunden.",
        style: TextStyle(fontSize: 18.0),
      ),
    ));
  } else {
    return ListTile(
        title: Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text("Aktuelle Todos",
                style: TextStyle(fontSize: 20, color: Colors.grey[800]))),
        subtitle: Container(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: ListGallery(
              allLists: latestListItems,
            )));
  }
}

List<ListElement> getLatestLists(ListState listState) {
  List<ListElement> result = [];
  listState.allLists!.forEach((element) {
    var latestListItems = getLatestListItems(element.items);
    latestListItems.sort((el1, el2) {
      var d1 = DateTime.parse(el1.modified!);
      var d2 = DateTime.parse(el2.modified!);
      return d2.difference(d1).inSeconds;
    });
    if (latestListItems.isNotEmpty) {
      var listEl = new ListElement(
          createdDate: element.createdDate,
          iD: element.iD,
          isDeleted: element.isDeleted,
          modified: element.modified,
          title: element.title);
      listEl.items = latestListItems.toList();
      result.add(listEl);
    }
  });
  return result;
}

List<ListItem> getLatestListItems(List<ListItem> items) {
  return items.where((item) {
    var diff = new DateTime.now().difference(DateTime.parse(item.createdDate!));
    return diff.inDays < 7 && item.status == ListItemStatus.open;
  }).toList();
}
