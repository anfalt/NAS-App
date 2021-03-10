import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nas_app/Model/List.dart';
import 'package:nas_app/Services/ListService.dart';
import 'package:nas_app/redux/List/ListStateAction.dart';
import 'package:nas_app/redux/store.dart';

class ListItemRow extends StatefulWidget {
  const ListItemRow({Key key = const Key("key"), required this.listItem}) : super(key: key);

  final ListItem listItem;
  State createState() => new _ListItemRowState();
}

class _ListItemRowState extends State<ListItemRow> {
  TextEditingController _itemTitleController = new TextEditingController();
  FocusNode? focusNode;

  @override
  void initState() {
    _itemTitleController.text = widget.listItem.title!;
    _itemTitleController.selection = TextSelection.fromPosition(
        TextPosition(offset: _itemTitleController.text.length));

    focusNode = new FocusNode();

    focusNode!.addListener(() {
      if (!focusNode!.hasFocus) {
        Redux.store!.dispatch((store) => fetchUpdateListItemAction(
            store,
            listService,
            _itemTitleController.text,
            widget.listItem.iD!,
            widget.listItem.status!));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    focusNode!.dispose();
    super.dispose();
  }

  final ListService listService = new ListService();
  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
            caption: 'Löschen',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => {
                  Redux.store!.dispatch((store) => fetchDeleteListItemAction(
                      store, listService, widget.listItem.iD!))
                }),
      ],
      child: (() {
        if (widget.listItem.status == ListItemStatus.done) {
          return ListTile(
              onTap: markItemAsOpen,
              title: Text(
                _itemTitleController.text,
                style: TextStyle(decoration: TextDecoration.lineThrough),
              ),
              leading: new IconButton(
                  icon: Icon(Icons.check_box_outlined, color: Colors.black),
                  onPressed: markItemAsOpen));
        } else if (widget.listItem.isEnabled) {
          return ListTile(
              title: TextField(
                focusNode: focusNode,
                controller: _itemTitleController,
                autocorrect: false,
                enableSuggestions: false,
                enabled: true,
                autofocus: false,
                onSubmitted: (String text) =>
                    updateItem(widget.listItem.iD!, widget.listItem.status!),
              ),
              leading: (() {
                if (widget.listItem.status == ListItemStatus.open) {
                  return new IconButton(
                      icon: Icon(Icons.check_box_outline_blank,
                          color: Colors.black),
                      onPressed: markItemAsDone);
                } else {
                  return new IconButton(
                      icon: Icon(Icons.check_box_outlined, color: Colors.black),
                      onPressed: markItemAsOpen);
                }
              }()),
              trailing: new IconButton(
                  icon: Icon(Icons.save, color: Colors.black),
                  onPressed: () => {
                        updateItem(widget.listItem.iD!, widget.listItem.status!)
                      }));
        } else {
          return ListTile(
              title: GestureDetector(
                  child: Text(_itemTitleController.text),
                  onLongPress: markItemAsDone,
                  onDoubleTap: () => Redux.store!.dispatch((store) =>
                      fetchDeleteListItemAction(
                          store, listService, widget.listItem.iD!)),
                  onTap: () {
                    focusNode!.requestFocus();
                    Redux.store!.dispatch((store) =>
                        fetchListItemEnabledAction(store, widget.listItem.iD!));
                  }),
              leading: new IconButton(
                  icon:
                      Icon(Icons.check_box_outline_blank, color: Colors.black),
                  onPressed: markItemAsDone));
        }
      }()),
    );
  }

  void markItemAsDone() {
    var newStatus = ListItemStatus.done;
    Redux.store!.dispatch((store) => fetchUpdateListItemAction(store,
        listService, widget.listItem.title!, widget.listItem.iD!, newStatus));
  }

  void markItemAsOpen() {
    var newStatus = ListItemStatus.open;

    Redux.store!.dispatch((store) => fetchUpdateListItemAction(store,
        listService, widget.listItem.title!, widget.listItem.iD!, newStatus));
  }

  void saveNewItem() {
    widget.listItem.title = _itemTitleController.text;
    Redux.store!.dispatch((store) => fetchCreateListItemAction(
        store, listService, _itemTitleController.text));
  }

  void updateItem(String itemId, ListItemStatus itemStatus) {
    widget.listItem.title = _itemTitleController.text;
    Redux.store!.dispatch((store) => fetchUpdateListItemAction(
        store, listService, _itemTitleController.text, itemId, itemStatus));
    focusNode!.previousFocus();
  }
}
