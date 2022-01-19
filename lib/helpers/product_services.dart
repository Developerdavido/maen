import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maen/models/product.dart';

class ProductServices{
  String collection = "products";
  Firestore _firestore = Firestore.instance;

  //getting document snapshots from the products
  Future<List<ProductModel>> getProducts() async =>
      _firestore.collection(collection).getDocuments().then((result){
        List<ProductModel> products = [];
        for (DocumentSnapshot product in result.documents){
          products.add(ProductModel.fromSnapshot(product));
        }
        return products;
      });
  // updating likes and dislikes on the user product collection
  void likeOrDislikeProduct({String id, List<String> userLikes}){
    _firestore.collection(collection).document(id).updateData({
      "userLikes" : userLikes
    });
  }
  //quering the database for getting products by sellers using string name
  Future<List<ProductModel>> getProductsBySeller({String sellerId}) async =>
      _firestore.collection(collection)
          .where("sellerId", isEqualTo: sellerId)
          .getDocuments()
          .then((result) {
        List<ProductModel> products = [];
        for (DocumentSnapshot product in result.documents) {
          products.add(ProductModel.fromSnapshot(product));
        }
        return products;
      });

  //quering the database for getting products by university using string name
  Future<List<ProductModel>> getProductsByUniversity({String universityName}) async =>
      _firestore.collection(collection)
          .where("university", isEqualTo: universityName)
          .getDocuments()
          .then((result) {
        List<ProductModel> products = [];
        for (DocumentSnapshot product in result.documents) {
          products.add(ProductModel.fromSnapshot(product));
        }
        return products;
      });

  // quering the product to get the category using the string category in products
  Future<List<ProductModel>> getProductsOfCategory({String category}) async =>
      _firestore
          .collection(collection)
          .where("category", isEqualTo: category)
          .getDocuments()
          .then((result) {
        List<ProductModel> products = [];
        for (DocumentSnapshot product in result.documents) {
          products.add(ProductModel.fromSnapshot(product));
        }
        return products;
      });

  //quering the database to give products when the featured or new deals is true
  Future<List<ProductModel>> getFeatured() async =>
   _firestore.collection(collection)
   .where('featured', isEqualTo: true)
   .getDocuments()
   .then((result){
    List<ProductModel> featuredProducts = [];
   for (DocumentSnapshot product in result.documents){
     featuredProducts.add(ProductModel.fromSnapshot(product));
   }
    return featuredProducts;
  });

  //quering the database to give products when the promos is true
  Future<List<ProductModel>> getPromos() async =>
      _firestore.collection(collection)
          .where('promo', isEqualTo: true)
          .getDocuments()
          .then((result){
        List<ProductModel> promos = [];
        for (DocumentSnapshot product in result.documents){
          promos.add(ProductModel.fromSnapshot(product));
        }
        return promos;
      });


// quering the product search the product using a single value string
  Future<List<ProductModel>> searchProducts({String productName}) {
    // code to convert the first character to uppercase
    String searchKey = productName[0].toUpperCase() + productName.substring(1);
    return _firestore
        .collection(collection)
        .orderBy("name")
        .startAt([searchKey])
        .endAt([searchKey + '\uf8ff'])
        .getDocuments()
        .then((result) {
      List<ProductModel> products = [];
      for (DocumentSnapshot product in result.documents) {
        products.add(ProductModel.fromSnapshot(product));
      }
      return products;
    });
  }

}