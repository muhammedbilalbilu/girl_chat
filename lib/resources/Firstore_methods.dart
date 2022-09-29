import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:girl_chat/models/post.dart';
import 'package:girl_chat/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethodes {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> uplodingpost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    String res = 'somthing happens';
    try {
      String photourl =
          await StorageMethods().uploadImageToStorage('Post', file, true);
      String postid = Uuid().v1();
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          likes: [],
          postId: postid,
          datePublished: DateTime.now(),
          postUrl: photourl,
          profImage: profImage);

      _firestore.collection('Postes').doc(postid).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likepost(String postid, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('Postes').doc(postid).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('Postes').doc(postid).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> postcomments(String postid, String text, String uid, String name,
      String profilepic) async {
    try {
      if (text.isNotEmpty) {
        String commentid = Uuid().v1();
        await _firestore
            .collection('Postes')
            .doc(postid)
            .collection('comments')
            .doc(commentid)
            .set({
          'profilepic': profilepic,
          'name': name,
          "text": text,
          'cpmmentid': commentid,
          'datePublished': DateTime.now()
        });
      } else {
        print('text is empty');
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> deletpost(String postid) async {
    try {
      await _firestore.collection('Postes').doc(postid).delete();
    } catch (err) {}
  }

  Future<void> followusers(String uid, String followid) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(uid).get();
      List following = (snapshot.data()! as dynamic)['following'];
      if (following.contains(followid)) {
        await _firestore.collection('users').doc(followid).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(followid).update({
          'following': FieldValue.arrayRemove([followid])
        });
        await _firestore.collection('users').doc(followid).update({
          'following': FieldValue.arrayUnion([followid])
        });
        await _firestore.collection('users').doc(followid).update({
          'followers': FieldValue.arrayUnion([uid])
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }
}
