import 'package:flutter/material.dart';
import 'package:maen/screens/navigation_controller.dart';
import 'package:maen/screens/store_home.dart';
import 'package:maen/theme/theme.dart';
import 'package:maen/utils/common.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: [
            Image.asset(
              "images/empty_cart.png",
              height: 350.0,
              width: 350.0,
            ),
            SizedBox(height: 2,),
            Text("Your cart is empty as of this moment",
            style: MaenTheme.lightTextTheme.bodyText1,),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.blue,
              ),
              onPressed: (){
                changeScreen(context, NavigationController());
              },
              child: Text('Start shopping'),
            )
          ],
        ),
      ),
    );
  }
}
