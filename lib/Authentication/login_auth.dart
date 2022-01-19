import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maen/Admin/adminLogin.dart';
import 'package:maen/DialogBox/errorDialog.dart';
import 'package:maen/DialogBox/loadingDialog.dart';
import 'package:maen/providers/category_provider.dart';
import 'package:maen/providers/product_provider.dart';
import 'package:maen/providers/shop_provider.dart';
import 'package:maen/providers/user_provider.dart';
import 'package:maen/screens/homepage.dart';
import 'package:maen/screens/navigation.dart';
import 'package:maen/screens/navigation_controller.dart';
import 'package:maen/screens/select_university_screen.dart';
import 'package:maen/screens/store_home.dart';
import 'package:maen/theme/theme.dart';
import 'package:maen/utils/config.dart';
import 'package:maen/widgets/constants.dart';
import 'package:maen/widgets/custom_btn.dart';
import 'package:maen/widgets/custom_input.dart';
import 'package:provider/provider.dart';

class LoginAuth extends StatefulWidget {
  @override
  _LoginAuthState createState() => _LoginAuthState();
}

class _LoginAuthState extends State<LoginAuth> {

  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Focus node for input field
  FocusNode _passwordFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    double _screenWidth = MediaQuery.of(context).size.width, _screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 24.0),
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 24.0,
                    ),
                    child: Text(
                      "Login",
                      textAlign: TextAlign.left,
                      style: MaenTheme.lightTextTheme.headline1,
                    ),
                  ),
                ),
                Center(
                  child: Image.asset(
                    "images/login.png",
                    height: 270.0,
                    width: 250.0,
                  ),
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        CustomInput(
                          controller: _emailTextEditingController,
                          data: Icons.email,
                          hintText: "Email",
                          isPasswordField: false,
                          textInputAction: TextInputAction.next,
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
                          onSubmitted: (value) {
                            _passwordFocusNode.requestFocus();
                          },
                        ),
                        CustomInput(
                          controller: _passwordTextEditingController,
                          data: Icons.lock,
                          hintText: "Password",
                          isPasswordField: true,
                          textInputAction: TextInputAction.next,
                          validator: (value){
                            if(value.isEmpty){
                              return'The password field cannot be empty';
                            }else if(value.length < 6){
                              return 'The password has to be at least 6 characters long';
                            }
                            return value;
                          },
                          onSubmitted: (value) {

                          },
                        ),
                        CustomBtn(
                          text: "Login",
                          onPressed: (){
                            _emailTextEditingController.text.isNotEmpty
                                && _passwordTextEditingController.text.isNotEmpty
                                ? loginUser()
                                : showDialog(context: context,
                                builder: (c)
                                {
                                  return ErrorAlertDialog(message: "Please fill in your email and password",);
                                });
                            productProvider.loadProducts();
                            productProvider.loadFeaturedProducts();
                            userProvider.loadSellers();
                          },
                        ),
                        SizedBox(height: 30,),
                        Container(
                          height: 2.0,
                          width: _screenWidth * 0.8,
                          color: Colors.black,
                        ),
                        SizedBox(height: 15,),

                        FlatButton.icon(
                          onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminSignInPage())),
                          icon: (Icon(Icons.nature_people, color: Colors.black,)),
                          label: Text("I'm an admin",
                            style: Constants.regularHeading,),
                        )
                      ],
                    )
                ),
              ],
            )
        ),

      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser() async{
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Authenticating, please wait......",
          );
        }
    );
    FirebaseUser firebaseUser;
    await _auth.signInWithEmailAndPassword(
        email: _emailTextEditingController.text.trim(),
        password:_passwordTextEditingController.text.trim()).then((authUser) =>
    firebaseUser = authUser.user).catchError((error){
      Navigator.pop(context);
      showDialog(context: context,
          builder: (c)
          {
            return ErrorAlertDialog(message: error.message.toString(),);
          });
    });
    if(firebaseUser != null){
      readData(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => SelectUniversity());
        Navigator.pushReplacement(context, route);
      });
    }

  }

  Future readData(FirebaseUser firebaseUser) async{
    Firestore.instance.collection("users").document(firebaseUser.uid).get().then((dataSnapshot) async {
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userUID, dataSnapshot.data[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userEmail, dataSnapshot.data[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userName, dataSnapshot.data[EcommerceApp.userName]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userAvatarUrl, dataSnapshot.data[EcommerceApp.userAvatarUrl]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userPhone, dataSnapshot.data[EcommerceApp.userPhone]);
      await EcommerceApp.sharedPreferences.setBool(
          EcommerceApp.isSeller, dataSnapshot.data[EcommerceApp.isSeller]);
      await EcommerceApp.sharedPreferences.setBool(
          EcommerceApp.isSellerVerified, dataSnapshot.data[EcommerceApp.isSellerVerified]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.university, dataSnapshot.data[EcommerceApp.university]);

    });
  }
}
