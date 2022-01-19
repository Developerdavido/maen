import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maen/Address/address.dart';
import 'package:maen/helpers/order_services.dart';
import 'package:maen/models/cartitem.dart';
import 'package:maen/models/users.dart';
import 'package:maen/providers/app_provider.dart';
import 'package:maen/providers/user_provider.dart';
import 'package:maen/screens/navigation.dart';
import 'package:maen/screens/navigation_controller.dart';
import 'package:maen/screens/product_details.dart';
import 'package:maen/screens/store_home.dart';
import 'package:maen/screens/testing.dart';
import 'package:maen/utils/common.dart';
import 'package:maen/utils/config.dart';
import 'package:maen/widgets/constants.dart';
import 'package:maen/widgets/empty_cart.dart';
import 'package:maen/widgets/loading.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _key = GlobalKey<ScaffoldState>();
  OrderServices _orderServices = OrderServices();
  UserModel _userModel;
  String quantity;
  TextEditingController addressController = TextEditingController();
  String address;
  Color favColor = Color(0xFFDEDEDE);
  Color orange = Color(0xFFFF4C00);
  Color ash = Color(0xFFECF1F7);
  Color blue = Color(0xFF0007A7);
  Color lightAsh = Color(0xFFFBFBFF);
  Color lightBlue = Color(0xFFE8E9FF);
  @override
  Widget build(BuildContext context) {
    final user  = Provider.of<UserProvider>(context);
    final app = Provider.of<AppProvider>(context);
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon:Image.asset("assets/icons/back-arrow.png",
            height: 22,
            width: 22,
            color: Colors.black,),
          onPressed: (){
            changeScreenReplacement(context, NavigationController());
          },
        ),
      ),
      body: app.isLoading ? Loading() : user.userModel.cart.isEmpty ? EmptyCart() : SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text("Your Cart",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.black,
                    fontWeight: FontWeight.w600
                  ),),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: ListView.builder(
                  itemCount: user.userModel.cart.length,
                  itemBuilder: (_, index){
                    print("THE PRICE IS: ${user.userModel.cart[index].price}");
                    print("THE QUANTITY IS: ${user.userModel.cart[index].quantity}");

                    return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: ash,
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    color: lightBlue
                                  ) ,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    child: Image.network(
                                      user.userModel.cart[index].image[0],
                                      height: 90,
                                      width: 90,
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(user.userModel.cart[index].title.toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800
                                          ),),
                                          Text("\GHC ${user.userModel.cart[index].cost}",
                                            style: TextStyle(
                                                color: blue,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600
                                            ),
                                          )
                                        ],
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 120.0,
                                            height: 48.0,
                                            decoration: BoxDecoration(
                                              color: lightBlue,
                                              borderRadius: BorderRadius.circular(12.0),
                                            ),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                buildSizedBox(
                                                    icon: Icons.remove,
                                                    press: ()async{
                                                      app.changeLoading();
                                                      bool value = await user.decreaseQuantity(user.userModel.cart[index]);
                                                      if(value){
                                                        user.reloadUserModel();
                                                        print("quantity has decreased");
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(content: Text("item updated"),)
                                                        );
                                                        app.changeLoading();
                                                        return;
                                                      }
                                                    }
                                                ),
                                                Padding(padding: const EdgeInsets.symmetric(
                                                    horizontal: 20 / 2
                                                ),
                                                  child: Text(
                                                    user.userModel.cart[index].quantity.toString(),
                                                    style: Constants.regularDarkText,
                                                  ),
                                                ),
                                                buildSizedBox(icon: Icons.add,
                                                  press: () async{
                                                    app.changeLoading();
                                                    bool value = await user.increaseQuantity(user.userModel.cart[index]);
                                                    if(value){
                                                      user.reloadUserModel();
                                                      print("quantity has been increased");
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text("item updated"),)
                                                      );
                                                      app.changeLoading();
                                                      return;
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete_outline,
                                              color: orange,
                                              size: 24,
                                            ),
                                            onPressed: () async{
                                              app.changeLoading();
                                              bool value = await user.removeFromCart(cartItem: user.userModel.cart[index]);
                                              if(value){
                                                user.reloadUserModel();
                                                print("Item has been removed from cart cart");
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text("Item has been removed from cart"))
                                                );
                                                app.changeLoading();
                                                return;
                                              }else {
                                                print("Item has not been removed from cart... please try again");
                                                app.changeLoading();
                                              }
                                            },
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                    ),
                    );
                  }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  if(user.userModel.totalCartPrice == 0){
                    showDialog(context: context,
                        builder: (BuildContext context){
                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)
                            ),
                            child: Container(
                              height: 200,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Sorry your cart is empty',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,

                                          ),
                                          textAlign: TextAlign.center,)
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.sentiment_dissatisfied,
                                        size: 48,
                                        color: Colors.red,),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                    return;
                  }
                  else
                    changeScreen(context, Address());
                },
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                      color: blue,
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "Checkout",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width * 0.24,
                  decoration: BoxDecoration(
                      color: ash,
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child: Center(
                    child: Text(
                      "\GHC ${user.userModel.totalCartPrice}",
                      style: TextStyle(
                          color: blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 16
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}