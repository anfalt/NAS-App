import 'package:flutter/material.dart';
import 'package:nas_app/Model/List.dart';
import 'package:nas_app/Services/ListService.dart';
import 'package:nas_app/redux/List/ListStateAction.dart';
import 'package:nas_app/redux/store.dart';

class ListItemRow extends StatefulWidget {
  const ListItemRow({Key key, @required this.listItem}) : super(key: key);

  final ListItem listItem;
  State createState() => new _ListItemRowState();
}

class _ListItemRowState extends State<ListItemRow> {
  bool _isEnabled = false;
  TextEditingController _itemTitleController = new TextEditingController();
  FocusNode focusNode;

  @override
  void initState() {
    _itemTitleController.text = widget.listItem.title;
    focusNode = new FocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        setState(() {
          _isEnabled = false;
        });
      }
    });
    super.initState();
  }

  final ListService listService = new ListService();
  @override
  Widget build(BuildContext context) {
    if (_isEnabled && widget.listItem.status != ListItemStatus.done) {
      focusNode.requestFocus();
      return ListTile(
        title: TextField(
          focusNode: focusNode,
          controller: _itemTitleController,
          enabled: true,
          autofocus: true,
        ),
        leading: (() {
          if (widget.listItem.status == ListItemStatus.open) {
            return new IconButton(
                icon: Icon(Icons.check_box_outline_blank, color: Colors.black),
                onPressed: markItemAsDone);
          } else {
            return new IconButton(
                icon: Icon(Icons.check_box_outlined, color: Colors.black),
                onPressed: markItemAsOpen);
          }
        }()),
        trailing: (() {
          if (_isEnabled) {
            return new IconButton(
                icon: Icon(Icons.save, color: Colors.black),
                onPressed: saveNewItem);
          }
        })(),
      );
    } else {
      return ListTile(
          title: GestureDetector(
              child: Text(_itemTitleController.text),
              onTap: () {
                setState(() {
                  _isEnabled = !_isEnabled;
                });
              }),
          leading: (() {
            if (widget.listItem.status == ListItemStatus.open) {
              return new IconButton(
                  icon:
                      Icon(Icons.check_box_outline_blank, color: Colors.black),
                  onPressed: markItemAsDone);
            } else {
              return new IconButton(
                  icon: Icon(Icons.check_box_outlined, color: Colors.black),
                  onPressed: markItemAsOpen);
            }
          }()));
    }
  }

  void markItemAsDone() {
    var newStatus = ListItemStatus.done;

    Redux.store.dispatch((store) => fetchUpdateListItemAction(store,
        listService, widget.listItem.title, widget.listItem.iD, newStatus));
  }

  void markItemAsOpen() {
    var newStatus = ListItemStatus.open;

    Redux.store.dispatch((store) => fetchUpdateListItemAction(store,
        listService, widget.listItem.title, widget.listItem.iD, newStatus));
  }

  void saveNewItem() {
    widget.listItem.title = _itemTitleController.text;
    setState(() {
      _isEnabled = false;
    });
    Redux.store.dispatch((store) => fetchCreateListItemAction(
        store, listService, _itemTitleController.text));
  }
}
