// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:tiktokclone/universal_variables.dart';
import "package:timeago/timeago.dart" as tago;

class CommentScreen extends StatefulWidget {
  final String id;
  const CommentScreen(this.id, {Key? key}) : super(key: key);
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late String uid;
  TextEditingController commentsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  uploadComment() async {
    if (commentsController.text.isNotEmpty) {
      DocumentSnapshot userDoc = await userCollection.doc(uid).get();
      var allDocs =
          await videoColection.doc(widget.id).collection("comments").get();
      int len = allDocs.docs.length;
      videoColection
          .doc(widget.id)
          .collection("comments")
          .doc("Comment $len")
          .set({
        "username": userDoc["username"],
        "uid": uid,
        "profilePic": userDoc["profilePic"],
        "comment": commentsController.text,
        "likes": [],
        "time": DateTime.now(),
        "id": "Comment $len"
      });
      commentsController.clear();
      DocumentSnapshot doc = await videoColection.doc(widget.id).get();
      videoColection.doc(widget.id).update({
        "commentCount": doc["commentCount"] + 1,
      });
    } else {
      print("empty");
    }
  }

  likeComment(String id) async {
    DocumentSnapshot doc = await videoColection
        .doc(widget.id)
        .collection("comments")
        .doc(id)
        .get();
    if (doc["likes"].contains(uid)) {
      videoColection.doc(widget.id).collection("comments").doc(id).update({
        "likes": FieldValue.arrayRemove([uid]),
      });
    } else {
      videoColection.doc(widget.id).collection("comments").doc(id).update({
        "likes": FieldValue.arrayUnion([uid]),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: videoColection
                        .doc(widget.id)
                        .collection("comments")
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            DocumentSnapshot comment =
                                snapshot.data.docs[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.black,
                                backgroundImage:
                                    NetworkImage(comment["profilePic"]),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    "${comment["username"]}",
                                    style: latoStyle(
                                        20, Colors.red, FontWeight.w700),
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    "${comment["comment"]}",
                                    style: ralewayStyle(
                                        20, Colors.white, FontWeight.w500),
                                  ),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    tago.format(comment["time"].toDate()),
                                    style: latoStyle(12, Colors.white),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${comment["likes"].length} likes",
                                    style: latoStyle(12, Colors.white),
                                  ),
                                ],
                              ),
                              trailing: InkWell(
                                onTap: () => likeComment(comment["id"]),
                                child: Icon(
                                  comment["likes"].contains(uid)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 25,
                                  color: Colors.red,
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  title: TextFormField(
                    controller: commentsController,
                    style: latoStyle(16, Colors.white),
                    decoration: InputDecoration(
                      labelText: "Comment",
                      labelStyle: latoStyle(20, Colors.white, FontWeight.w700),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  trailing: OutlinedButton(
                    onPressed: () => uploadComment(),
                    child: Text(
                      "Send",
                      style: ralewayStyle(16, Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
