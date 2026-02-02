import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:open_file_manager/open_file_manager.dart';

import 'notificationService.dart';

Future<void> showDownloadFolder(payload) async {
  try {
    openFileManager(
      androidConfig: AndroidConfig(
        folderType: FolderType.download,
        
      ),
    );
  } catch (e) {
    if (kDebugMode) {
      print('Error opening file: $e');
    }
  }
}

Future<void> saveFileAndNotify(String fileName, String content) async {
  try {
    // Get the local documents directory
    final directory = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOAD);

    if (directory == null) {
      throw Exception("Could not get the downloads directory");
    }

    final file = File('${directory}/$fileName.json');

    // Write the file
    await file.writeAsString(content);

    // Show a local notification upon completion
    await NotificationService.showNotification(
      'Save Completed',
      '$fileName.json has been saved on download folder.',
      payload: file.path, // Pass the file path in the payload
    );

    if (kDebugMode) {
      print('File saved to: ${file.path}');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error saving file: $e');
    }
    await NotificationService.showNotification(
      'Save Failed',
      'Could not save $fileName.',
    );
  }
}
