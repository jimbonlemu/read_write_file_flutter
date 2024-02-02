import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:read_write_file_flutter/file_dialog.dart';
import 'package:read_write_file_flutter/file_helper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  void _createNewFile() {
    _titleController.clear();
    _contentController.clear();
  }

  void _saveFile(BuildContext context) async {
    bool isValid = _titleController.text.isNotEmpty;
    if (isValid) {
      final filePath = await FileHelper().getFilePath(_titleController.text);
      FileHelper().writeFile(filePath, _contentController.text);
      if (mounted) {
        _showDialog(context, true);
      }
    } else {
      _showDialog(context, false);
    }
  }

  void _showDialog(BuildContext context, bool isSuccess) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(isSuccess ? 'File Saved' : 'File Not Created'),
          content: isSuccess ? null : const Text("File name must not be empty"),
          actions: [
            CupertinoDialogAction(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void _getFilesInDirectory(BuildContext context) async {
    final navigator = Navigator.of(context);
    final directory = await getApplicationDocumentsDirectory();

    final dir = Directory(directory.path);
    List<FileSystemEntity> files =
        dir.listSync().where((file) => file.path.contains(".txt")).toList();
    final FileSystemEntity? selectedFile = await navigator.push(
      CupertinoPageRoute(
        builder: (context) => FileDialog(
          files: files,
          onDelete: (deletedFile) {
            setState(() {
              files.remove(deletedFile);
            });
          },
        ),
        fullscreenDialog: true,
      ),
    );

    if (selectedFile != null) () => _openFile(selectedFile.path);
  }

  void _openFile(String filePath) async {
    final content = await FileHelper().readFile(filePath);
    _contentController.text = content;
    _titleController.text = split(filePath).last.split('.').first;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('My Read Write File'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                    child: const Text('New File'),
                    onPressed: () => _createNewFile,
                  ),
                ),
                Expanded(
                  child: CupertinoButton(
                    child: const Text("Open File"),
                    onPressed: () => _getFilesInDirectory(context),
                  ),
                ),
                Expanded(
                  child: CupertinoButton(
                    child: const Text("Save File"),
                    onPressed: () => _saveFile(context),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: CupertinoTextField(
                      placeholder: 'File Name',
                      controller: _titleController,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: CupertinoTextField(
                  placeholder: "Write your note here",
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _contentController,
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
