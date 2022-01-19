
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel{
  static const String ID = "id";
  static const String USER_NAME = "userName";
  static const String COMMENT = "comment";
  static const String PRODUCT_ID = "productId";

  String _id;
  String _userName;
  String _comment;
  String _productId;

  String get id => _id;

  String get userName => _userName;

  String get productId => _productId;

  String get comment => _comment;

  CommentModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id  = snapshot.data[ID];
    _userName = snapshot.data[USER_NAME];
    _comment = snapshot.data[COMMENT];
    _productId = snapshot.data[PRODUCT_ID];
  }
}