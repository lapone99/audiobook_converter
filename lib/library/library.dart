import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:first_flutter_app/pdf_processor/pdf_processor.dart'
    as pdf_processor;

import 'package:first_flutter_app/domain/Book.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  FilePickerCross? filePickerCross;

  var bookList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: Text("Library",
              style: TextStyle(fontSize: 24, color: Colors.white)),
          shadowColor: Colors.black,
          actions: [
            TextButton(
                onPressed: () => _selectFile(context),
                child: Text(
                  "Add book",
                  style: TextStyle(fontSize: 16),
                ))
          ],
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(
            child: ListView.builder(
                itemCount: bookList.length,
                itemBuilder: (context, index) {
                  Book book = bookList[index];
                  return ListTile(
                      leading: Hero(
                        tag: book.title!,
                        child: CircleAvatar(
                            backgroundImage:
                                FileImage(File(book.coverImageUrl!))),
                      ),
                      title: Text(
                        book.title ?? "",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ));
                })));
  }

  void _selectFile(context) async {
    FilePickerCross.importFromStorage(
            type: FileTypeCross.custom, fileExtension: 'pdf')
        .then((filePicker) async {
      await setFilePicker(filePicker);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You select file '
              'with extension ${filePicker.fileExtension}'),
        ),
      );

      setState(() {});
    });
  }

  Future<void> setFilePicker (FilePickerCross filePicker) async {
    filePickerCross = filePicker;
    filePickerCross!.saveToPath(path: filePickerCross!.fileName!);
    pdf_processor
        .getBookFromFile(filePicker.path!)
        .then((value) => bookList.add(value));
    setState(() {

    });
  }
}
