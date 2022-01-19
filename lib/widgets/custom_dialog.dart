import 'package:flutter/material.dart';
import 'package:maen/screens/Cart.dart';
import 'package:maen/screens/homepage.dart';
import 'package:maen/screens/store_home.dart';
import 'package:maen/utils/common.dart';

class CustomDialog extends StatelessWidget {
  final String title, description, primaryButtonText, primaryButtonRoute, secondaryButtonText, secondaryButtonRoute;

  CustomDialog({
    @required this.title,
    @required this.description,
    @required this.primaryButtonText,
    this.primaryButtonRoute,
    this.secondaryButtonRoute,
    this.secondaryButtonText
});

  static const double padding = 20.0;

  Color favColor = Color(0xFFDEDEDE);
  Color orange = Color(0xFFFF4C00);
  Color ash = Color(0xFFECF1F7);
  Color blue = Color(0xFF0007A7);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding)),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(padding),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 24.0,),
                Text(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: blue,
                    fontSize: 20.0
                  ),
                ),
                SizedBox(height: 24.0,),
                Text(
                  description,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0
                  ),
                ),
                SizedBox(height: 24.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      child: Text(
                        primaryButtonText,
                        maxLines: 1,
                        style: TextStyle(fontSize: 14,
                            fontWeight: FontWeight.w200,
                            color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        onSurface: blue,
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                        changeScreen(context, StoreHome());
                      },
                    ),
                    SizedBox(width: 10.0,),
                    showSecondaryButton(context)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  showSecondaryButton(BuildContext context) {
    if( secondaryButtonText != null ) {
      return TextButton(
        child: Text(
          secondaryButtonText,
          maxLines: 1,
          style: TextStyle(
            fontSize: 14,
            color: blue,
            fontWeight: FontWeight.w400,
          ),
        ),
        onPressed: (){
          Navigator.pop(context);
          changeScreen(context, CartScreen());
        },
      );
    }else {
      return SizedBox(height: 10.0,);
    }

  }
}
