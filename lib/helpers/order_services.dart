import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maen/models/address.dart';
import 'package:maen/models/cartitem.dart';
import 'package:maen/models/order.dart';
import 'package:maen/utils/config.dart';


class OrderServices {
  String collection = "orders";
  String adminCollection = "adminOrders";
  Firestore _fireStore = Firestore.instance;
  FirebaseUser _user;

  void createOrder(
      {String userId, String id, String description, String status, String address, List<
          CartItemModel> cart, int totalPrice, String phone }) {
    List<Map> convertedCart = [];
    List<String> sellerIds = [];

    for (CartItemModel item in cart) {
      convertedCart.add(item.toMap());
      sellerIds.add(item.sellerId);
    }

    _fireStore.collection(collection).document(id).setData({
      "userId": userId,
      "id": id,
      "cart": convertedCart,
      "total": totalPrice,
      "sellerIds" : sellerIds,
      "createdAt": DateTime
          .now()
          .millisecondsSinceEpoch,
      "description": description,
      "status": status,
      "address": address,
      "phone": phone
    });
  }

  Future<List<OrderModel>> getUserOrders({String userId}) async =>
      _fireStore
          .collection(collection)
          .where("userId", isEqualTo: userId)
          .getDocuments()
          .then((result) {
        List<OrderModel> orders = [];
        for (DocumentSnapshot order in result.documents) {
          orders.add(OrderModel.fromSnapshot(order));
        }
        return orders;
      });

  //get sellerOrders
  Future<List<OrderModel>> getSellerOrders({String sellerId}) async =>
      _fireStore
      .collection(collection)
      .where("sellerIds", arrayContains: sellerId)
      .getDocuments()
      .then((result) {
        List<OrderModel> orders = [];
        for(DocumentSnapshot order in result.documents) {
          orders.add(OrderModel.fromSnapshot(order));
        }
        return orders;
      });

  Map<String, dynamic> orderAddress(String id, String name, String phoneNumber, String streetAddress, String city, String roomNumber) {
    return {
      "address" : FieldValue.arrayUnion([
        {
          "id" : id,
          "name" : name,
          "phoneNumber" : phoneNumber,
          "streetAddress" : streetAddress,
          "city" : city,
          "roomNumber" : roomNumber,
        }
      ])
    };
  }



}