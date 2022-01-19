import 'package:cloud_firestore/cloud_firestore.dart';

class ShopModel{
  static const ID = "id";
  static const NAME = "name";
  static const AVG_PRICE = "avgPrice";
  static const IMAGE = "image";
  static const POPULAR = "popular";

  String _id;
  String _name;
  double _avgPrice;
  String _image;
  bool _popular;

  //===============getters================

  String get id => _id;

  String get name => _name;

  double get avgPrice => _avgPrice;

  String get image => _image;

  bool get popular => _popular;


  ShopModel.fromSnapshot(DocumentSnapshot snapshot){
    _id = snapshot.data[ID];
    _avgPrice = snapshot.data[AVG_PRICE];
    _name = snapshot.data[NAME];
    _image = snapshot.data[IMAGE];
    _popular = snapshot.data[POPULAR];
  }


}