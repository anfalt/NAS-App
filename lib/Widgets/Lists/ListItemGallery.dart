import 'package:flutter/material.dart';
import 'package:nas_app/Model/List.dart';
import 'package:nas_app/Widgets/Lists/ListItemNewEntry.dart';
import 'package:nas_app/Widgets/Lists/ListItemRow.dart';

class ListItemGallery extends StatefulWidget {
  @override
  _ListItemGalleryState createState() => _ListItemGalleryState();
  final List<ListItem> listItems;
  ListItemGallery(this.listItems);
}

class _ListItemGalleryState extends State<ListItemGallery> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: Key(widget.listItems.length.toString()),
      itemCount: widget.listItems.length + 1,
      itemBuilder: (context, index) {
        if (index < widget.listItems.length) {
          return ListItemRow(listItem: widget.listItems[index]);
        }
        if (index == widget.listItems.length) {
          return ListemItemNewEntry();
        } else {
          return Container();
        }
      },
    );
  }
}
