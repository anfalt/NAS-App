import 'package:flutter/material.dart';
import 'package:nas_app/Model/List.dart';
import 'package:nas_app/Pages/listItemPage.dart';
import 'package:nas_app/redux/List/ListStateAction.dart';
import 'package:nas_app/redux/store.dart';
import "package:responsive_grid/responsive_grid.dart";

class ListGallery extends StatelessWidget {
  const ListGallery({Key key, @required this.allLists}) : super(key: key);

  final List<ListElement> allLists;

  @override
  Widget build(BuildContext context) {
    return ResponsiveGridList(
        desiredItemWidth: 150,
        minSpacing: 10,
        children: allLists.map((list) {
          return getListGritItem(context, list);
        }).toList());
  }

  Widget getListGritItem(BuildContext context, ListElement list) {
    return InkWell(
        onLongPress: () => {
              Redux.store
                  .dispatch((store) => {fetchListMarkedAction(store, list.iD)})
            },
        onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return ListItemsPage(list.iD);
              }))
            },
        child: Card(
          child: Text(list.title),
          shadowColor:
              list.isMarked ? Theme.of(context).accentColor : Colors.white,
        ));
  }
}
