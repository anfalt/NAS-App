import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as localNot;
import 'package:multi_image_picker/multi_image_picker.dart' as imagePicker;
import 'package:nas_app/Services/NetworkService.dart';
import 'package:path/path.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileService {
  final Dio _dio = NetworkService.getDioInstance();

  localNot.FlutterLocalNotificationsPlugin
      flutterLocalNotificationsPluginDownload;

  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }

    return await getApplicationDocumentsDirectory();
  }

  Future<List<imagePicker.Asset>> getImagesFromLocalSystem() async {
    var pickedImages = await imagePicker.MultiImagePicker.pickImages(
        maxImages: 100,
        enableCamera: true,
        cupertinoOptions: imagePicker.CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: imagePicker.MaterialOptions(
            actionBarTitle: "Bilder auswählen",
            allViewTitle: "Alle Bilder",
            useDetailsView: false));

    return pickedImages;
  }

  Future<String> getVideoFromLocalSystem() async {
    FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
      allowedUtiTypes: [
        'public.video',
        'public.mpeg',
        'public.mpeg-4-audio',
        'com.apple.protected-​mpeg-4-audio'
      ],
      allowedMimeTypes: [
        'video/mpeg',
        'video/x-flv',
        'video/mp4',
        'application/x-mpegURL',
        'video/quicktime',
        'video/x-msvideo',
        'video/x-ms-wmv',
        'video/ogg',
        'video/mp2t',
        'video/3gpp'
      ],
      invalidFileNameSymbols: ['/'],
    );
    var filePath = await FlutterDocumentPicker.openDocument(params: params);
    return filePath;
  }

  Future<bool> _requestPermissions() async {
    var permissionStatus = await Permission.storage.request();

    return permissionStatus == PermissionStatus.granted;
  }

  Future<void> download(String fileName, String fileUrl, String httpMethod,
      Future<void> Function(String) onSelectNotification,
      [FormData postBody]) async {
    initNotificationsPluginDownload(onSelectNotification);
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

  initNotificationsPluginDownload(onSelectNotification) {
    flutterLocalNotificationsPluginDownload =
        localNot.FlutterLocalNotificationsPlugin();
    final android =
        localNot.AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = localNot.IOSInitializationSettings();
    final initSettings =
        localNot.InitializationSettings(android: android, iOS: iOS);

    flutterLocalNotificationsPluginDownload.initialize(initSettings,
        onSelectNotification: onSelectNotification);
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
    String fileName,
    Map<String, dynamic> downloadStatus,
  ) async {
    final android = localNot.AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        priority: localNot.Priority.high, importance: localNot.Importance.max);
    final iOS = localNot.IOSNotificationDetails();
    final platform =
        new localNot.NotificationDetails(android: android, iOS: iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPluginDownload.show(
        Random().nextInt(100), // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? 'File ' + fileName + ' has been downloaded successfully!'
            : 'There was an error while downloading the file.',
        platform,
        payload: json);
  }
}
