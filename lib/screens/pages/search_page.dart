import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:tiktokclone/screens/pages/profile_page.dart';
import 'package:tiktokclone/universal_variables.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<QuerySnapshot>? searchResult;

  searchUser(String typedUser) {
    var users = userCollection
        .where("username", isGreaterThanOrEqualTo: typedUser)
        .get();
    setState(() {
      searchResult = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: TextFormField(
          decoration: InputDecoration(
            filled: false,
            hintText: "Search",
            hintStyle: latoStyle(18, Colors.white),
          ),
          onFieldSubmitted: searchUser,
        ),
      ),
      body: searchResult == null
          ? Center(
              child: Text(
                "Search for users!",
                style: ralewayStyle(25, Colors.white, FontWeight.bold),
              ),
            )
          : FutureBuilder(
              future: searchResult,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot user = snapshot.data.docs[index];
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => ProfilePage(
                              user["uid"],
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          trailing: CircleAvatar(
                            backgroundColor: Colors.black,
                            backgroundImage: NetworkImage(user["profilePic"]),
                          ),
                          title: Text(
                            user["username"],
                            style: ralewayStyle(25, Colors.white),
                          ),
                        ),
                      );
                    });
              }),
    );
  }
}
