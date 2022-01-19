import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:maen/models/address.dart';
import 'package:maen/models/order.dart';
import 'package:maen/providers/app_provider.dart';
import 'package:maen/providers/user_provider.dart';
import 'package:maen/screens/order_detail.dart';
import 'package:maen/utils/common.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    final user  = Provider.of<UserProvider>(context);
    final app = Provider.of<AppProvider>(context);
    setState(() {

    });
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.red),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Your Orders",
          style: TextStyle(
            color: Colors.red
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
            size: 16,
            color: Colors.red,
            ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
          itemCount: user.orders.length,
          itemBuilder: (_, index){
            OrderModel _order = user.orders[index];
            return GestureDetector(
              onTap: (){
                user.loadAddressByOrder(addressId: user.orders[index].address, userId: user.user.uid);
                changeScreen(context,
                OrderDetail(order: user.orders[index]));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[200],
                            offset: Offset(-2, -1),
                            blurRadius: 5),
                      ]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Icon(Icons.description,
                        size: 48,
                        color: Colors.red,),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Text(_order.description,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 10,),
                          Text(_order.address,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),
                            textAlign: TextAlign.left,),
                          SizedBox(height: 10,),
                          Text(DateTime.fromMillisecondsSinceEpoch(_order.createdAt).toString(),
                          style: TextStyle(
                            color: Colors.black26,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic
                          ),
                            textAlign: TextAlign.left,),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text("\GHC ${_order.total}",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                        ),),
                      )
                    ],
                  )
                ),
              ),
            );
          }),
    );
  }
}
