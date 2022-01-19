import 'package:flutter/material.dart';
import 'package:maen/screens/navigation_controller.dart';
import 'package:maen/screens/search_page.dart';
import 'package:maen/utils/config.dart';
import 'package:maen/widgets/account_dialog.dart';
import 'package:maen/widgets/new_products.dart';
import 'package:maen/widgets/promos.dart';

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey[100],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage()));
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0, right: 32),
                        child: Icon(Icons.search, color: Colors.black, size: 16,),
                      ),
                      Text("Search for your item",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.black),),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 16),
                child: GestureDetector(
                  onTap: (){
                    showDialog(context: context,
                        builder: (BuildContext context) => AccountDialog(
                          yourName: EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
                        ));
                  },
                  child: Material(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    elevation: 0,
                    child: Container(
                      height: 35.0,
                      width: 35.0,
                      child: CircleAvatar(
                        backgroundImage: (EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl) == null) ?
                        AssetImage('images/admin.png')
                        : NetworkImage(
                          EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: New(),
      // bottomNavigationBar: NavigationController(),
    );
  }
}
