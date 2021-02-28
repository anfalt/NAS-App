import 'package:meta/meta.dart';
import 'package:nas_app/Model/List.dart';
import 'package:nas_app/Model/User.dart';
import 'package:nas_app/Services/ListService.dart';
import 'package:nas_app/Services/NotificationService.dart';
import 'package:redux/redux.dart';

import '../../settings.dart' as settings;
import '../store.dart';
import 'ListState.dart';

@immutable
class SetListsStateAction {
  final ListState listState;

  SetListsStateAction(this.listState);
}

NotificationService notificationService = new NotificationService();

Future<void> fetchListMarkedAction(Store<AppState> store, String listId) async {
  var allLists = store.state.listState.allLists.map((el) {
    if (el.iD == listId) {
      el.isMarked = !el.isMarked;
    }
    return el;
  }).toList();

  store.dispatch(SetListsStateAction(ListState(allLists: allLists)));
}

Future<void> fetchListItemEnabledAction(
    Store<AppState> store, String listItemId) async {
  var currentListID = store.state.listState.currentListId;

  var currentList = store.state.listState.allLists
      .firstWhere((element) => element.iD == currentListID);
  var item =
      currentList.items.firstWhere((element) => element.iD == listItemId);
  item.isEnabled = !item.isEnabled;
  store.dispatch(SetListsStateAction(ListState()));
}

Future<void> fetchSetCurrrentListAction(
    Store<AppState> store, String listId) async {
  store.dispatch(SetListsStateAction(ListState(currentListId: listId)));
}

Future<void> fetchAllListsAction(
    Store<AppState> store, ListService listService, User user) async {
  if (settings.taskListUsers.indexOf(user.name) < 0) {
    return;
  }
  store.dispatch(SetListsStateAction(
      ListState(isLoading: true, isError: false, errorMessage: "")));
  var listApiReponse = await listService.getAllLists();
  if (!listApiReponse.success) {
    store.dispatch(SetListsStateAction(ListState(
        isLoading: false,
        isError: true,
        errorMessage: listApiReponse.errorMessage)));
  } else {
    store.dispatch(SetListsStateAction(
        ListState(isLoading: false, allLists: listApiReponse.body)));
  }
}

Future<void> fetchUpdateListAction(Store<AppState> store,
    ListService listService, String listTitle, String listId) async {
  var listApiReponse = await listService.updateList(listTitle, listId);

  if (!listApiReponse.success) {
    store.dispatch(SetListsStateAction(ListState(
        isLoading: false,
        isError: true,
        errorMessage: listApiReponse.errorMessage)));
  } else {
    var updatedLists = store.state.listState.allLists.map((element) {
      if (element.iD == listId) {
        element.title = listTitle;
      }

      return element;
    }).toList();

    store.dispatch(SetListsStateAction(
        ListState(isLoading: false, allLists: updatedLists)));
  }
}

Future<void> fetchUpdateListItemAction(
    Store<AppState> store,
    ListService listService,
    String itemTitle,
    String itemId,
    ListItemStatus itemStatus) async {
  var listApiReponse = await listService.updateListItem(
      itemTitle, itemId, itemStatus.index.toString());

  if (!listApiReponse.success) {
    store.dispatch(SetListsStateAction(ListState(
        isLoading: false,
        isError: true,
        errorMessage: listApiReponse.errorMessage)));
  } else {
    var currentListID = store.state.listState.currentListId;
    var currentList = store.state.listState.allLists
        .firstWhere((element) => element.iD == currentListID);
    var item = currentList.items.firstWhere((element) => element.iD == itemId);

    String message = "Listeneintrag " + itemTitle + " wurde aktualisiert";

    if (item.title != itemTitle) {
      message =
          "Eintrag " + item.title + " wurde in " + itemTitle + " umbenannet";
    } else if (item.status != itemStatus) {
      if (itemStatus == ListItemStatus.done) {
        message = "Eintrag erledigt: ";
      } else if (itemStatus == ListItemStatus.deleted) {
        message = "Eintrag gelöscht: ";
      } else if (itemStatus == ListItemStatus.open) {
        message = "Eintrag offen: ";
      }

      message += itemTitle;
    }

    item.title = itemTitle;
    item.status = itemStatus;
    item.isEnabled = false;
    item.modified = DateTime.now().toIso8601String();
    notificationService.sendNotification(message, message);
    store.dispatch(SetListsStateAction(
        ListState(isLoading: false, allLists: store.state.listState.allLists)));
  }
}

Future<void> fetchDeleteListAction(
    Store<AppState> store, ListService listService, String listId) async {
  var listApiReponse = await listService.deleteList(listId);

  if (!listApiReponse.success) {
    store.dispatch(SetListsStateAction(ListState(
        isLoading: false,
        isError: true,
        errorMessage: listApiReponse.errorMessage)));
  } else {
    var listTitle = store.state.listState.allLists
        .firstWhere((element) => element.iD == listId)
        .title;
    store.state.listState.allLists
        .removeWhere((element) => element.iD == listId);
    String message = "Liste gelöscht: " + listTitle;
    notificationService.sendNotification(message, message);
    store.dispatch(SetListsStateAction(ListState(isLoading: false)));
  }
}

Future<void> fetchDeleteListItemAction(
    Store<AppState> store, ListService listService, String itemId) async {
  var listApiReponse = await listService.deleteListItem(itemId);

  if (!listApiReponse.success) {
    store.dispatch(SetListsStateAction(ListState(
        isLoading: false,
        isError: true,
        errorMessage: listApiReponse.errorMessage)));
  } else {
    var currentListID = store.state.listState.currentListId;
    var currentList = store.state.listState.allLists
        .firstWhere((element) => element.iD == currentListID);
    String elementTitle =
        currentList.items.firstWhere((element) => element.iD == itemId).title;
    currentList.items.removeWhere((element) => element.iD == itemId);
    String message = "Eintrag gelöscht: " + elementTitle;
    notificationService.sendNotification(message, message);
    store.dispatch(SetListsStateAction(ListState(isLoading: false)));
  }
}

Future<void> fetchCreateListItemAction(
    Store<AppState> store, ListService listService, String itemTitle) async {
  var listApiReponse = await listService.createListItem(
      itemTitle, store.state.listState.currentListId);

  if (!listApiReponse.success) {
    store.dispatch(SetListsStateAction(ListState(
        isLoading: false,
        isError: true,
        errorMessage: listApiReponse.errorMessage)));
  } else {
    var item = new ListItem();
    item.title = itemTitle;
    item.status = ListItemStatus.open;
    item.listID = store.state.listState.currentListId;
    item.createdDate = DateTime.now().toIso8601String();
    item.modified = DateTime.now().toIso8601String();

    var currentListID = store.state.listState.currentListId;

    var currentList = store.state.listState.allLists
        .firstWhere((element) => element.iD == currentListID);

    currentList.items.add(item);

    String message =
        "Neuer Eintrag in " + currentList.title + " : " + itemTitle;
    notificationService.sendNotification(message, message);
    store.dispatch(SetListsStateAction(ListState(isLoading: false)));
  }
}
