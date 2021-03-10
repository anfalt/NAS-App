import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nas_app/Model/List.dart';
import 'package:nas_app/redux/List/ListStateAction.dart';
import 'package:nas_app/redux/store.dart';

class ListGallery extends StatelessWidget {
  const ListGallery({Key key = const Key("key"), required this.allLists}) : super(key: key);

  final List<ListElement> allLists;

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      primary: false,
      shrinkWrap: true,
      crossAxisCount: 4,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
      itemCount: allLists.length,
      itemBuilder: (BuildContext context, int index) =>
          getListGritItem(context, allLists[index]),
    );
  }

  Widget getListGritItem(BuildContext context, ListElement list) {
    var themeData = Theme.of(context);
    var previewListItems = list.items;

    return InkWell(
        onLongPress: () => {
              Redux.store!
                  .dispatch((store) => {fetchListMarkedAction(store, list.iD!)})
            },
        onTap: () => {
              Navigator.pushNamed(context, "/lists/items",
                  arguments: {"listId": list.iD})
            },
        child: Container(
          decoration: BoxDecoration(
              color: list.isMarked! ? themeData.accentColor : Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]),
          margin: EdgeInsets.all(10),
          child: ListTile(
              title: Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(list.title!, style: TextStyle(fontSize: 18)),
              ),
              subtitle: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: () {
                        List<Widget> widgets = [];
                        for (var i = 0; i < previewListItems.length; i++) {
                          widgets.add(Row(children: [
                            MyBullet(),
                            Expanded(
                                child: Text(previewListItems[i].title!,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: previewListItems[i].status ==
                                                ListItemStatus.done
                                            ? Colors.grey.withOpacity(0.7)
                                            : Colors.black.withOpacity(0.5),
                                        fontSize: 16,
                                        decoration:
                                            previewListItems[i].status ==
                                                    ListItemStatus.done
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none)))
                          ]));
                        }
                        return widgets;
                      }()))),
        ));
  }
}

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 5.0,
      width: 5.0,
      margin: EdgeInsets.only(right: 5),
      decoration: new BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
    );
  }
}
