import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:maen/helpers/order_services.dart';
import 'package:maen/helpers/user_services.dart';
import 'package:maen/models/address.dart';
import 'package:maen/models/cartitem.dart';
import 'package:maen/models/order.dart';
import 'package:maen/models/product.dart';
import 'package:maen/models/users.dart';
import 'package:maen/utils/config.dart';
import 'package:uuid/uuid.dart';

enum Status{Uninitialized, Authenticated, Authenticating, Unauthenticated}

class UserProvider with ChangeNotifier{
  FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;
  Firestore _firestore = Firestore.instance;
  UserServices _userServices = UserServices();
  OrderServices _orderServices = OrderServices();
  UserModel _userModel;
  OrderModel _orderModel;
  String userImageUrl = "";
  String usersCollection = 'users';
  int _total_sales = 0;


  //TODO: Create OrderServices with its variables
  List<OrderModel> orders = [];
  List<OrderModel> sellerOrders = [];
  List<OrderModel> sellerOrdersSecond = [];
  List<AddressModel> addressByOrders = [];
  List<AddressModel> addresses = [];
  List<CartItemModel> cartItems = [];
  List<UserModel> sellers = [];

  //  getter
  UserModel get userModel => _userModel;
  OrderModel get orderModel => _orderModel;
  Status get status => _status;
  FirebaseUser get user => _user;

  final formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController town = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  // File _image;

  UserProvider.initialize(): _auth = FirebaseAuth.instance{
    _auth.onAuthStateChanged.listen(_onStateChanged);
    loadSellers();
  }

