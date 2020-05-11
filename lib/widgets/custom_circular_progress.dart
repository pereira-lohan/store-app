import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final Color color;
  CustomCircularProgressIndicator({this.color});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            height: 70.0,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              valueColor: color != null
                ? AlwaysStoppedAnimation<Color>(color)
                : AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            )
        )
    );
  }
}
