import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  static const ID = "id";
  static const NAME = "name";
  static const IMAGE = "image";

  //variables
  String _name;
  String _image;
  String _id;


  //===================getters ==========================
  String get name => _name;

  String get image => _image;

  String get id => _id;

  CategoryModel.fromSnapshot(DocumentSnapshot snapshot){
    _name  = snapshot.data[NAME];
    _id = snapshot.data[ID];
    _image = snapshot.data[IMAGE];
  }


}