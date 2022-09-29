import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:girl_chat/models/user.dart';
import 'package:girl_chat/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCart extends StatefulWidget {
  final snap;
  const CommentCart({required this.snap});

  @override
  State<CommentCart> createState() => _CommentCartState();
}

class _CommentCartState extends State<CommentCart> {
  @override
  Widget build(BuildContext context) {
    final Useradd user = Provider.of<UserProvider>(context).getUser;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.snap['profilepic']),
              radius: 18,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: widget.snap['name'],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: widget.snap['text'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.favorite,
                  size: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
