import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:tiktokclone/universal_variables.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage(this.uid, {Key? key}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = '';
  String currentUser = '';
  String profilePic = '';
  Future? myVideos;
  var likes = 0;
  var isData = false;
  var isFollowing = false;
  int following = 0;
  int followers = 0;
  TextEditingController usernameController = TextEditingController();

  followUser() async {
    var doc = await userCollection
        .doc(widget.uid)
        .collection("followers")
        .doc(currentUser)
        .get();
    if (!doc.exists) {
      userCollection
          .doc(widget.uid)
          .collection("followers")
          .doc(currentUser)
          .set({});
      userCollection
          .doc(currentUser)
          .collection("following")
          .doc(widget.uid)
          .set({});
      setState(() {
        isFollowing = true;
        followers++;
      });
    } else {
      userCollection
          .doc(widget.uid)
          .collection("followers")
          .doc(currentUser)
          .delete();
      userCollection
          .doc(currentUser)
          .collection("following")
          .doc(widget.uid)
          .delete();
      setState(() {
        isFollowing = false;
        followers--;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  getAllData() async {
    myVideos = videoColection.where("uid", isEqualTo: widget.uid).get();
    DocumentSnapshot userDoc = await userCollection.doc(widget.uid).get();
    username = userDoc["username"];
    profilePic = userDoc["profilePic"];
    currentUser = FirebaseAuth.instance.currentUser!.uid;

    var docs = await videoColection.where("uid", isEqualTo: widget.uid).get();
    for (var item in docs.docs) {
      likes += item.data()["likes"].toString().length;
    }
    var followerDoc =
        await userCollection.doc(widget.uid).collection("followers").get();
    var followingDoc =
        await userCollection.doc(widget.uid).collection("following").get();
    followers = followerDoc.docs.length;
    following = followingDoc.docs.length;

    userCollection
        .doc(widget.uid)
        .collection("followers")
        .doc(currentUser)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          isFollowing = true;
        });
      } else {
        setState(() {
          isFollowing = false;
        });
      }
    });
    setState(() {
      isData = true;
    });
  }

  editProfile() {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SizedBox(
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Edit Profile",
                    style: latoStyle(20, Colors.red),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: "Username",
                        hintStyle: ralewayStyle(17, Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      userCollection
                          .doc(currentUser)
                          .update({"username": usernameController.text});
                      setState(() {
                        username = usernameController.text;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 50,
                      color: Colors.red,
                      child: Center(
                        child: Text(
                          "Edit",
                          style: ralewayStyle(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isData == false
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 64,
                      backgroundColor: Colors.black,
                      backgroundImage: NetworkImage(
                        profilePic,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      username,
                      style: ralewayStyle(
                        25,
                        Colors.white,
                        FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          followers.toString(),
                          style: latoStyle(23, Colors.red, FontWeight.bold),
                        ),
                        Text(
                          following.toString(),
                          style: latoStyle(23, Colors.red, FontWeight.bold),
                        ),
                        Text(
                          likes.toString(),
                          style: latoStyle(23, Colors.red, FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Followers",
                          style: latoStyle(23, Colors.white, FontWeight.w500),
                        ),
                        Text(
                          "Following",
                          style: latoStyle(23, Colors.white, FontWeight.w500),
                        ),
                        Text(
                          "Likes",
                          style: latoStyle(23, Colors.white, FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    currentUser == widget.uid
                        ? Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 40,
                            color: Colors.red,
                            child: InkWell(
                              onTap: () => editProfile(),
                              child: const Center(
                                child: Text(
                                  "Edit Profile",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 40,
                            color: Colors.red,
                            child: InkWell(
                              onTap: () => followUser(),
                              child: Center(
                                child: Text(
                                  isFollowing == false ? "Follow" : "Unfollow",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Videos",
                      style: latoStyle(20, Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FutureBuilder(
                      future: myVideos,
                      builder: (BuildContext coontext, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: 5,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            DocumentSnapshot video = snapshot.data.docs[index];
                            return Image(
                              image: NetworkImage(
                                video["previewImage"],
                              ),
                              fit: BoxFit.cover,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
