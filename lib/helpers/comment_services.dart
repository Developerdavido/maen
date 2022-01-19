import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maen/models/comment.dart';
import 'package:maen/utils/config.dart';

class CommentServices{
  String collection = "commments";
  Firestore _firestore = Firestore.instance;


  void createComment({String id, String comment, String userName, String productId}){

    _firestore.collection(comment).document(id).setData({
      "id" : id,
      "comment" : comment,
      "userName" : userName,
      "productId" : productId,
    });
  }

  Future<List<CommentModel>> getComments({String productId}) async =>
      _firestore.collection(collection).where("productId", isEqualTo: productId)
      .getDocuments().then((result) {
        List<CommentModel> comments = [];
        for(DocumentSnapshot comment in result.documents) {
          comments.add(CommentModel.fromSnapshot(comment));
        }
        return comments;
      });
}