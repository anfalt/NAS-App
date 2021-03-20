import 'package:flutter/material.dart';

class UserSettings {
  UserSettings(this.primaryColor, this.accentColor, this.useComicSansFont);
  Color primaryColor;
  Color accentColor;
  bool useComicSansFont;

  static getInitialSettings() {
    return new UserSettings(Colors.blue, Colors.blue[300]!, false);
  }
}
