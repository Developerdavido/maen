import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maen/models/cartitem.dart';

class UserModel{
  static const ID = "id";
  static const NAME = "name";
  static const EMAIL = "email";
  static const IMAGE_URL = "imageUrl";
  static const PHONE = "phone";
  static const TOWN = "town";
  static const ADDRESS = "address";
  static const CART = "cart";
  static const UNIVERSITY = "university";
  static const IS_SELLER = "isSeller";
  static const IS_SELLER_VERIFIED = "isSellerVerified";
  static const FAVORITE = "favorite";
  static const STRIPE_ID = "stripeId";

  String _name;
  String _email;
  String _id;
  String _phone;
  String _town;
  String _stripeId;
  String _address;
  String _imageUrl;
  String _university;
  bool _isSeller;
  bool _isSellerVerified;
  //public variables
  List favorite;
  List<CartItemModel> _cart;

  UserModel(this._name, this._email, this._id, this._phone, this._town,
      this._stripeId, this._address, this._imageUrl, this.favorite, this._isSeller, this._isSellerVerified,
      this._cart, this._university);
    int _priceSum = 0;
  int _quantitySum = 0;




  //========== declaring getters for variables ================
  String get name => _name;

  String get email => _email;

  String get id => _id;

  String get phone => _phone;

  String get town => _town;

  bool get isSeller => _isSeller;

  bool get isSellerVerified => _isSellerVerified;

  String get stripeId => _stripeId;

  String get address => _address;

  String get image => _imageUrl;

  String get university => _university;

  List<CartItemModel> get cart => _cart;


  int totalCartPrice;

  UserModel.fromSnapshot(DocumentSnapshot snapshot){
    _name = snapshot.data[NAME];
    _email = snapshot.data[EMAIL];
    _id = snapshot.data[ID];
    _phone = snapshot.data[PHONE];
    _town = snapshot.data[TOWN];
    _stripeId = snapshot.data[STRIPE_ID];
    _isSeller = snapshot.data[IS_SELLER];
    _isSellerVerified = snapshot.data[IS_SELLER_VERIFIED];
    _address = snapshot.data[ADDRESS];
    _imageUrl = snapshot.data[IMAGE_URL];
    _university = snapshot.data[UNIVERSITY];
    _cart = _convertCartItems(snapshot.data[CART] ?? []);
    totalCartPrice = snapshot.data[CART] == null ? 0 : getTotalPrice(cart: snapshot.data[CART]);
    favorite = snapshot.data[FAVORITE] ?? [];
  }

  // Convert from firebase to cartitems
  List<CartItemModel> _convertCartItems(List cart){
    List<CartItemModel> convertedCart = [];
    for (Map cartItem in cart) {
      convertedCart.add(CartItemModel.fromMap(cartItem));
    }
    return convertedCart;
  }

  int getTotalPrice({List cart}) {
    if(cart == null) {
      return 0;
    }
    for(Map cartItem in cart){
      _priceSum += cartItem["price"] * cartItem["quantity"];

    }

    int total = _priceSum;

    print("THE TOTAL IS $total");
    print("THE TOTAL IS $total");
    print("THE TOTAL IS $total");
    print("THE TOTAL IS $total");
    print("THE TOTAL IS $total");

    return total;
  }


}