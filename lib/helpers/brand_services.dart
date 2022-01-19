
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maen/models/brand.dart';
import 'package:maen/models/university.dart';
import 'package:uuid/uuid.dart';

class BrandServices{
  String collection = "brands";
  Firestore _firestore = Firestore.instance;

  void createBrand(Map<String, dynamic> data){
    var id = Uuid();
    String brandId = id.v1();
    _firestore.collection(collection).document(brandId).setData(data);
  }

  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) =>
      _firestore.collection(collection).where('brand', isEqualTo: suggestion).getDocuments()
          .then((snap) {
        return snap.documents;
      });

  Future<List<BrandModel>> getBrands() async =>
      _firestore.collection(collection).getDocuments().then((result) {
        List<BrandModel> brands = [];
        for(DocumentSnapshot brand in result.documents){
          brands.add(BrandModel.fromSnapshot(brand));
        }
        return brands;
      });

}