import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nas_app/Services/FileService.dart';
import 'package:nas_app/Widgets/FloatingActionButtons/FloatingActionButtonItem.dart';

class UploadImageFloatingActionButton extends FloatingActionButtonItem {
  FileService fileService;
  final ImagePicker _picker = ImagePicker();
  UploadImageFloatingActionButton(onSelectNotification) {
    fileService = new FileService(onSelectNotification);
  }

  IconData icon = Icons.image;

  void onPressed() async {
    final pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
  }
}
