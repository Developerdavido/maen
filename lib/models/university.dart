import 'package:cloud_firestore/cloud_firestore.dart';

class UniversityModel {
  static const ID = "id";
  static const NAME  = "name";

  String _id;
  String _name;

  String get id => _id;

  String get name => _name;

  UniversityModel.fromSnapshot(DocumentSnapshot snapshot){
    _id = snapshot.data[ID];
    _name = snapshot.data[NAME];
  }
}