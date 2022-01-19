import 'package:flutter/material.dart';
import 'package:maen/widgets/constants.dart';

class BottomSheetWidget extends StatelessWidget {
  final String title;
  final String description;
  final Widget productSize;
  final int quantity;
  final int price;
  final VoidCallback positiveButton;
  final VoidCallback negativeButton;


  BottomSheetWidget({
    @required this.title,
  @required this.description,
  @required this.productSize,
  @required this.quantity,
  @required this.price,
  @required this.positiveButton,
    Key key,
  @required this.negativeButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      height: 100,
      decoration: BoxDecoration(
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                style: Constants.regularHeading,),

                Container(
                  height: 30,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.deepOrange
                  ),
                  child: Center(
                    child: Text(
                      "\GHC $price",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                      ),
                    ),
                  ),
                )
              ],
            ),

            Text(
              description,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white10,
                fontSize: 12,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 24,
              ),
              child: Row(
                children: [
                  buildSizedBox(
                      icon: Icons.remove,
                      press: negativeButton,
                  ),
                  Padding(padding: const EdgeInsets.symmetric(
                      horizontal: 20 / 2
                  ),
                    child: Text(
                      "$quantity".toString(),
                      style: Constants.regularDarkText,
                    ),
                  ),
                  buildSizedBox(icon: Icons.add,
                      press: positiveButton,
                  )
                ],
              ),
            ),

            productSize,
          ],
        ),
      ),
    );
  }
  SizedBox buildSizedBox({IconData icon, Function press}) {
    return SizedBox(
      width: 40,
      height: 32,
      child: OutlineButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13)
        ),
        onPressed: press,
        child: Icon(icon),
      ),
    );
  }

}
