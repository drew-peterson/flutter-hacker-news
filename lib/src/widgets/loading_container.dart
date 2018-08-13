import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  Widget build(context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: buildBox(),
          subtitle: buildBox(),
        ),
        Divider(height: 8.0)
      ],
    );
  }

  Widget buildBox() {
    return Container(
      color: Colors.grey[200],
      height: 20.0,
      width: 20.0,
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
    );
  }
}
