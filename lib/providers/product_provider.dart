import 'package:flutter/material.dart';
import 'package:maen/helpers/product_services.dart';
import 'package:maen/models/product.dart';

class ProductProvider with ChangeNotifier{
  ProductServices _productServices = ProductServices();
  List<ProductModel> products = [];
  List<ProductModel> productsByCategory = [];
  List<ProductModel> productsBySeller = [];
  List<ProductModel> productsByUniversity = [];
  List<ProductModel> productsByShop = [];
  List<ProductModel> promoProducts = [];
  List<ProductModel> featuredProducts = [];
  List<ProductModel> newFeaturedProducts = [];
  List<ProductModel> promotedProducts = [];
  ProductModel _productModel;


  ProductProvider(){
    loadFeaturedProducts();
  }

  //initialise list of product searched inn string
  List<ProductModel> productsSearched = [];

  //getter for product
  ProductModel get productModel => _productModel;
 

  ProductProvider.initialize(){
    loadProducts();
    loadFeaturedProducts();
    loadProductsByCategory();
    loadPromoProducts();
    loadProductsByUniversity();
    loadProductsBySeller();

  }

  //function for loading product
  loadProducts() async{
    products = await _productServices.getProducts();
    notifyListeners();
  }

  //function for loading product by category
Future loadProductsByCategory({String categoryName}) async {
    productsByCategory = await _productServices.getProductsOfCategory(category: categoryName);
    notifyListeners();
}

//function for loading products by shops
Future loadProductsBySeller({String sellerId}) async {
    productsBySeller = await _productServices.getProductsBySeller(sellerId: sellerId);
    notifyListeners();
}

//function for loading products by shops
  Future loadProductsByUniversity({String university}) async {
    productsByUniversity = await _productServices.getProductsByUniversity(universityName: university);
    notifyListeners();
  }

//function for loading products by featured
 void loadFeaturedProducts() async {
    featuredProducts = await _productServices.getFeatured();
    notifyListeners();
}

  //function for loading products by promo
  loadPromoProducts() async {
    promoProducts = await _productServices.getPromos();
    notifyListeners();
  }

  //function to search product
Future search({String productName})async{
    productsSearched = await _productServices.searchProducts(productName: productName);
    print("THE NUMBER OF PRODUCTS DETECTED IS: ${productsSearched.length}");
    print("THE NUMBER OF PRODUCTS DETECTED IS: ${productsSearched.length}");
    print("THE NUMBER OF PRODUCTS DETECTED IS: ${productsSearched.length}");

}


}

