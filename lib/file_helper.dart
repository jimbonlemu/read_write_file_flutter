import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  Future<File> writeFile(String path, String content) async {
    final file = File(path);

    print('Saved to $path');
    return file.writeAsString(content);
  }

  Future<String> readFile(String filePath) async {
    try {
      final file = File(filePath);
      String content = await file.readAsString();
      return content;
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<String> getFilePath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final prefix = directory.path;
    final absolutePath = '$prefix/$fileName.txt';
    return absolutePath;
  }

  Future<void> deleteFile(String filePath) async {
    final file = File(filePath);

    try {
      if (await file.exists()) {
        await file.delete();
        print('File deleted: $filePath');
      } else {
        print('File not found: $filePath');
      }
    } catch (e) {
      print('Failed to delete file: $e');
    }
  }
}
