import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maen/Address/address.dart';
import 'package:maen/helpers/order_services.dart';
import 'package:maen/models/address.dart';
import 'package:maen/models/cartitem.dart';
import 'package:maen/providers/app_provider.dart';
import 'package:maen/providers/user_provider.dart';
import 'package:maen/screens/navigation.dart';
import 'package:maen/screens/navigation_controller.dart';
import 'package:maen/utils/common.dart';
import 'package:maen/utils/config.dart';
import 'package:maen/widgets/wideButton.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class PaymentPage extends StatefulWidget {
  final String addressId;
  final AddressModel addressModel;

   PaymentPage({Key key, this.addressId, this.addressModel}) : super(key: key);


  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _key = GlobalKey<ScaffoldState>();
  OrderServices _orderServices = OrderServices();
  int shipping = 5;
  int total;
  List<dynamic> cart;

  List<dynamic> address;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    final user  = Provider.of<UserProvider>(context);
    total = shipping + user.userModel.totalCartPrice;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final user  = Provider.of<UserProvider>(context);
    final app = Provider.of<AppProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        leading: IconButton(icon: Icon(Icons.arrow_back), color: Colors.white,
        onPressed: (){
          Navigator.pop(context);
        },),
        title: Text("Payment Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: size.height * 0.2,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: size.width * 0.8,
                      child: Table(
                        children: [
                          TableRow(
                              children: [
                                KeyText(msg: "Name",),
                                Text(widget.addressModel.name),
                              ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "Phone number",),
                                Text(widget.addressModel.phoneNumber),
                              ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "Room number",),
                                Text(widget.addressModel.roomNumber),
                              ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "Street address/ location",),
                                Text(widget.addressModel.streetAddress),
                              ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "city/region",),
                                Text(widget.addressModel.city),
                              ]
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top:8.0, bottom: 8.0, left: 18.0, right: 18.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("DELIVERY METHOD",
                  style: TextStyle(fontSize: 14, color: Colors.deepOrange,fontWeight: FontWeight.w600),),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top:8.0, bottom: 8.0, left: 18.0, right: 18.0),
              child: Container(
                height: size.height * 0.17,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),

                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Home or Office Delivery",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Your item will be delivered within 48 hours",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Table(
                        children: [
                          TableRow(
                              children: [
                                Text("Shipping: ",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.normal
                                  ),),
                                Text("GHC $shipping",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.bold
                                  ),
                                )
                              ]
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0, bottom: 8.0, left: 18.0, right: 18.0),
              child: Container(
                height: size.height * 0.17,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        children: [
                          TableRow(
                              children: [
                                Text("Subtotal: ",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.normal
                                  ),),
                                Text("GHC${user.userModel.totalCartPrice}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ]
                          ),
                          TableRow(
                              children: [
                                Text("Shipping fees: ",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.normal
                                  ),),
                                Text("GHC$shipping",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal
                                  ),
                                ),
                              ]
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 3,
                      thickness: 2,
                      color: Colors.grey[500],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        children: [
                          TableRow(
                              children: [
                                Text("Total: ",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.normal
                                  ),),
                                Text("GHC $total",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ]
                          )
                        ],
                      ),
                    )

                  ],
                ),
              ),
            ),

            WideButton(
              message: "Confirm Order",
              onPressed: () async{
                var uuid = Uuid();
                String id = uuid.v4();
                 _orderServices.createOrder(
                  userId: user.user.uid,
                  id: id,
                  description: "Cash on delivery",
                  status: "pending",
                  totalPrice: total,
                  cart: user.userModel.cart,
                  address: widget.addressId,
                  phone: user.userModel.phone,
                );
                user.reloadUserModel();
                for(CartItemModel cartItem in user.userModel.cart){
                  bool value = await user.removeFromCart(cartItem: cartItem);
                  if(value) {
                    user.reloadUserModel();
                    print("Item has been added to cart");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Item has been removed from cart"),)
                );
                }else {
                print(
                "item has not been removed from cart");
                }
                }
                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("your order has been created, please we will call you in a few minutes to confirm"),)
                );
                changeScreenReplacement(context, NavigationController());
              },
            )
          ],
        ),
      ),
    );

  }
  int newTotal(){
    final user  = Provider.of<UserProvider>(context);
    total = shipping + user.userModel.totalCartPrice;
    print("${user.userModel.totalCartPrice}");
    return total;
  }

}
