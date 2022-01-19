import 'package:flutter/cupertino.dart';
import 'package:maen/helpers/comment_services.dart';
import 'package:maen/models/comment.dart';

class CommentProvider with ChangeNotifier{

  List<CommentModel> comments = [];
  CommentServices _commentServices = CommentServices();

  CommentProvider.initialize(){
    loadComments();
  }

  Future loadComments ({String productId}) async {
    comments = await _commentServices.getComments(productId: productId);
    notifyListeners();

  }
}