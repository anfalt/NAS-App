import 'package:flutter/material.dart';
import 'package:nas_app/Services/ListService.dart';
import 'package:nas_app/redux/List/ListStateAction.dart';
import 'package:nas_app/redux/store.dart';

class ListemItemNewEntry extends StatefulWidget {
  const ListemItemNewEntry({Key key}) : super(key: key);
  State createState() => new _ListemItemNewEntryState();
}

class _ListemItemNewEntryState extends State<ListemItemNewEntry> {
  TextEditingController _itemTitleController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  final ListService listService = new ListService();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextField(
        controller: _itemTitleController,
        enabled: true,
        decoration: InputDecoration(
          hintText: 'Neuen Eintrag anlegen',
        ),
      ),
      leading: (() {
        return new IconButton(
            icon: Icon(Icons.star_outline, color: Colors.black),
            onPressed: () => {});
      })(),
      trailing: (() {
        return new IconButton(
            icon: Icon(Icons.save, color: Colors.black),
            onPressed: createNewItem);
      })(),
    );
  }

  void createNewItem() {
    listService
        .createListItem(_itemTitleController.text,
            Redux.store.state.listState.currentListId)
        .then((value) => Redux.store
            .dispatch((store) => fetchAllListsAction(store, listService)));
  }
}
