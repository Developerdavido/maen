import 'package:flutter/material.dart';
import 'package:maen/Address/address.dart';
import 'package:maen/models/address.dart';
import 'package:maen/utils/config.dart';
import 'package:maen/widgets/constants.dart';

class AddAddress extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cRoomNumber = TextEditingController();
  final cStreet = TextEditingController();
  final cCity = TextEditingController();
  final String addressId = DateTime.now().millisecondsSinceEpoch.toString();

  Color blue = Color(0xFF0007A7);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(

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
            "Add new address",
            style: Constants.regularHeading,
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async{
            if(formKey.currentState.validate()){
              final model = AddressModel(
                name: cName.text.trim(),
                phoneNumber: cPhoneNumber.text,
                roomNumber: cRoomNumber.text,
                city: cCity.text.trim(),
                streetAddress: cStreet.text.trim(),
                id: addressId,
              ).toJson();

              //add to firestore
              await EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
                  .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
                  .collection(EcommerceApp.subCollectionAddress)
                  .document(addressId)
                  .setData(model)
                  .then((value) {
                final snack = SnackBar(content: Text("New address added successfully."));
                scaffoldKey.currentState.showSnackBar(snack);
                FocusScope.of(context).requestFocus(FocusNode());
                formKey.currentState.reset();
              });
              Route route = MaterialPageRoute(builder: (c) => Address());
              Navigator.pushReplacement(context, route);
            }
          },
          label: Text("Done"),
          backgroundColor: blue,
          icon: Icon(Icons.add_location),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Add new address",
                    style: Constants.regularHeading,
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      hint: "Name",
                      controller: cName,
                    ),
                    MyTextField(
                      hint: "Phone number",
                      controller: cPhoneNumber,
                    ),
                    MyTextField(
                      hint: "Room number if in a school or hostel",
                      controller: cRoomNumber,
                    ),
                    MyTextField(
                      hint: "Street address/ location",
                      controller: cStreet,
                    ),
                    MyTextField(
                      hint: "city or region",
                      controller: cCity,
                    )

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {

  final String hint;
  final TextEditingController controller;

  MyTextField({Key key, this.hint, this.controller}): super(key:key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (val) => val.isEmpty ? "Field must not be empty" : null,
      ),
    );
  }
}