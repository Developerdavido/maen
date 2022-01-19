import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maen/Address/address.dart';
import 'package:maen/Authentication/authentication.dart';
import 'package:maen/Seller/seller_screen.dart';
import 'package:maen/providers/user_provider.dart';
import 'package:maen/screens/login.dart';
import 'package:maen/screens/orders.dart';
import 'package:maen/screens/seller_page.dart';
import 'package:maen/utils/common.dart';
import 'package:maen/utils/config.dart';
import 'package:provider/provider.dart';

class AccountDialog extends StatefulWidget {
  final String yourName, yourOrders, yourAccount;
  const AccountDialog({
    this.yourAccount,
    this.yourName,
    this.yourOrders
});

  static const double padding =  12;

  @override
  _AccountDialogState createState() => _AccountDialogState();
}

class _AccountDialogState extends State<AccountDialog> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AccountDialog.padding)),
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(AccountDialog.padding)),
                color: Colors.white,
              shape: BoxShape.rectangle
            ),
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(AccountDialog.padding),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "My Account",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),),

                Padding(
                  padding: const EdgeInsets.all(AccountDialog.padding),
                  child: Row(
                    children: [
                      Container(
                        height: 80.0,
                        width: 80.0,
                        child: CircleAvatar(
                          radius: 40.0,
                          backgroundImage: (EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl) == null) ?
                          AssetImage('images/admin.png')
                              : NetworkImage(
                            EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl),
                          ),
                        ),
                      ),

                      SizedBox(width: 12,),
                      Text(
                        widget.yourName,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: Divider(
                    height: 1.0,
                    thickness: 0.5,
                    color: Colors.black38,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Card(
                            child: ListTile(
                              title: Text(
                                "My profile"
                              ),
                              subtitle: Text(
                                "update your profile"
                              ),
                              trailing: Icon(Icons.arrow_forward_ios_rounded,
                                color: Colors.black38,
                              size: 12,),
                            ),
                            elevation: 0.0,
                          ),
                          GestureDetector(
                            onTap: (){
                              user.getOrders();
                              Navigator.pop(context);
                              changeScreen(context, OrderScreen());
                              print(user.orders.length.toString());
                            },
                            child: Card(
                              child: ListTile(
                                title: Text(
                                    "My orders"
                                ),
                                subtitle: Text(
                                    "manage your orders"
                                ),
                                trailing: Icon(Icons.arrow_forward_ios_rounded,
                                  color: Colors.black38,
                                size: 12,),
                              ),
                              elevation: 0.0,
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                              changeScreen(context, Address());
                            },
                            child: Card(
                              child: ListTile(
                                title: Text(
                                    "Shipping addresses"
                                ),
                                subtitle: Text(
                                    "manage your shipping address"
                                ),
                                trailing: Icon(Icons.arrow_forward_ios_rounded,
                                  color: Colors.black38,
                                size: 12,),
                              ),
                              elevation: 0.0,
                            ),
                          ),
                          EcommerceApp.sharedPreferences.getBool(EcommerceApp.isSellerVerified) == true ?
                           GestureDetector(
                             onTap: (){
                               print("Is the customer a seller :" +EcommerceApp.sharedPreferences.getBool(EcommerceApp.isSeller).toString());
                               print("Is the customer verified" +EcommerceApp.sharedPreferences.getBool(EcommerceApp.isSellerVerified).toString());
                               Navigator.pop(context);
                               changeScreen(context, SellerScreen());
                             },
                             child: Card(
                               child: ListTile(
                                 title: Text(
                                   "Seller dashboard"
                                 ),
                                 subtitle: Text(""
                                     "manage your seller page"),
                                 trailing: Icon(Icons.arrow_forward_ios_rounded,
                                   color: Colors.black38,
                                   size: 12,),
                               ),
                               elevation: 0.0,
                             ),
                           ) : Visibility(
                            visible: false,
                            child: Container(),
                          ),
                          GestureDetector(
                            onTap: (){
                              user.signOut();
                              Navigator.pop(context);
                              changeScreenReplacement(context, AuthenticScreen());
                            },
                            child: Card(
                              child: ListTile(
                                title: Text(
                                    "Sign out"
                                ),
                              ),
                              elevation: 0.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

 Widget showSellerWidget(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    if(EcommerceApp.sharedPreferences.getBool(EcommerceApp.isSeller) == true && EcommerceApp.sharedPreferences.getBool(EcommerceApp.isSellerVerified) == true){
      print("Is the customer a seller :" +EcommerceApp.sharedPreferences.getBool(EcommerceApp.isSeller).toString());
      print("Is the customer verified" +EcommerceApp.sharedPreferences.getBool(EcommerceApp.isSellerVerified).toString());
        return GestureDetector(
          onTap: (){
            Navigator.pop(context);
            changeScreen(context, SellerScreen());
          },
          child: Card(
            child: ListTile(
              title: Text(
                  "Seller dashboard"
              ),
              subtitle: Text(""
                  "manage your seller page"),
              trailing: Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.black38,
                size: 12,),
            ),
            elevation: 0.0,
          ),
        );

    }else {
      return Container();

    }
  }
}
