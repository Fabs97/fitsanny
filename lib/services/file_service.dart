import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';

class FileService {
  Future<void> saveFile(String fileName, List<int> bytes) async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      final File file = File('$selectedDirectory/$fileName');
      await file.writeAsBytes(bytes);
    } else {
      // User canceled the picker
    }
  }

  Future<String?> getBackupDirectory() async {
    final downloadsDir = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOAD,
    );
    final backupDir = Directory('$downloadsDir/FitsannyBackups');
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    return backupDir.path;
  }

  Future<void> backupDatabase(String databasePath) async {
    final backupDir = await getBackupDirectory();
    if (backupDir != null) {
      final dbFile = File(databasePath);
      if (await dbFile.exists()) {
        final backupFile = File('$backupDir/fitsanny_backup.db');
        await dbFile.copy(backupFile.path);
      }
    }
  }
}
