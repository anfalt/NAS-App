import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nas_app/Services/PhotoService.dart';
import 'package:nas_app/Widgets/FloatingActionButtons/FloatingActionButtonItem.dart';
import 'package:nas_app/Widgets/FloatingActionButtons/ListPage/AddListFloatingActionButton.dart';

class ListFloatingActionButton extends StatefulWidget {
  final PhotoService photoService = new PhotoService();
  @override
  State createState() => new _ListFloatingActionButtonState();
}

class _ListFloatingActionButtonState extends State<ListFloatingActionButton>
    with TickerProviderStateMixin {
  AnimationController _controller;

  List<FloatingActionButtonItem> actions;

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    actions = [];

    actions.add(AddListFloatingActionButton(onSelectNotificationUpload));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: new List.generate(actions.length, (int index) {
        Widget child = new Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: new ScaleTransition(
            scale: new CurvedAnimation(
              parent: _controller,
              curve: new Interval(0.0, 1.0 - index / actions.length / 2.0,
                  curve: Curves.easeOut),
            ),
            child: new FloatingActionButton(
              heroTag: null,
              backgroundColor: Theme.of(context).backgroundColor,
              mini: true,
              child: new Icon(actions[index].icon,
                  color: Theme.of(context).iconTheme.color),
              onPressed: () => {actions[index].onPressed(context)},
            ),
          ),
        );
        return child;
      }).toList()
        ..add(
          new FloatingActionButton(
            heroTag: null,
            child: new AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return new Transform(
                  transform:
                      new Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                  alignment: FractionalOffset.center,
                  child: new Icon(
                      _controller.isDismissed ? Icons.add : Icons.close),
                );
              },
            ),
            onPressed: () {
              if (_controller.isDismissed) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
          ),
        ),
    );
  }

  Future<void> onSelectNotificationUpload(String json) async {
    final obj = jsonDecode(json);

    if (obj['success']) {
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }
}
