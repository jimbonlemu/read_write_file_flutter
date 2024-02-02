import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class FileDialog extends StatefulWidget {
  final List<FileSystemEntity> files;
  final Function(FileSystemEntity) onDelete;

  const FileDialog({super.key, required this.files, required this.onDelete});

  @override
  State<FileDialog> createState() => _FileDialogState();
}

class _FileDialogState extends State<FileDialog> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Choose your file"),
      ),
      child: ListView.builder(
        itemCount: widget.files.length,
        itemBuilder: (context, index) {
          final file = widget.files[index];
          return Material(
            child: ListTile(
              title: Text(path.split(file.path).last),
              onLongPress: () async {
                final fileToDelete = File(file.path);
                if (await fileToDelete.exists()) {
                  await fileToDelete.delete();
                  setState(() {
                    widget.files.removeAt(index);
                  });
                  widget.onDelete(file);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
