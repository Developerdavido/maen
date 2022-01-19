import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EcommerceApp {
  static const String appName = 'maen';

  static SharedPreferences sharedPreferences;
  static FirebaseUser user;
  static FirebaseAuth auth;
  static Firestore firestore;

  static String collectionUser = "users";
  static String collectionOrders = "orders";
  static String userCartList = 'cart';
  static String userFavoriteList = 'favorite';
  static String subCollectionAddress = 'address';

  static final String userName = 'name';
  static final String userEmail = 'email';
  static final String userPhotoUrl = 'photoUrl';
  static final String userUID = 'id';
  static final String userAvatarUrl = 'imageUrl';
  static final String userPhone = 'phone';
  static final String isSeller = 'isSeller';
  static final String isSellerVerified = 'isSellerVerified';
  static final String university = "university";

  //Order details for database
  static final String addressID = 'addressID';
  static final String totalAmount = 'totalAmount';
  static final String productID = 'productID';
  static final String paymentDetails = 'paymentDetails';
  static final String orderTime = 'orderTime';
  static final String isSuccess = 'isSuccess';
  static final String size = 'size';
  static final String quantity = 'quantity';
  static final String status = 'status';
  static final String phone = 'phone';
  static final String createdAt = 'createdAt';
  static final String cart = "cart";

  //New order details


  static final String adminUserId = 'adminId';

}