import 'package:meta/meta.dart';
import 'package:nas_app/Model/List.dart';
import 'package:nas_app/Services/ListService.dart';
import 'package:redux/redux.dart';

import '../store.dart';
import 'ListState.dart';

@immutable
class SetListsStateAction {
  final ListState listState;

  SetListsStateAction(this.listState);
}

Future<void> fetchListMarkedAction(Store<AppState> store, String listId) async {
  var allLists = store.state.listState.allLists.map((el) {
    if (el.iD == listId) {
      el.isMarked = !el.isMarked;
    }
    return el;
  }).toList();

  store.dispatch(SetListsStateAction(ListState(allLists: allLists)));
}

Future<void> fetchSetCurrrentListAction(
    Store<AppState> store, String listId) async {
  store.dispatch(SetListsStateAction(ListState(currentListId: listId)));
}

Future<void> fetchAllListsAction(
    Store<AppState> store, ListService listService) async {
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

Future<void> fetchUpdateListItemAction(
    Store<AppState> store,
    ListService listService,
    String itemTitle,
    String itemId,
    ListItemStatus itemStatus) async {
  store.dispatch(SetListsStateAction(
      ListState(isLoading: true, isError: false, errorMessage: "")));

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

    item.title = itemTitle;
    item.status = itemStatus;
    store.dispatch(SetListsStateAction(
        ListState(isLoading: false, allLists: store.state.listState.allLists)));
  }
}

Future<void> fetchDeleteListAction(
    Store<AppState> store, ListService listService, String listId) async {
  store.dispatch(SetListsStateAction(
      ListState(isLoading: true, isError: false, errorMessage: "")));

  var listApiReponse = await listService.deleteList(listId);

  if (!listApiReponse.success) {
    store.dispatch(SetListsStateAction(ListState(
        isLoading: false,
        isError: true,
        errorMessage: listApiReponse.errorMessage)));
  } else {
    store.state.listState.allLists
        .removeWhere((element) => element.iD == listId);

    store.dispatch(SetListsStateAction(ListState(isLoading: false)));
  }
}

Future<void> fetchDeleteListItemAction(
    Store<AppState> store, ListService listService, String itemId) async {
  store.dispatch(SetListsStateAction(
      ListState(isLoading: true, isError: false, errorMessage: "")));

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
    currentList.items.removeWhere((element) => element.iD == itemId);

    store.dispatch(SetListsStateAction(ListState(isLoading: false)));
  }
}

Future<void> fetchCreateListItemAction(
    Store<AppState> store, ListService listService, String itemTitle) async {
  store.dispatch(SetListsStateAction(
      ListState(isLoading: true, isError: false, errorMessage: "")));

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

    var currentListID = store.state.listState.currentListId;

    var currentList = store.state.listState.allLists
        .firstWhere((element) => element.iD == currentListID);

    currentList.items.add(item);

    store.dispatch(SetListsStateAction(ListState(isLoading: false)));
  }
}
