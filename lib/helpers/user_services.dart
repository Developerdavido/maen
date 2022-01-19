import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maen/models/address.dart';
import 'package:maen/models/cart.dart';
import 'package:maen/models/cartitem.dart';
import 'package:maen/models/users.dart';

class UserServices{
  String collection = "users";
  Firestore _firestore = Firestore.instance;

  //access product database
  final CollectionReference _productsRef =
      Firestore.instance.collection("Products");

  //=============create user =================
  void createUser(Map<String, dynamic> values){
    String id = values["id"];
    _firestore.collection(collection).document(id).setData(values);
  }

  void createFavorites(Map<String, dynamic> values) {
    _firestore.collection(collection).document('userId');
  }
  //================ update user data ==================
  void updateUserData(Map<String, dynamic> values){
    _firestore.collection(collection).document(values['id']).updateData(values);
  }
  //================= get user by id =============
  Future<UserModel> getUserById(String id) => _firestore.collection(collection).document(id).get().then((doc){
    return UserModel.fromSnapshot(doc);
  });


  //TODO ============ create cart methods ===============

  void addToCart({String userId, CartItemModel cartItem}) {
    print("THE USER ID IS: $userId");
    print("cart items are: ${cartItem.toString()}");
    _firestore.collection(collection).document(userId).updateData({
      "cart": FieldValue.arrayUnion([cartItem.toMap()])
    });
  }

  //TODO: *****************new get data from cart code base*************************
  Future<List<CartItemModel>> getCartData() async =>
      _firestore.collection(collection).document("userId").collection("cart").getDocuments().then((result){
        List<CartItemModel> carts = [];
        for (DocumentSnapshot cart in result.documents){
          carts.add(CartItemModel.fromSnapShot(cart));
        }
        return carts;
      });

  //TODO: **************** get data from addresses code base ******************
  Future<List<AddressModel>> getAddress(String userId) async =>
      _firestore.collection(collection).document(userId)
      .collection("address")
      .getDocuments()
      .then((result) {
        List<AddressModel> addresses = [];
        for (DocumentSnapshot address in result.documents){
          addresses.add(AddressModel.fromSnapshot(address));
        }
        return addresses;
      });
  //TODO: ************ get data from address based on the id in the ordermodel ***********
  Future<List<AddressModel>> getAddressesOfOrders({String addressId, userId}) async =>
      _firestore
          .collection(collection)
          .document(userId)
          .collection("address")
          .where("id", isEqualTo: addressId)
          .getDocuments()
          .then((result) {
        List<AddressModel> addresses = [];
        for (DocumentSnapshot address in result.documents) {
          addresses.add(AddressModel.fromSnapshot(address));
        }
        return addresses;
      });

  // get sellers from user model
  Future<List<UserModel>> getSellers() async =>
      _firestore.collection(collection)
      .where("isSellerVerified", isEqualTo: true)
      .getDocuments()
      .then((result) {
        List<UserModel> sellers = [];
        for (DocumentSnapshot seller in result.documents) {
          sellers.add(UserModel.fromSnapshot(seller));
        }
        return sellers;
      });


  void removeFromCart({String userId, CartItemModel cartItem}){
    print("THE USER ID IS: $userId");
    print("cart items are: ${cartItem.toString()}");
    _firestore.collection(collection).document(userId).updateData({
      "cart": FieldValue.arrayRemove([cartItem.toMap()])
    });
  }

  //TODO ============= create favorite methods ================
    void addToFavorite({String userId, Map favoriteItem}){
      print("THE USER ID IS: $userId");
      print("favorite items are: ${favoriteItem.toString()}");
      _firestore.collection(collection).document(userId).updateData({
        "favorite": FieldValue.arrayUnion([favoriteItem])
      });
    }


    void removeFromFavorite({String userId, Map favoriteItem}) {
      print("THE USER ID IS: $userId");
      print("favorite items are: ${favoriteItem.toString()}");
      _firestore.collection(collection).document(userId).updateData({
        "favorite": FieldValue.arrayRemove([favoriteItem])
      });
    }

}