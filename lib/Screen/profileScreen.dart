import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:girl_chat/Screen/Loginscreen.dart';
import 'package:girl_chat/resources/Firstore_methods.dart';
import 'package:girl_chat/resources/auth_methods.dart';
import 'package:girl_chat/util/pickimage.dart';
import 'package:girl_chat/widgets/colors.dart';
import 'package:girl_chat/widgets/folllowbutton.dart';

class ProfileScrren extends StatefulWidget {
  final String uid;
  ProfileScrren({required this.uid});

  @override
  State<ProfileScrren> createState() => _ProfileScrrenState();
}

class _ProfileScrrenState extends State<ProfileScrren> {
  var userData = {};
  int postLen = 0;
  int folowers = 0;
  int folowing = 0;
  bool isFolleing = false;
  bool isloding = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isloding = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postSnap = await FirebaseFirestore.instance
          .collection('Postes')
          .where('uid')
          .get();
      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      folowers = userSnap.data()!['followers'].length;
      folowing = userSnap.data()!['followers'].length;
      isFolleing = userSnap
          .data()!['following']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
    setState(() {
      isloding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isloding
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username'].toString()),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage(
                                    userData['photoUrl'].toString()),
                                radius: 40,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        buildcolum(postLen, 'postes'),
                                        buildcolum(folowers, 'folowers'),
                                        buildcolum(folowing, 'following')
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        FirebaseAuth.instance.currentUser!
                                                    .uid ==
                                                widget.uid
                                            ? FollowButton(
                                                function: () async {
                                                  AuthMethods().signOut();
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  LoginScreen()));
                                                },
                                                backgroundcolor:
                                                    mobileBackgroundColor,
                                                bordercolor: Colors.grey,
                                                textcolor: primaryColor,
                                                text: 'Sign out')
                                            : isFolleing
                                                ? FollowButton(
                                                    function: () async {
                                                      await FirestoreMethodes()
                                                          .followusers(
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid,
                                                              userData['uid']);
                                                      setState(() {
                                                        isFolleing = false;
                                                        folowers--;
                                                      });
                                                    },
                                                    backgroundcolor:
                                                        Colors.white,
                                                    bordercolor: Colors.grey,
                                                    textcolor: Colors.black,
                                                    text: 'Unfollow')
                                                : FollowButton(
                                                    function: () async {
                                                      await FirestoreMethodes()
                                                          .followusers(
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid,
                                                              userData['uid']);
                                                      setState(() {
                                                        isFolleing = true;
                                                        folowers++;
                                                      });
                                                    },
                                                    backgroundcolor:
                                                        Colors.blue,
                                                    bordercolor: Colors.blue,
                                                    textcolor: Colors.white,
                                                    text: 'Follow'),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(top: 15),
                            child: Text(
                              userData['username'].toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(top: 1),
                            child: Text(
                              'Some description',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Divider(),
                          FutureBuilder(
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return GridView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      (snapshot.data! as dynamic).docs.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 1.5,
                                          childAspectRatio: 1),
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot sn =
                                        (snapshot.data! as dynamic).docs[index];
                                    return Container(
                                      child: Image(
                                        image: NetworkImage(sn['postUrl']),
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  });
                            },
                            future: FirebaseFirestore.instance
                                .collection('Postes')
                                .where('uid', isEqualTo: widget.uid)
                                .get(),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          );
  }

  Column buildcolum(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        )
      ],
    );
  }
}