  //function to sign into the application
  Future<bool> signIn() async{
    try{
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email.text.trim(), password: password.text.trim());
      return true;
    }catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  // function to reset password
  Future<bool> resetPassword() async{
    try{
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.sendPasswordResetEmail(email: email.text.trim());
      return true;
    }catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  //function for signing on to firebase
  Future<bool> signUp() async{
    try {
      _status = Status.Authenticating;
      notifyListeners();
        await _auth.createUserWithEmailAndPassword(
            email: email.text.trim(), password: password.text.trim()).then((
            result) {
          _firestore.collection(usersCollection).document(result.user.uid).setData({
            'name': name.text,
            'email': email.text,
            'uid': result.user.uid,
            'phone': phone.text,
            'town': town.text,
            'address': address.text
          });


        });
      return true;
    }catch(e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }


  }


  //function for signing out of firebase
  Future signOut()async{
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  //function to clear textfields after submitting
  void clearController(){
    name.text = "";
    password.text = "";
    email.text = "";
    address.text = "";
    town.text = "";
    phone.text = "";
  }

  // updating user data
  updateUserData(Map<String, dynamic> data) {
    _firestore.collection(usersCollection)
        .document(user.uid)
        .updateData(data);
  }
  //function for refreshing user state in the app
  Future<void> reloadUserModel()async{
    _userModel = await _userServices.getUserById(user.uid);
    notifyListeners();
  }

  //function for monitoring the state of the user in the application
  Future<void> _onStateChanged(FirebaseUser firebaseUser) async{
    if(firebaseUser == null){
      _status = Status.Unauthenticated;
    }else{
      _user = firebaseUser;
      _status = Status.Authenticated;
      _userModel = await _userServices.getUserById(user.uid);
    }
    notifyListeners();
  }


  //function for adding to cart
  Future<bool> addToCard({ProductModel product, int quantity, String size, int cost})async{
    print("THE PRODUCT IS: ${product.toString()}");
    print("THE qty IS: ${quantity.toString()}");
    print("The cost is: ${cost.toString()}");

    try{
      var uuid = Uuid();
      String cartItemId = uuid.v4();
      List cart = _userModel.cart;
      Map cartItem ={
        "id": cartItemId,
        "title": product.title,
        "image": product.thumbnailUrl,
        "productId": product.productId,
        "price": product.price,
        "quantity": quantity,
        "size": size,
        "sellerId": product.sellerId,
        "totalShopSale" : product.price * quantity,
        "cost": cost,
      };

      CartItemModel item = CartItemModel.fromMap(cartItem);

      print("CART ITEMS ARE: ${cart.toString()}");
      _userServices.addToCart(userId: _user.uid, cartItem: item);

      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }

  }

  // change the total price when there are changes in each item
  changeCartTotalPrice(UserModel userModel) {
    userModel.totalCartPrice = 0;
    if(userModel.cart.isNotEmpty){
      userModel.cart.forEach((cartItem) {
        userModel.totalCartPrice = userModel.totalCartPrice + cartItem.cost;
      });
    }
  }

  // check if item has already been added to cart
  Future<bool> isItemAlreadyAdded(ProductModel product) async {
    return _userModel.cart
        .where((item) => item.productId == product.productId)
        .isNotEmpty;

  }

  Future<int> increaseQuantityIfItemIsAdded(ProductModel product, int quantity) async {
    if(await isItemAlreadyAdded(product)) {
      _userModel.cart.where((element) => element.quantity == quantity);
      quantity++;

    }
return quantity;
  }

  // decrease quantity in cart
  //TODO: correct this value
  Future<bool> decreaseQuantity(CartItemModel item) async {
    if(item.quantity == 1){
      _userServices.removeFromCart(userId: _user.uid, cartItem: item);
    }else {
      item.quantity--;
      _firestore.collection(usersCollection)
      .document(_user.uid)
      .updateData({
        "cart": FieldValue.arrayUnion([item.toMap])
      });


    }
    return true;
  }

  //method for getting total sales by the user
  getTotalSales() async {
    for(OrderModel order in orders){
      for(CartItemModel item in order.cart) {
        if(item.sellerId == user.uid) {
          _total_sales = _total_sales + item.totalShopSale;
          cartItems.add(item);
        }
      }
    }
      notifyListeners();
  }

  Future<bool> increaseQuantity(CartItemModel item) async{
    _userServices.removeFromCart(userId: _user.uid, cartItem: item);
    item.quantity++;
    _firestore.collection(usersCollection)
        .document(_user.uid)
        .updateData({
      "cart": FieldValue.arrayUnion([item.toMap()])
    });
    return true;
  }
  // check if seller is already in cart
  Future<bool> isSellerIdAlreadyInCart(ProductModel product) async {
    return _userModel.cart
        .where((element) => element.sellerId != product.sellerId)
        .isNotEmpty;
  }
 // function for getting the orders by a specific user
  getOrders()async {
    orders = await _orderServices.getUserOrders(userId: user.uid);
    print(orders.toString());
    notifyListeners();
  }
  //function for getting seller order
  getSellerOrders({String sellerId}) async {
    sellerOrders = await _orderServices.getSellerOrders(sellerId: sellerId);
    print(sellerOrders.toString());
    notifyListeners();
}

    //function for removing an item from the cart
    Future<bool> removeFromCart({CartItemModel cartItem}) async {
      print("THE PRODUCT IS: ${cartItem.toString()}");

      try {
        _userServices.removeFromCart(userId: _user.uid, cartItem: cartItem);
        return true;
      } catch (e) {
        print("THE ERROR ${e.toString()}");
        return false;
      }
    }

    //load addresses

    // load address by order
   loadAddressByOrder({String userId, addressId}) async {
    addressByOrders = await _userServices.getAddressesOfOrders(userId: userId, addressId: addressId);
    notifyListeners();
  }

  //load sellers from user model
  loadSellers() async {
    sellers = await _userServices.getSellers();
    notifyListeners();
  }



  //function to get add to favorites for a specific user
  Future<bool> addToFavorite({ProductModel product}) async{
    print("THE PRODUCT IS: ${product.toString()}");

    try{
      var uuid = Uuid();
      String favoriteItemId = uuid.v4();
      List favorite = _userModel.favorite;
      Map favoriteItem ={
        "favoriteId": favoriteItemId,
        "name": product.title,
        "image": product.thumbnailUrl[0],
        "id": product.productId,
        "price": product.price,
        "category": product.category,
        "description":product.longDescription,
        "sizes":product.sizes,
        "sellerId": product.sellerId,
        "shop": product.shop
      };

      print("THE FAVORITE ITEMS ARE: ${favorite.toString()}");
      _userServices.addToFavorite(userId: _user.uid, favoriteItem: favoriteItem);




      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }

  }

  //function for removing an item from the favorite
  Future<bool> removeFromFavorite({Map favoriteItem}) async {
    print("THE PRODUCT IS: ${favoriteItem.toString()}");

    try {
      _userServices.removeFromFavorite(userId: _user.uid, favoriteItem: favoriteItem);
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }
}