// ignore_for_file: avoid_print, import_of_legacy_library_into_null_safe
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:tiktokclone/screens/comment_screen.dart';
import 'package:tiktokclone/universal_variables.dart';
import 'package:tiktokclone/widgets/circle_animation.dart';
import 'package:tiktokclone/widgets/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late Stream videoStream;
  late String uid;

  @override
  initState() {
    super.initState();
    videoStream = videoColection.snapshots();
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  shareVideo(String video, String id) async {
    var req = await HttpClient().getUrl(Uri.parse(video));
    var res = await req.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(res);
    await Share.file("TikTok", "Video.mp4", bytes, "video/mp4");
    DocumentSnapshot doc = await videoColection.doc(id).get();
    videoColection.doc(id).update({"shareCount": doc["shareCount"] + 1});
  }

  buildProfile(String url) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: (60 / 2) - (50 / 2),
            child: Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(
                    url,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: (60 / 2) - (20 / 2),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }

  buildMusicAlbum(String url) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(11.0),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey.shade800,
                  Colors.grey.shade700,
                ],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(
                  url,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //  var size = MediaQuery.of(context).size;

    likeVideo(String id) async {
      DocumentSnapshot doc = await videoColection.doc(id).get();
      if (doc["likes"].contains(uid)) {
        videoColection.doc(id).update({
          "likes": FieldValue.arrayRemove([uid]),
        });
      } else {
        videoColection.doc(id).update({
          "likes": FieldValue.arrayUnion([uid]),
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder(
          stream: videoStream,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return PageView.builder(
                itemCount: snapshot.data.docs.length,
                controller: PageController(initialPage: 0, viewportFraction: 1),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  DocumentSnapshot videos = snapshot.data.docs[index];
                  print(videos);
                  return Stack(
                    children: [
                      VideoPlayerItem(videos["videoUrl"]),
                      Column(
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          videos["username"],
                                          style: ralewayStyle(20, Colors.white,
                                              FontWeight.bold),
                                        ),
                                        Text(
                                          videos["caption"],
                                          style: latoStyle(15, Colors.white),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.music_note,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              videos["songName"],
                                              style: ralewayStyle(
                                                15,
                                                Colors.white,
                                                FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          12),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildProfile(videos["profilePic"]),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () =>
                                                likeVideo(videos["id"]),
                                            child: Icon(
                                              Icons.favorite,
                                              size: 55,
                                              color:
                                                  videos["likes"].contains(uid)
                                                      ? Colors.red
                                                      : Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                              videos["likes"].length.toString(),
                                              style:
                                                  latoStyle(20, Colors.white)),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () =>
                                                Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CommentScreen(videos["id"]),
                                              ),
                                            ),
                                            child: const Icon(Icons.comment,
                                                size: 55, color: Colors.white),
                                          ),
                                          const SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                              videos["commentCount"].toString(),
                                              style:
                                                  latoStyle(20, Colors.white)),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () => shareVideo(
                                                videos["videoUrl"],
                                                videos["id"]),
                                            child: const Icon(Icons.reply,
                                                size: 55, color: Colors.white),
                                          ),
                                          const SizedBox(
                                            height: 7,
                                          ),
                                          Text(videos["shareCount"].toString(),
                                              style:
                                                  latoStyle(20, Colors.white)),
                                        ],
                                      ),
                                      CircleAnimation(buildMusicAlbum(
                                          videos["profilePic"])),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                });
          }),
    );
  }
}
