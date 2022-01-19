import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maen/models/seller.dart';

class SellerServices {
  String collection = "sellers";
  Firestore _firestore = Firestore.instance;

  Future<List<SellerModel>> getSellers() async =>
      _firestore.collection(collection).getDocuments().then((result) {
        List<SellerModel> sellers = [];
        for(DocumentSnapshot seller in result.documents){
          sellers.add(SellerModel.fromSnapshot(seller));
        }
        return sellers;
      });

  Future<SellerModel> getSellersById({String id}) => _firestore.collection(collection).document(id.toString()).get().then((doc){
    return SellerModel.fromSnapshot(doc);
  });

  Future<List<SellerModel>> searchSeller({String sellerName}) {
    // code to convert the first character to uppercase
    String searchKey = sellerName[0].toUpperCase() + sellerName.substring(1);
    return _firestore
        .collection(collection)
        .orderBy("name")
        .startAt([searchKey])
        .endAt([searchKey + '\uf8ff'])
        .getDocuments()
        .then((result) {
      List<SellerModel> sellers = [];
      for (DocumentSnapshot product in result.documents) {
        sellers.add(SellerModel.fromSnapshot(product));
      }
      return sellers;
    });
  }
}