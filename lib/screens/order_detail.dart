import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maen/Address/address.dart';
import 'package:maen/models/address.dart';
import 'package:maen/models/order.dart';
import 'package:maen/models/product.dart';
import 'package:maen/providers/app_provider.dart';
import 'package:maen/providers/user_provider.dart';
import 'package:provider/provider.dart';

class OrderDetail extends StatefulWidget {
  final OrderModel order;

  const OrderDetail({@required this.order});
  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  OrderModel orderModel;
  final _key = GlobalKey<ScaffoldState>();

  //colours
  Color favColor = Color(0xFFDEDEDE);
  Color orange = Color(0xFFFF4C00);
  Color ash = Color(0xFFECF1F7);
  Color blue = Color(0xFF0007A7);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final app = Provider.of<AppProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.red),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("Order #"+widget.order.id,
        style: TextStyle(
          color: Colors.red,
          fontSize: 12
        ),),
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
      body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 0, bottom: 12),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: showStatusContainer(context)
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
              child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: user.addressByOrders.length,
                      itemBuilder: (_ , index) {
                        AddressModel _addressModel = user.addressByOrders[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
                              width: MediaQuery.of(context).size.width,
                              child: Table(
                                children: [
                                  TableRow(
                                      children: [
                                        KeyText(msg: "Name",),
                                        Text(_addressModel.name),
                                      ]
                                  ),
                                  TableRow(
                                      children: [
                                        KeyText(msg: "Phone number",),
                                        Text(_addressModel.phoneNumber),
                                      ]
                                  ),
                                  TableRow(
                                      children: [
                                        KeyText(msg: "Room number",),
                                        Text(_addressModel.roomNumber),
                                      ]
                                  ),
                                  TableRow(
                                      children: [
                                        KeyText(msg: "Street address/ location",),
                                        Text(_addressModel.streetAddress),
                                      ]
                                  ),
                                  TableRow(
                                      children: [
                                        KeyText(msg: "city/region",),
                                        Text(_addressModel.city),
                                      ]
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
              ),
            ),

              Expanded(
                child: ListView.builder(
                  itemCount: widget.order.cart.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: EdgeInsets.all(16),
                        child: Container(
                          height: 110,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.red.withOpacity(0.2),
                                    offset: Offset(3,2 ),
                                    blurRadius: 30
                                )
                              ]
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  child: Image.network(
                                    widget.order.cart[index]["image"][0],
                                    height: 100,
                                    width: 100,
                                  ),
                                ),
                              ),

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(widget.order.cart[index]["title"],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800
                                            ),),
                                          Text("\GHC${widget.order.cart[index]["price"]}",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400
                                            ),
                                          )
                                        ],
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 20,),
                                          Text("Quantity: "),
                                          Container(
                                            width: 10,
                                            height: 30,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(widget.order.cart[index]["quantity"].toString(), style:
                                              TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
                                            ),
                                          ),

                                          SizedBox(width: 20,),
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
    );
  }

   showStatusContainer(BuildContext context) {
    if(widget.order.status == "complete") {
      return Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.green
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(widget.order.status, style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal
              ),
              textAlign: TextAlign.center,),
            ),
            Icon(Icons.check_circle_outline,
              color: Colors.white,
              size: 24,)
          ],
        ),
      );
    }else if (widget.order.status == "pending"){
      return Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.yellow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.order.status, style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal
            ),),
            Icon(Icons.remove_circle_outline,
              color: Colors.white,
              size: 24,)
          ],
        ),
      );
    }

  }
}
