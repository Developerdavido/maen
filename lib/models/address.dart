import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {

  static const NAME = "name";
  static const PHONE_NUMBER = "phoneNumber";
  static const ROOM_NUMBER = "roomNumber";
  static const CITY = "city";
  static const STREET_ADDRESS = "streetAddress";
  static const ID = "id";


  String name;
  String phoneNumber;
  String roomNumber;
  String city;
  String streetAddress;
  String id;

  String get phoneNum => phoneNumber;

  String get roomNum => roomNumber;

  String get cityName => city;

  String get streetAdd => streetAddress;

  String get idNum => id;

  String get userName => name;

  AddressModel({
      this.name,
        this.phoneNumber,
        this.roomNumber,
        this.city,
        this.streetAddress,
      this.id});

  AddressModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    roomNumber = json['roomNumber'];
    city = json['city'];
    streetAddress = json['streetAddress'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['roomNumber'] = this.roomNumber;
    data['city'] = this.city;
    data['streetAddress'] = this.streetAddress;
    data['id'] = this.id;
    return data;
  }

  AddressModel.fromSnapshot(DocumentSnapshot snapshot){
    id = snapshot.data[ID];
    city = snapshot.data[CITY];
    name = snapshot.data[NAME];
    phoneNumber = snapshot.data[PHONE_NUMBER];
    streetAddress = snapshot.data[STREET_ADDRESS];
    roomNumber = snapshot.data[ROOM_NUMBER];
  }

  Map toMap() => {
    ID: id,
    CITY: city,
    NAME: name,
    PHONE_NUMBER: phoneNumber,
    STREET_ADDRESS: streetAddress,
    ROOM_NUMBER: roomNumber,

  };

}
