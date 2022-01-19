import 'package:flutter/material.dart';
import 'package:maen/Authentication/login_auth.dart';
import 'package:maen/Authentication/register_auth.dart';

class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {

   Color primaryColor = Color(0xFF0007A7);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: TabBarView(
            children: <Widget>[
              LoginAuth(),
              RegisterAuth(),
            ],
          ),
        ),
        bottomNavigationBar: TabBar(
          indicator: BoxDecoration(
            color: Color(0xFF0007A7)
          ),
          tabs: [
            Tab(
              text: "Login",
            ),
            Tab(
              text: "Register",
            ),
          ],
          indicatorWeight: 3.0,
          unselectedLabelColor: Colors.black,
          labelColor: Colors.white,
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
      ),
    );
  }
}