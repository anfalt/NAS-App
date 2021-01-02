import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as localNot;
import 'package:nas_app/Services/NetworkService.dart';
import 'package:path/path.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileService {
  final Dio _dio = NetworkService.getDioInstance();
  localNot.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  FileService(Future<void> Function(String) onSelectNotification) {
    flutterLocalNotificationsPlugin =
        localNot.FlutterLocalNotificationsPlugin();
    final android =
        localNot.AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = localNot.IOSInitializationSettings();
    final initSettings =
        localNot.InitializationSettings(android: android, iOS: iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }

    return await getApplicationDocumentsDirectory();
  }

  Future<bool> _requestPermissions() async {
    var permissionStatus = await Permission.storage.request();

    return permissionStatus == PermissionStatus.granted;
  }

  Future<void> download(String fileName, String fileUrl, String httpMethod,
      [FormData postBody]) async {
    final dir = await _getDownloadDirectory();
    final isPermissionStatusGranted = await _requestPermissions();

    if (isPermissionStatusGranted) {
      File file = new File(fileName);
      String saveFileName = basename(file.path);
      final savePath = path.join(dir.path, saveFileName);
      await _startDownload(
          saveFileName, savePath, fileUrl, httpMethod, postBody);
    }
  }

  Future<void> _startDownload(
      String fileName, String savePath, String fileUrl, String httpMethod,
      [FormData postBody]) async {
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {
      final response = await _dio.download(fileUrl, savePath,
          options: Options(method: httpMethod), data: postBody);

      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      await _showNotification(fileName, result);
    }
  }

  Future<void> _showNotification(
      String fileName, Map<String, dynamic> downloadStatus) async {
    final android = localNot.AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        priority: localNot.Priority.high, importance: localNot.Importance.max);
    final iOS = localNot.IOSNotificationDetails();
    final platform =
        new localNot.NotificationDetails(android: android, iOS: iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
        Random().nextInt(100), // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? 'File ' + fileName + ' has been downloaded successfully!'
            : 'There was an error while downloading the file.',
        platform,
        payload: json);
  }
}
