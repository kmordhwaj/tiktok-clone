// ignore_for_file: file_names

import 'dart:io';

import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:tiktokclone/screens/confirm_screen.dart';
import 'package:tiktokclone/universal_variables.dart';

class AddVideoPage extends StatefulWidget {
  const AddVideoPage({Key? key}) : super(key: key);

  @override
  State<AddVideoPage> createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  pickVideo(ImageSource src, context) async {
    Navigator.of(context).pop();
    final video = await ImagePicker().pickVideo(source: src);
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ConfirmScreen(File(video!.path), video.path, src),
      ),
    );
  }

  showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () => pickVideo(ImageSource.gallery, context),
                child: Row(
                  children: [
                const    Icon(Icons.image),
                    Padding(
                      padding: const  EdgeInsets.all(7),
                      child: Text(
                        "Gallery",
                        style: latoStyle(20),
                      ),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () => pickVideo(ImageSource.camera, context),
                child: Row(
                  children: [
                  const    Icon(Icons.camera_alt),
                    Padding(
                      padding: const  EdgeInsets.all(7),
                      child: Text(
                        "Camera",
                        style: latoStyle(20),
                      ),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop(),
                child: Row(
                  children: [
                 const     Icon(Icons.cancel),
                    Padding(
                        padding: const  EdgeInsets.all(7),
                        child: Text(
                          "Cancel",
                          style: latoStyle(20),
                        )),
                  ],
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: InkWell(
          onTap: () => showOptionsDialog(context),
          child: Container(
            width: 190,
            height: 80,
            decoration: const  BoxDecoration(color: Colors.red),
            child: Center(
              child: Text(
                "Add Video",
                style: latoStyle(30, Colors.black, FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
