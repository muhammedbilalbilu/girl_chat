import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:girl_chat/Screen/addpostScreen.dart';
import 'package:girl_chat/Screen/feed-SCREEN.dart';
import 'package:girl_chat/Screen/profileScreen.dart';
import 'package:girl_chat/Screen/sarchScreen.dart';

List<Widget> homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text('ff'),
  ProfileScrren(
    uid: FirebaseAuth.instance.currentUser!.uid,
  )
];
