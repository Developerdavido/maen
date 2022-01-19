import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel{
  static const ID = "id";
  static const NAME = "name";
  static const IMAGE = "image";
  static const PRODUCT_ID = "productId";
  static const QUANTITY = "quantity";
  static const PRICE = "price";
  static const SIZE = "size";
  static const SHOP_ID = "shopId";

  String _id;
  String _name;
  String _image;
  String _productId;
  String _size;
  String _shopId;
  int _quantity;
  int _price;

  String get id => _id;

  String get name => _name;

  int get price => _price;

  int get quantity => _quantity;

  String get size => _size;

  String get productId => _productId;

  String get image => _image;

  String get shopId => _shopId;

  CartModel.fromSnapShot(DocumentSnapshot snapshot){
    _id = snapshot.data[ID];
    _name = snapshot.data[NAME];
    _image = snapshot.data[IMAGE];
    _productId = snapshot.data[PRODUCT_ID];
    _quantity = snapshot.data[QUANTITY];
    _price = snapshot.data[PRICE];
    _size = snapshot.data[SIZE];
    _shopId = snapshot.data[SHOP_ID];

}


}