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
        final manageExternalStorageStatus =
            await Permission.manageExternalStorage.status;

        if (manageExternalStorageStatus.isGranted) {
          return true;
        }

        final manageExternalStorageRequest = await Permission
            .manageExternalStorage
            .request();

        if (manageExternalStorageRequest.isGranted) {
          return true;
        }

        // Fallback for older Android versions (< 11)
        final status = await Permission.storage.request();

        if (status.isGranted) {
          return true;
        } else if (status.isPermanentlyDenied) {
          // Don't automatically open settings - let the UI handle this
          return false;
        }
        return false;
      }
      return true; // iOS doesn't need this permission
    } catch (e) {
      return false;
    }
  }

  /// Open app settings for the user to manually grant permissions
  Future<void> openStorageSettings() async {
    await openAppSettings();
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
  ///
  /// Set [skipPermissionCheck] to true if permissions have already been verified
  /// to avoid redundant permission requests that can cause hangs
  Future<String?> getBackupDirectory({bool skipPermissionCheck = false}) async {
    try {
      // Request permission first (unless skipped)
      if (!skipPermissionCheck) {
        final hasPermission = await requestStoragePermission();
        if (!hasPermission) {
          return null;
        }
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
  /// Set [skipPermissionCheck] to true if permissions have already been verified
  Future<bool> hasBackup({bool skipPermissionCheck = false}) async {
    try {
      final backupDir = await getBackupDirectory(
        skipPermissionCheck: skipPermissionCheck,
      );
      if (backupDir != null) {
        final backupFile = File('$backupDir/fitsanny_backup.db');
        final exists = await backupFile.exists();
        return exists;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Restore database from backup file
  /// Returns true if restore was successful, false otherwise
  /// Set [skipPermissionCheck] to true if permissions have already been verified
  Future<bool> restoreDatabase(
    String databasePath, {
    bool skipPermissionCheck = false,
  }) async {
    try {
      final backupDir = await getBackupDirectory(
        skipPermissionCheck: skipPermissionCheck,
      );
      if (backupDir != null) {
        final backupFile = File('$backupDir/fitsanny_backup.db');
        if (await backupFile.exists()) {
          final dbFile = File(databasePath);
          await backupFile.copy(dbFile.path);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
