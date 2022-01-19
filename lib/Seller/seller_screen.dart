import 'package:flutter/material.dart';
import 'package:maen/Seller/seller_orders.dart';
import 'package:maen/Seller/seller_upload_product.dart';
import 'package:maen/providers/user_provider.dart';
import 'package:maen/theme/theme.dart';
import 'package:maen/utils/common.dart';
import 'package:maen/utils/config.dart';
import 'package:provider/provider.dart';

class SellerScreen extends StatefulWidget {
  const SellerScreen({Key key}) : super(key: key);

  @override
  _SellerScreenState createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Hello ${EcommerceApp.sharedPreferences.getString(EcommerceApp.userName)}",
          style: MaenTheme.lightTextTheme.headline3
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_drop_down_circle_outlined,
              color: Colors.black,),
              onPressed: (){
                user.getSellerOrders(sellerId: user.user.uid);
                changeScreen(context, SellerOrder());
                print(user.sellerOrders.length.toString());
                //TODO : create signOut function
              },
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 12, left: 12, bottom: 6, right: 12),
                  child: Card(
                    color: Colors.white,
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text("DashBoard"),
                      subtitle: Text("See your sales and total amount generated"),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 6, left: 12, bottom: 12, right: 12),
                  child: GestureDetector(
                    onTap: (){
                      changeScreen(context, SellerUploadProduct());
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text("Upload product"),
                        subtitle: Text("Upload the product you will like to sell"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
