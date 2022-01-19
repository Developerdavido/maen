import 'package:flutter/material.dart';
import 'package:maen/providers/user_provider.dart';
import 'package:maen/screens/login.dart';
import 'package:maen/utils/common.dart';
import 'package:maen/widgets/loading.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final authProvider =  Provider.of<UserProvider>(context);
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
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
                Text('Please fill in your email and an email with a link on resetting your password will be sent to you', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),)
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
              child: Material(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.red,
                elevation: 2.0,
                child: MaterialButton(
                  onPressed: () async{
                    if(!await authProvider.resetPassword()){
                      _key.currentState.showSnackBar(
                        SnackBar(content: Text("Sending email link failed, please check your email or network and try again"),)
                      );
                      return;
                  }
                  changeScreen(context, LoginScreen());
                  },
                  minWidth: MediaQuery.of(context).size.width,
                  child: Text(
                    "Send me an Email",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ) , 
    );
  }
}
