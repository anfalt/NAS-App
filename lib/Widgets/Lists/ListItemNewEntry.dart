import 'package:flutter/material.dart';
import 'package:nas_app/Services/ListService.dart';
import 'package:nas_app/redux/List/ListStateAction.dart';
import 'package:nas_app/redux/store.dart';

class ListemItemNewEntry extends StatefulWidget {
  const ListemItemNewEntry({Key key = const Key("key")}) : super(key: key);
  State createState() => new _ListemItemNewEntryState();
}

class _ListemItemNewEntryState extends State<ListemItemNewEntry> {
  TextEditingController _itemTitleController = new TextEditingController();
  FocusNode? focusNode;

  @override
  void initState() {
    focusNode = new FocusNode();
    
    super.initState();
  }

  final ListService listService = new ListService();
  @override
  Widget build(BuildContext context) {
    var allLists = Redux.store!.state.listState?.allLists;
    var currentList =  allLists!.firstWhere((element) => element.iD == Redux.store!.state.listState?.currentListId);
    if(focusNode != null && currentList.items.where((element) => element.isEnabled).length==0)
    {
      focusNode!.requestFocus();
    }
    return ListTile(
      title: TextField(
        controller: _itemTitleController,
        focusNode: focusNode,
        enableSuggestions:true,
        enabled: true,
        onSubmitted: (String text)=>createNewItem(),
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
    Redux.store!.dispatch((store) => fetchCreateListItemAction(
        store, listService, _itemTitleController.text));
  }
}
