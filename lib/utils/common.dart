import 'package:flutter/material.dart';

//===== colors ======
Color black = Colors.black;
Color CustomBlack = Color.fromRGBO(255, 200, 192, 0.3);
Color white = Colors.white;
Color deepOrange = Colors.deepOrange;

//======== methods ===========
void changeScreen (BuildContext context, Widget widget){
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void changeScreenReplacement (BuildContext context, Widget widget){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> widget));
}