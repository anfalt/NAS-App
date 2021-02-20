import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
// Replace with server token from firebase console settings.
  final String serverToken =
      'AAAAyW_LSxE:APA91bE3aSxT_dN_DIe-iPy4B7ZFK2AhrsPB383k6y0RfdZDf7-O97EsLLHlvZ7X9aRg7KHsC9tR4DI4NYu5n8F3nP1pkqjnk44LfyDahFQvvYleV5Hy-FcFVnQ-6HN2SpBddBAOqnY7';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  Dio dio;

  NotificationService() {
    dio = new Dio();
  }

  Future<Map<String, dynamic>> sendNotification(
      String message, String title) async {
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: false),
    );

    var jsonBody = jsonEncode(<String, dynamic>{
      "notification": {"body": message, "title": title},
      "to": "/topics/ListTodos",
      "priority": 0,
    });

    var result = await dio.post('https://fcm.googleapis.com/fcm/send',
        options: Options(headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=' + serverToken,
        }),
        data: jsonBody);

    print(result.statusCode);
    var i = 0;

    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
  }
}
