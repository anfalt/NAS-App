import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nas_app/redux/User/UserAction.dart';
import 'package:nas_app/redux/store.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure();

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      Redux.store
          .dispatch((store) => {fetchSetMessagingTokenAction(store, token)});

      _initialized = true;
    }
  }
}
