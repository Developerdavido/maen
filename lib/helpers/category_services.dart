import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maen/models/category.dart';
import 'package:uuid/uuid.dart';

class CategoryServices{
  String collection = "categories";
  Firestore _firestore = Firestore.instance;

  void createCategory(Map<String, dynamic> data){
    var id = Uuid();
    String categoryId = id.v1();

    _firestore.collection(collection).document(categoryId).setData(data);
  }

  Future<List<CategoryModel>> getCategories() async =>
      _firestore.collection(collection).getDocuments().then((result) {
        List<CategoryModel> categories = [];
        for(DocumentSnapshot category in result.documents){
          categories.add(CategoryModel.fromSnapshot(category));
        }
        return categories;
      });

  Future<CategoryModel> getCategoriesByName({String name}) =>
      _firestore.collection(collection).document(name.toString()).get().then((doc){
        return CategoryModel.fromSnapshot(doc);
      });

  Future<List<DocumentSnapshot>> getSuggestions(String suggestion)  =>
      _firestore.collection(collection).where('category', isEqualTo: suggestion).getDocuments().then((snap){
        return snap.documents;
      });

  Future<List<CategoryModel>> searchCategories({String categoryName}) {
    // code to convert the first character to uppercase
    String searchKey = categoryName[0].toUpperCase() + categoryName.substring(1);
    return _firestore
        .collection(collection)
        .orderBy("name")
        .startAt([searchKey])
        .endAt([searchKey + '\uf8ff'])
        .getDocuments()
        .then((result) {
      List<CategoryModel> shops = [];
      for (DocumentSnapshot product in result.documents) {
        shops.add(CategoryModel.fromSnapshot(product));
      }
      return shops;
    });
  }
}