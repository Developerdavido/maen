import 'package:flutter/material.dart';
import 'package:maen/Address/address.dart';
import 'package:maen/models/address.dart';
import 'package:maen/models/cartitem.dart';
import 'package:maen/models/order.dart';

class SellerOrderDetail extends StatefulWidget {
  final OrderModel order;
  final AddressModel address;

  const SellerOrderDetail({@required this.order, @required this.address});

  @override
  _SellerOrderDetailState createState() => _SellerOrderDetailState();
}

class _SellerOrderDetailState extends State<SellerOrderDetail> {

  OrderModel orderModel;
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
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
                              Text(widget.address.name),
                            ]
                        ),
                        TableRow(
                            children: [
                              KeyText(msg: "Phone number",),
                              Text(widget.address.phoneNumber),
                            ]
                        ),
                        TableRow(
                            children: [
                              KeyText(msg: "Room number",),
                              Text(widget.address.roomNumber),
                            ]
                        ),
                        TableRow(
                            children: [
                              KeyText(msg: "Street address/ location",),
                              Text(widget.address.streetAddress),
                            ]
                        ),
                        TableRow(
                            children: [
                              KeyText(msg: "city/region",),
                              Text(widget.address.city),
                            ]
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
                itemCount: widget.order.cart.length,
                itemBuilder: (_, index) {
                  print(widget.order.cart.length.toString());
                  for(CartItemModel cartItem in widget.order.cart)
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
