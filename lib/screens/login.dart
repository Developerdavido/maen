import 'package:flutter/material.dart';
import 'package:maen/providers/category_provider.dart';
import 'package:maen/providers/product_provider.dart';
import 'package:maen/providers/seller_provider.dart';
import 'package:maen/providers/shop_provider.dart';
import 'package:maen/providers/user_provider.dart';
import 'package:maen/screens/forgot_password.dart';
import 'package:maen/screens/homepage.dart';
import 'package:maen/screens/registration.dart';
import 'package:maen/utils/common.dart';
import 'package:maen/widgets/loading.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final sellerProvider = Provider.of<SellerProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      key: _key,
      body: authProvider.status == Status.Authenticating ? Loading() : SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
              width: double.infinity,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //place an image but replace with a sized box
                SizedBox(
                  height: 120,
                  width: 120,
                ),
              ],
            ),

            SizedBox(
              height: 40,
              width: double.infinity,
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(6)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.red),
                    controller: authProvider.email,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.red),
                      labelStyle: TextStyle(color: Colors.red, fontSize: 14),
                      icon: Icon(Icons.email, color: Colors.red,),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value){
                      if(value.isEmpty){
                        Pattern pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = new RegExp(pattern);
                        if(!regex.hasMatch(value))
                          return 'Please make sure your email address is valid';
                        else
                          return null;
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(6)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.red),
                    controller: authProvider.password,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.red),
                      icon: Icon(Icons.lock_outline, color: Colors.red,),
                    ),
                    obscureText: true,
                    validator: (value){
                      if(value.isEmpty){
                        return'The password field cannot be empty';
                      }else if(value.length < 6){
                        return 'The password has to be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
              child: Material(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.red,
                elevation: 2.0,
                child: MaterialButton(
                  onPressed: () async{
                    if(!await authProvider.signIn()){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Login failed"),)
                      );
                      return;
                    }
                    categoryProvider.loadCategories();
                    sellerProvider.loadSellers();
                    sellerProvider.loadSingleSeller();
                    categoryProvider.loadSingleCategory();
                    productProvider.loadProducts();
                    productProvider.loadFeaturedProducts();
                    productProvider.loadPromoProducts();

                    authProvider.clearController();
                    changeScreenReplacement(context, HomePage());
                  },
                  minWidth: MediaQuery.of(context).size.width,
                  child: Text(
                    "Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
              child: InkWell(
                onTap: (){
                  changeScreen(context, ForgotPassword());
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Dont have an Account?",
                  style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
              child: InkWell(
                onTap: (){
                  changeScreen(context, Registration());
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

          ],

        ),
      ),
    );
  }
}
