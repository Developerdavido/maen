import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
        ),
        child: SpinKitThreeBounce(
          color: Colors.red,
          size: 10,
        ),
      ),
    );
  }
}
