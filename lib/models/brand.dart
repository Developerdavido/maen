import 'package:cloud_firestore/cloud_firestore.dart';

class BrandModel{
  static const ID = "id";
  static const NAME  = "name";

  String _id;
  String _name;

  String get id => _id;

  String get name => _name;

  BrandModel.fromSnapshot(DocumentSnapshot snapshot){
    _id = snapshot.data[ID];
    _name = snapshot.data[NAME];
  }
}