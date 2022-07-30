import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";

latoStyle(double size, [Color? color, FontWeight fw = FontWeight.w700]) {
  return TextStyle(
    fontSize: size,
    color: color,
    fontWeight: fw,
  );
}

ralewayStyle(double size, [Color? color, FontWeight fw = FontWeight.w700]) {
  return TextStyle(
    fontSize: size,
    color: color,
    fontWeight: fw,
  );
}

var userCollection = FirebaseFirestore.instance.collection("users");
var videoColection = FirebaseFirestore.instance.collection("videos");

Reference videosRef = FirebaseStorage.instance.ref().child("videos");
Reference imagesRef = FirebaseStorage.instance.ref().child("images");
