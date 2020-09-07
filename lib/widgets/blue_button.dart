import 'dart:ui';

import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  final String title;
  final Function onPressed;

  const BlueButton({Key key, @required this.title, @required this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 2,
      highlightElevation: 5,
      color: Colors.blue,
      shape: StadiumBorder(),
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(
          child:
              Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ),
    );
  }
}
