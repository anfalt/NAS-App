import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:nas_app/Navigation/appBottomNavBar.dart';
import 'package:nas_app/redux/User/UserAction.dart';
import 'package:nas_app/redux/User/UserState.dart';
import 'package:nas_app/redux/store.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserState>(
        converter: (store) => store.state.userState,
        onInit: (store) =>
            store.dispatch((store) => fetchGetUserSettingsAction(store)),
        builder: (context, userState) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Einstellungen"),
            ),
            bottomNavigationBar: AppBottomNav(),
            body: ListView(children: <Widget>[
              ListTile(
                title: Text(userState.user.name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                    icon: Icon(
                      Icons.logout,
                    ),
                    onPressed: () => {logoutUser(context)}),
              ),
              ListTile(
                  title: Text('Primärfarbe'),
                  trailing: ColorSetting(userState.userSettings.primaryColor,
                      setPrimaryColor, false)),
              ListTile(
                  title: Text('Sekundärfarbe'),
                  trailing: ColorSetting(userState.userSettings.accentColor,
                      setAccentColor, true)),
              ListTile(
                  title: Text('Comic Sans Schriftart'),
                  trailing: Switch(
                    onChanged: setUseComicSans,
                    value: userState.userSettings.useComicSansFont,
                  )),
              ListTile(
                  title: Text('Messaging Token'),
                  trailing: Container(
                      width: 100,
                      child: SelectableText(
                        userState.messagingToken != null
                            ? userState.messagingToken
                            : "",
                        toolbarOptions: ToolbarOptions(
                            copy: true,
                            selectAll: true,
                            cut: false,
                            paste: false),
                      ))),
            ]),
          );
        });
  }

  void logoutUser(
    BuildContext context,
  ) {
    Redux.store.dispatch(fetchUserLogOutAction);
    Navigator.of(context).pushNamed("/home");
  }

  setPrimaryColor(Color color) {
    var userSettings = Redux.store.state.userState.userSettings;
    userSettings.primaryColor = color;

    Redux.store
        .dispatch((store) => fetchSetUserSettingsAction(store, userSettings));
  }

  setAccentColor(Color color) {
    var userSettings = Redux.store.state.userState.userSettings;
    userSettings.accentColor = color;

    Redux.store
        .dispatch((store) => fetchSetUserSettingsAction(store, userSettings));
  }

  setUseComicSans(bool useComicSans) {
    var userSettings = Redux.store.state.userState.userSettings;
    userSettings.useComicSansFont = useComicSans;

    Redux.store
        .dispatch((store) => fetchSetUserSettingsAction(store, userSettings));
  }
}

class ColorSetting extends StatelessWidget {
  final bool enableAlpha;
  final Color pickerColor;
  final Function(Color) onColorChanged;

  ColorSetting(this.pickerColor, this.onColorChanged, this.enableAlpha);

  void onColorChangedHandler(Color color) {
    onColorChanged(color);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {
              showColorPicker(context, onColorChanged, pickerColor, enableAlpha)
            },
        child: Container(
          height: 40,
          width: 40,
          margin: EdgeInsets.only(right: 5),
          decoration: new BoxDecoration(
            color: pickerColor,
            shape: BoxShape.rectangle,
          ),
        ));
  }

  showColorPicker(BuildContext context, Function(Color) onColorChange,
      Color pickerColor, bool enableAlpha) {
    showDialog(
        context: context,
        child: AlertDialog(
          title: const Text('Farbe wählen'),
          content: SingleChildScrollView(
            child: ColorPicker(
              enableAlpha: enableAlpha,
              pickerColor: pickerColor,
              onColorChanged: (color) => {
                print("hksdkfjsldjfsdlhjfsdkjfhsdkjfhsdkjfhsdf dsjfhsdklfh"),
                onColorChange(color)
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Speichern'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }
}
