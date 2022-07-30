// ignore_for_file: use_build_context_synchronously, avoid_print, import_of_legacy_library_into_null_safe

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktokclone/universal_variables.dart';
import 'package:video_player/video_player.dart';

class ConfirmScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;
  final ImageSource imageSource;

  const ConfirmScreen(this.videoFile, this.videoPath, this.imageSource,
      {Key? key})
      : super(key: key);
  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController controller;
  var isLoading = false;
  TextEditingController songController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  FlutterVideoCompress flutterVideoCompress = FlutterVideoCompress();

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  compressVideo() async {
    if (widget.imageSource == ImageSource.gallery) {
      return widget.videoFile;
    } else {
      final compressedVideo = await flutterVideoCompress.compressVideo(
        widget.videoPath,
        quality: VideoQuality.MediumQuality,
      );
      return File(compressedVideo.path);
    }
  }

  getPreviewImage() async {
    final previewImage =
        await flutterVideoCompress.getThumbnailWithFile(widget.videoPath);
    return previewImage;
  }

  uploadVideoToStorage(String id) async {
    UploadTask storageUploadTask =
        videosRef.child(id).putFile(await compressVideo());
    TaskSnapshot storageTaskSnapshot =
        await storageUploadTask.whenComplete(() => null);
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadImageToStorage(String id) async {
    UploadTask storageUploadTask =
        imagesRef.child(id).putFile(await getPreviewImage());
    TaskSnapshot storageTaskSnapshot =
        await storageUploadTask.whenComplete(() => null);
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadVideo() async {
    setState(() {
      isLoading = true;
    });
    try {
      var uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc = await userCollection.doc(uid).get();
      var allDocs = await videoColection.get();
      int len = allDocs.docs.length;
      String video = await uploadVideoToStorage("Video $len");
      String previewImage = await uploadImageToStorage("Video $len");
      videoColection.doc("Video $len").set({
        "username": userDoc["username"],
        "uid": uid,
        "profilePic": userDoc["profilePic"],
        "id": "Video $len",
        "likes": [],
        "commentCount": 0,
        "shareCount": 0,
        "songName": songController.text,
        "caption": captionController.text,
        "videoUrl": video,
        "previewImage": previewImage,
      });
      Navigator.of(context).pop();
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading == false
          ? SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: VideoPlayer(controller),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            controller: songController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black,
                              labelText: "Song Name",
                              labelStyle: ralewayStyle(20, Colors.red),
                              prefixIcon: const Icon(
                                Icons.music_note,
                                color: Colors.red,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 20,
                          child: TextField(
                            controller: captionController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black,
                              labelText: "Caption",
                              labelStyle: ralewayStyle(20, Colors.red),
                              prefixIcon: const Icon(
                                Icons.closed_caption,
                                color: Colors.red,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () => uploadVideo(),
                              //      color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "Share!",
                                  style: latoStyle(20, Colors.white),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              //   color: Colors.lightBlue,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "Another Video",
                                  style: latoStyle(20, Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Please wait while we are uploading..",
                    style: ralewayStyle(20, Colors.white),
                  ),
                  const SizedBox(height: 30),
                  const CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ],
              ),
            ),
    );
  }
}
