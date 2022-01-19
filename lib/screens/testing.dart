import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maen/models/product.dart';
import 'package:maen/providers/product_provider.dart';
import 'package:maen/screens/store_home.dart';
import 'package:maen/utils/common.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Testing extends StatefulWidget {
  @override
  _TestingState createState() => _TestingState();
}

class _TestingState extends State<Testing> {
 

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                height: 400,
                width: 350,
                child: Image.asset('assets/thank_you.png', fit: BoxFit.fill,),
              ),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text("Thank you for testing our application, please click on the button to fill an online survery and let us know how we can improve upon the quality of the maen app",
                style: TextStyle(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.w500,),
                textAlign: TextAlign.justify,),
              ),

              Padding(
                padding: const EdgeInsets.all(14.0),
                child: SizedBox(
                  height: 40,
                  width: 250,
                  child: RaisedButton(
                    color: Colors.redAccent,
                      onPressed: () async {
                        const url = 'https://www.flutter.dev';
                        if(await canLaunch(url)){
                          await launch(url);
                        }else{
                          throw 'Could not launch $url';
                        }
                        changeScreenReplacement(context, StoreHome());
                      },
                  child: Text("Take suvey",
                  style: TextStyle(color: Colors.white, fontSize: 18),),),
                ),
              )
            ],
          ),
        ),
      ),
      );
                
}
}