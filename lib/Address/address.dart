import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maen/Address/addAddress.dart';
import 'package:maen/models/address.dart';
import 'package:maen/providers/address_provider.dart';
import 'package:maen/screens/placeOrderPayment.dart';
import 'package:maen/utils/config.dart';
import 'package:maen/widgets/constants.dart';
import 'package:maen/widgets/loadingWidget.dart';
import 'package:maen/widgets/wideButton.dart';
import 'package:provider/provider.dart';

class Address extends StatefulWidget {
  @override
  _AddressState createState() => _AddressState();
}
Color blue = Color(0xFF0007A7);
class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                color: Colors.white
            ),
          ),
          centerTitle: true,
          title: Text(
            "Address for shipping",
            style: Constants.regularHeading,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left:16.0, right: 16.0, top: 8, bottom: 8.0),
                child: Text("Select an address where we can ship your items",
                  style: Constants.regularHeading,),
              ),
            ),
            Consumer<AddressChanger>(builder: (context, address, c){
              return Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: EcommerceApp.firestore
                      .collection(EcommerceApp.collectionUser)
                      .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
                      .collection(EcommerceApp.subCollectionAddress).snapshots(),

                  builder: (context, snapshot)
                  {
                    return !snapshot.hasData
                        ? Center(child: circularProgress(),)
                        : snapshot.data.documents.length == 0
                        ? noAddressCard()
                        :ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return AddressCard(
                          currentIndex: address.count,
                          value: index,
                          addressId: snapshot.data.documents[index].documentID,
                          model: AddressModel.fromJson(snapshot.data.documents[index].data),
                        );
                      },
                    );
                  },
                ),
              );
            })
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            Route route = MaterialPageRoute(builder: (c) => AddAddress());
            Navigator.push(context, route);
          },
          label: Text("Add new Address"),
          backgroundColor: blue,
          icon: Icon(Icons.add_location),
        ),
      ),
    );
  }

  noAddressCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "images/address.png",
                height: 240.0,
                width: 240.0,
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("No shipment address has been saved.\nPlease add your shipment address so we can deliver your product",
                    style: Constants.regularDarkText,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  final AddressModel model;
  final String addressId;
  final int currentIndex;
  final int value;

  AddressCard({Key key, this.model, this.currentIndex, this.addressId, this.value}): super(key: key);

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap:(){
        Provider.of<AddressChanger>(context, listen:  false).displayResult(widget.value);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  Radio(
                    groupValue: widget.currentIndex,
                    value: widget.value,
                    activeColor: blue,
                    onChanged: (val){
                      Provider.of<AddressChanger>(context, listen: false).displayResult(val);
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.0),
                        width: screenWidth * 0.8,
                        child: Table(
                          children: [
                            TableRow(
                                children: [
                                  KeyText(msg: "Name",),
                                  Text(widget.model.name),
                                ]
                            ),
                            TableRow(
                                children: [
                                  KeyText(msg: "Phone number",),
                                  Text(widget.model.phoneNumber),
                                ]
                            ),
                            TableRow(
                                children: [
                                  KeyText(msg: "Room number",),
                                  Text(widget.model.roomNumber),
                                ]
                            ),
                            TableRow(
                                children: [
                                  KeyText(msg: "Street address/ location",),
                                  Text(widget.model.streetAddress),
                                ]
                            ),
                            TableRow(
                                children: [
                                  KeyText(msg: "city/region",),
                                  Text(widget.model.city),
                                ]
                            ),

                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
              widget.value == Provider.of<AddressChanger>(context).count
                  ? WideButton(
                message: "Proceed and checkout",
                onPressed: (){
                  Route route = MaterialPageRoute(builder: (c) => PaymentPage(
                    addressId: widget.addressId,
                    addressModel: widget.model
                  ));
                  Navigator.push(context, route);
                },
              ) :
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}


class KeyText extends StatelessWidget {
  final String msg;

  KeyText({Key key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(msg, style: Constants.regularHeading,);
  }
}
