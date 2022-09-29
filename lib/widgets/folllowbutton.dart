import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color backgroundcolor;
  final Color bordercolor;
  final Color textcolor;
  final String text;
  FollowButton(
      {required this.backgroundcolor,
      required this.bordercolor,
      required this.textcolor,
      required this.text,
      this.function});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2),
      child: TextButton(
          onPressed: function,
          child: Container(
            decoration: BoxDecoration(
                color: backgroundcolor,
                border: Border.all(color: bordercolor),
                borderRadius: BorderRadius.circular(5)),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(color: textcolor, fontWeight: FontWeight.bold),
            ),
            width: 250,
            height: 27,
          )),
    );
  }
}
