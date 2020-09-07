import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String ruta;
  final String firstLabel;
  final String linkName;

  const Labels(
      {Key key,
      @required this.ruta,
      @required this.firstLabel,
      @required this.linkName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(firstLabel,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  fontWeight: FontWeight.w300)),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, ruta);
            },
            child: Text(linkName,
                style: TextStyle(
                    color: Colors.blue[600],
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}
