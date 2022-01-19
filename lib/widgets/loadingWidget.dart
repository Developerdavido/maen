import 'package:flutter/material.dart';


circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12.0),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.red),
    ),
  );
}

linearProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12.0),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.red),
    ),
  );
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 50.0,
        width: 50.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.red),
        ),
      ),
    );
  }
}

