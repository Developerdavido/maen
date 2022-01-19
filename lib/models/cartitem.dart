import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

// part 'cartitem.g.dart';

@JsonSerializable(explicitToJson: true)
class CartItemModel {
  static const ID = "id";
  static const TITLE = "title";
  static const IMAGE = "image";
  static const PRODUCT_ID = "productId";
  static const QUANTITY = "quantity";
  static const PRICE = "price";
  static const COST = "cost";
  static const SIZE = "size";
  static const ADMIN_ID = "adminId";
  static const SELLER_ID = "sellerId";
  static const TOTAL_SHOP_SALES = "totalShopSale";


  String _id;
  String _title;
  List _image;
  String _productId;
  String _size;
  String _adminId;
  String _sellerId;
  int _quantity;
  int _price;
  int _cost;
  int _totalShopSale;

  //  getters
  String get id => _id;

  String get title => _title;

  List get image => _image;

  String get size => _size;

  String get productId => _productId;

  int get price => _price;

  int get quantity => _quantity;

  int get cost => _cost;

  String get adminId => _adminId;

  String get sellerId => _sellerId;

  int get totalShopSale => _totalShopSale;


  set quantity(int newQuantity) {
    _quantity = newQuantity;
  }


  set cost(int value) {
    _cost = value;
  }

  CartItemModel(this._id, this._title, this._image, this._productId, this._size,
      this._quantity, this._price, this._cost);

  CartItemModel.fromMap(Map data){
    _id = data[ID];
    _title =  data[TITLE];
    _image =  data[IMAGE];
    _productId = data[PRODUCT_ID];
    _price = data[PRICE];
    _quantity = data[QUANTITY];
    _cost = data[COST];
    _size = data[SIZE];
    _sellerId = data[SELLER_ID];
    _totalShopSale = data[TOTAL_SHOP_SALES];
    _adminId = data[ADMIN_ID];

  }
  // factory CartItemModel.fromJson(Map<String, dynamic> data) => _$CartItemModelFromJson(data);
  //
  // Map<String,dynamic> toJson() => _$CartItemModelToJson(this);

  CartItemModel.fromSnapShot(DocumentSnapshot snapshot){
    _id = snapshot.data[ID];
    _title = snapshot.data[TITLE];
    _image = snapshot.data[IMAGE];
    _productId = snapshot.data[PRODUCT_ID];
    _quantity = snapshot.data[QUANTITY];
    _price = snapshot.data[PRICE];
    _size = snapshot.data[SIZE];
    _sellerId = snapshot.data[SELLER_ID];
    _adminId = snapshot.data[ADMIN_ID];
    _totalShopSale = snapshot.data[TOTAL_SHOP_SALES];
    _cost = snapshot.data[COST];
  }

  Map toMap() => {
    ID: _id,
    IMAGE: _image,
    TITLE: _title,
    PRODUCT_ID: _productId,
    QUANTITY: _quantity,
    PRICE: _price,
    COST: _price * _quantity,
    SIZE: _size,
    ADMIN_ID : _adminId,
    TOTAL_SHOP_SALES : _totalShopSale,
    SELLER_ID : _sellerId

  };


}