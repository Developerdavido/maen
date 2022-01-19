import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maen/Admin/adminOrderCard.dart';
import 'package:maen/Admin/brand_upload_screen.dart';
import 'package:maen/Admin/category_upload_screen.dart';
import 'package:maen/Admin/university_upload_screen.dart';
import 'package:maen/Admin/uploadProduct.dart';
import 'package:maen/Authentication/authentication.dart';
import 'package:maen/providers/user_provider.dart';
import 'package:maen/screens/store_home.dart';
import 'package:maen/utils/common.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Hello Admin ${user.userModel?.name}",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
                accountName: Text(
                  user.userModel?.name ?? "username loading...",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                accountEmail: Text(
                  user.userModel?.email ?? "email loading...",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  changeScreen(context, AdminScreen());
                },
                leading: Icon(Icons.home,
                  color: Colors.red,
                ),
                title: Text(
                  "Dashboard",
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w400),
                ),
              ),
              ListTile(
                onTap: () {
                  user.getOrders();
                  Navigator.pop(context);
                  changeScreen(context, AdminOrderCard());

                },
                leading: Icon(Icons.bookmark_border,
                  color: Colors.red,),
                title: Text(
                  "Orders",
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w400),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  changeScreen(context, UploadProduct());
                },
                trailing: Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.red,),
                title: Text(
                  "Upload products",
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w400),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  changeScreen(context, UploadBrand());

                },
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.red,
                ),
                title: Text(
                  "Upload brands",
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w400),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  changeScreen(context, UploadUniversity());
                },
                trailing: Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.red,),
                title: Text(
                  "Upload universities",
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w400),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  changeScreen(context, AddCategory());

                },
                trailing: Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.red,),
                title: Text(
                  "Upload category",
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w400),
                ),
              ),
              ListTile(
                onTap: () {
                  user.signOut();
                  Navigator.pop(context);
                  changeScreenReplacement(context, AuthenticScreen());

                },
                leading: Image.asset("assets/icons/sign-out.png",
                  height: 18,
                  width: 24,
                  color: Colors.red,),
                title: Text(
                  "Sign out",
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              color: Colors.white
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Material(
                        child: Card(
                          color: Colors.white,
                          elevation: 1.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width:  MediaQuery.of(context).size.width * 0.45,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "12",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red
                                  ),
                                ),
                                Text(
                                  "Sellers",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                    ),
                    SizedBox(width: 16,),
                    Material(
                      child: Card(
                        color: Colors.white,
                        elevation: 1.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width:  MediaQuery.of(context).size.width * 0.45,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "12",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red
                                ),
                              ),
                              Text(
                                "Total amount sold",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Material(
                      child: Card(
                        color: Colors.white,
                        elevation: 1.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width:  MediaQuery.of(context).size.width * 0.45,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "8",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red
                                ),
                              ),
                              Text(
                                "Total brands",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16,),
                    Material(
                      child: Card(
                        color: Colors.white,
                        elevation: 1.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width:  MediaQuery.of(context).size.width * 0.45,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "12",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red
                                ),
                              ),
                              Text(
                                "Average monthly income",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
