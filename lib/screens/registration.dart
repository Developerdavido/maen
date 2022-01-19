import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maen/providers/category_provider.dart';
import 'package:maen/providers/product_provider.dart';
import 'package:maen/providers/shop_provider.dart';
import 'package:maen/providers/user_provider.dart';
import 'package:maen/screens/homepage.dart';
import 'package:maen/screens/login.dart';
import 'package:maen/utils/common.dart';
import 'package:maen/widgets/loading.dart';
import 'package:provider/provider.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final shopProvider = Provider.of<ShopProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      key: _key,
      body: authProvider.status == Status.Authenticating? Loading() : SingleChildScrollView(
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
            
//            Padding(
//              padding: const EdgeInsets.all(12),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Container(
//                    child: Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Container(
//                        width: 120,
//                        child: OutlineButton(
//                          borderSide: BorderSide(
//                            color: Colors.grey.withOpacity(0.5),
//                            width: 2.5
//                          ),
//                          onPressed: (){
//                            // _selectImage(
//                            //   ImagePicker.pickImage(source: ImageSource.gallery)
//                            // );
//                            authProvider.selectProfileImage(
//                              ImagePicker.pickImage(source: ImageSource.gallery),
//                            );
//                          },
//                          child: authProvider.displayProductChild(),
//                        ),
//                      ),
//                    ),
//                  )
//                ],
//              ),
//            ),
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
                    controller: authProvider.name,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Full name",
                      hintStyle: TextStyle(color: Colors.red),
                      labelStyle: TextStyle(color: Colors.red, fontSize: 14),
                      icon: Icon(Icons.person, color: Colors.red,),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value){
                      if(value.isEmpty){
                        return 'You must enter your full name';
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
                      return value;
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
                    controller: authProvider.password,
                    style: TextStyle(color: Colors.red),
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
                    controller: authProvider.confirmPassword,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Confirm password",
                      hintStyle: TextStyle(color: Colors.red),
                      icon: Icon(Icons.lock_outline, color: Colors.red,),
                    ),
                    obscureText: true,
                    validator: (value){
                      if(value.isEmpty){
                        return'The password field cannot be empty';
                      }else if(value.length < 6){
                        return 'The password has to be at least 6 characters long';
                      }else if(authProvider.password.text !=value){
                        return 'the passwords do not match';
                      }
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
                    controller: authProvider.phone,
                    style: TextStyle(color: Colors.red),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Phone number",
                      hintStyle: TextStyle(color: Colors.red),
                      labelStyle: TextStyle(color: Colors.red, fontSize: 14),
                      icon: Icon(Icons.phone, color: Colors.red,),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value){
                      if(value.isEmpty){
                        return 'You must enter your phone number';
                      }
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
                    controller: authProvider.town,
                    style: TextStyle(color: Colors.red),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Town",
                      hintStyle: TextStyle(color: Colors.red),
                      labelStyle: TextStyle(color: Colors.red, fontSize: 14),
                      icon: Icon(Icons.store, color: Colors.red,),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value){
                      if(value.isEmpty){
                        return 'You must enter the name of your town';
                      }
                    },
                  ),
                ),
              ),
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
                    controller: authProvider.address,
                    style: TextStyle(color: Colors.red),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Address",
                      hintStyle: TextStyle(color: Colors.red),
                      labelStyle: TextStyle(color: Colors.red, fontSize: 14),
                      icon: Icon(Icons.home, color: Colors.red,),
                    ),
                    keyboardType: TextInputType.multiline,
                    validator: (value){
                      if(value.isEmpty){
                        return 'You must enter your full address';
                      }
                      return value;
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
                  onPressed: ()async{
                    print("BTN CLICKED!!!!");
                    print("BTN CLICKED!!!!");
                    print("BTN CLICKED!!!!");
                    print("BTN CLICKED!!!!");
                    print("BTN CLICKED!!!!");
                    print("BTN CLICKED!!!!");

                    if(!await authProvider.signUp()){
                      _key.currentState.showSnackBar(
                        SnackBar(content: Text("Registration failed"),)
                      );
                      return;
                    }
                    categoryProvider.loadCategories();
//                    categoryProvider.loadSingleCategory();
                    productProvider.loadProducts();
//                    productProvider.loadFeaturedProducts();
//                    productProvider.loadFreshProducts();
//                    productProvider.loadDealsProducts();
                    authProvider.clearController();
                    changeScreenReplacement(context, HomePage());
                  },
                  minWidth: MediaQuery.of(context).size.width,
                  child: Text(
                    "Sign up",
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
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Already have an Account?",
                  style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
              child: InkWell(
                onTap: (){
                  changeScreen(context, LoginScreen());
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Login here",
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
