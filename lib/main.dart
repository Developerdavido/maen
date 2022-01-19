import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maen/Authentication/authentication.dart';
import 'package:maen/providers/address_provider.dart';
import 'package:maen/providers/app_provider.dart';
import 'package:maen/providers/brand_provider.dart';
import 'package:maen/providers/category_provider.dart';
import 'package:maen/providers/comment_provider.dart';
import 'package:maen/providers/product_provider.dart';
import 'package:maen/providers/shop_provider.dart';
import 'package:maen/providers/university_provider.dart';
import 'package:maen/providers/user_provider.dart';
import 'package:maen/screens/details.dart';
import 'package:maen/screens/homepage.dart';
import 'package:maen/screens/login.dart';
import 'package:maen/screens/navigation.dart';
import 'package:maen/screens/navigation_controller.dart';
import 'package:maen/screens/select_university_screen.dart';
import 'package:maen/screens/store_home.dart';
import 'package:maen/screens/test_details.dart';
import 'package:maen/screens/testing.dart';
import 'package:maen/theme/theme.dart';
import 'package:maen/utils/config.dart';
import 'package:maen/widgets/constants.dart';
import 'package:maen/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = Firestore.instance;
  final theme = MaenTheme.light();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: AppProvider()),
      ChangeNotifierProvider.value(value: UserProvider.initialize()),
      ChangeNotifierProvider.value(value: CategoryProvider.initialize()),
      ChangeNotifierProvider.value(value: UniversityProvider.initialize()),
      ChangeNotifierProvider.value(value: ShopProvider.initialize()),
      ChangeNotifierProvider.value(value: ProductProvider.initialize()),
      ChangeNotifierProvider.value(value: BrandProvider.initialize()),
      ChangeNotifierProvider.value(value: CommentProvider.initialize()),
      ChangeNotifierProvider(create: (c) => AddressChanger()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maen',
      theme: theme,
      home: SplashScreen(),
    ),
  ));
}

class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth =  Provider.of<UserProvider>(context);
    switch (auth.status) {
      case Status.Uninitialized:
        return Loading();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return LoginScreen();
      case Status.Authenticated:
        return SelectUniversity();
      default:
        return LoginScreen();

    }
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    displaySplash();
  }

  displaySplash() {
    Timer(Duration(seconds: 5), () async {
      if (await EcommerceApp.auth.currentUser() != null) {
        Route route = MaterialPageRoute(builder: (_) => NavigationController());
        Navigator.pushReplacement(context, route);
      } else {
        Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("images/welcome.png"),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Opt for Quality",
                style: Constants.regularHeading,
              ),
            ],
          )),
    );
  }
}



