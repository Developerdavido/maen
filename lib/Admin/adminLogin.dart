import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maen/Admin/admin_screen.dart';
import 'package:maen/Admin/uploadProduct.dart';
import 'package:maen/Authentication/authentication.dart';
import 'package:maen/DialogBox/errorDialog.dart';
import 'package:maen/utils/config.dart';
import 'package:maen/widgets/constants.dart';
import 'package:maen/widgets/custom_btn.dart';
import 'package:maen/widgets/custom_input.dart';

class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              color: Colors.white
          ),
        ),
        title: Text(
          "Maen",
          style: Constants.boldHeading,
        ),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final TextEditingController _adminIdTextEditingController = TextEditingController();
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
    double _screenWidth = MediaQuery.of(context).size.width, _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Image.asset(
                "images/admin.png",
                height: 240.0,
                width: 240.0,
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 24.0,
                ),
                child: Text(
                  "Admin",
                  textAlign: TextAlign.center,
                  style: Constants.boldHeading,
                ),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      CustomInput(
                        controller: _adminIdTextEditingController,
                        data: Icons.person,
                        hintText: "id",
                        isPasswordField: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        validator: (value){
                          if(value.isEmpty){
                            return 'Please make sure id field is not empty';
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
                    ],
                  )
              ),
              SizedBox(height: 30,),
              CustomBtn(
                text: "Login",
                onPressed: (){
                  _adminIdTextEditingController.text.isNotEmpty
                      && _passwordTextEditingController.text.isNotEmpty
                      ? loginAdmin()
                      : showDialog(context: context,
                      builder: (c)
                      {
                        return ErrorAlertDialog(message: "Please fill in your email and password",);
                      });
                },
              ),
              SizedBox(height: 50,),
              Container(
                height: 2.0,
                width: _screenWidth * 0.8,
                color: Colors.black,
              ),
              SizedBox(height: 15,),

              FlatButton.icon(
                onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> AuthenticScreen())),
                icon: (Icon(Icons.nature_people, color: Colors.black,)),
                label: Text("I'm not an admin",
                  style: Constants.regularHeading,),
              ),
              SizedBox(height: 50,)
            ],
          )
      ),

    );
  }

  loginAdmin() {
    Firestore.instance.collection("admins").getDocuments().then((snapshot) {
      snapshot.documents.forEach((result) {
        if(result.data["id"] != _adminIdTextEditingController.text.trim())
        {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Your admin id is not correct, please try again")));
        }
        else if(result.data["password"] != _passwordTextEditingController.text.trim())
        {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Your admin password is not correct, please try again")));
        }
        else
        {

          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Welcome dear Admin, "+ result.data["name"] )));

          EcommerceApp.sharedPreferences.setString(EcommerceApp.adminUserId, _adminIdTextEditingController.text.trim());

          setState(() {
            _adminIdTextEditingController.text = "";
            _passwordTextEditingController.text = "";
          });

          Route route = MaterialPageRoute(builder: (c) => AdminScreen());
          Navigator.pushReplacement(context, route);
        }

      });
    });
  }
}

