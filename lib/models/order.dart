import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  static const ID = "id";
  static const DESCRIPTION = "description";
  static const CART = "cart";
  static const SELLER_IDS = "sellerIds";
  static const USER_ID = "userId";
  static const TOTAL = "total";
  static const SHOP_ID = "shopId";
  static const STATUS = "status";
  static const ADDRESS = "address";
  static const CREATED_AT = "createdAt";
  static const PHONE = "phone";

  String _id;
  String _description;
  String _userId;
  String _shopId;
  String _status;
  String _address;
  int _createdAt;
  int _total;
  String _phone;

// //  getters
  String get id => _id;

  String get description => _description;

  String get userId => _userId;

  String get status => _status;

  String get address => _address;

  String get shopId => _shopId;

  String get phone => _phone;

  int get total => _total;

  int get createdAt => _createdAt;

  // public variable
  List cart;

  List sellerIds;


  OrderModel.fromSnapshot(DocumentSnapshot snapshot){
    _id = snapshot.data[ID];
    _description = snapshot.data[DESCRIPTION];
    _total = snapshot.data[TOTAL];
    _status = snapshot.data[STATUS];
    _userId = snapshot.data[USER_ID];
    _createdAt = snapshot.data[CREATED_AT];
    cart = snapshot.data[CART] ?? [];
    sellerIds = snapshot.data[SELLER_IDS] ?? [];
    _address = snapshot.data[ADDRESS];
    _phone  = snapshot.data[PHONE];
    _shopId = snapshot.data[SHOP_ID];
  }

}
