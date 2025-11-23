import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FileService {
  /// Request storage permissions
  /// Returns true if permission is granted
  Future<bool> requestStoragePermission() async {
    try {
      if (Platform.isAndroid) {
        // Check if we are on Android 11+ (API 30+)
        // On Android 11+, we need MANAGE_EXTERNAL_STORAGE to access shared Documents folder
        // especially for files created by previous installations
        if (await Permission.manageExternalStorage.status.isGranted) {
          return true;
        }

        if (await Permission.manageExternalStorage.request().isGranted) {
          return true;
        }

        // Fallback for older Android versions (< 11)
        final status = await Permission.storage.request();

        if (status.isGranted) {
          return true;
        } else if (status.isPermanentlyDenied) {
          print('⚠️ Storage permission permanently denied');
          await openAppSettings();
          return false;
        }
        return false;
      }
      return true; // iOS doesn't need this permission
    } catch (e) {
      print('Error requesting storage permission: $e');
      return false;
    }
  }

  Future<void> saveFile(String fileName, List<int> bytes) async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      final File file = File('$selectedDirectory/$fileName');
      await file.writeAsBytes(bytes);
    } else {
      // User canceled the picker
    }
  }

  /// Get the backup directory in external storage Documents folder
  /// This persists even after app uninstallation
  Future<String?> getBackupDirectory() async {
    try {
      // Request permission first
      final hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        print('❌ Storage permission not granted');
        return null;
      }

      final documentsDir = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOCUMENTS,
      );
      final backupDir = Directory('$documentsDir/Fitsanny');
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }
      return backupDir.path;
    } catch (e) {
      print('Error getting backup directory: $e');
      return null;
    }
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

  /// Check if a backup file exists
  Future<bool> hasBackup() async {
    try {
      final backupDir = await getBackupDirectory();
      if (backupDir != null) {
        final backupFile = File('$backupDir/fitsanny_backup.db');
        return await backupFile.exists();
      }
      return false;
    } catch (e) {
      print('Error checking for backup: $e');
      return false;
    }
  }

  /// Restore database from backup file
  /// Returns true if restore was successful, false otherwise
  Future<bool> restoreDatabase(String databasePath) async {
    try {
      final backupDir = await getBackupDirectory();
      if (backupDir != null) {
        final backupFile = File('$backupDir/fitsanny_backup.db');
        if (await backupFile.exists()) {
          final dbFile = File(databasePath);
          await backupFile.copy(dbFile.path);
          print('✅ Database restored from backup');
          return true;
        }
      }
      return false;
    } catch (e) {
      print('❌ Error restoring database from backup: $e');
      return false;
    }
  }
}
