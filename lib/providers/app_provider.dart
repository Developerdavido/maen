import 'package:flutter/material.dart';

//enum to do the searches

enum SearchBy{PRODUCTS, CATEGORIES}

class AppProvider with ChangeNotifier{
  bool isLoading = false;
  SearchBy search = SearchBy.PRODUCTS;
  String filterBy = "Products";
  int totalPrice = 0;
  int priceSum = 0;
  int quantitySum = 0;

  void changeLoading(){
    isLoading = !isLoading;
    notifyListeners();
  }

  //method for searching but searching by products is the default search

void changeSearchBy({SearchBy newSearchBy}){
    search =  newSearchBy;
    if(newSearchBy == SearchBy.PRODUCTS){
      filterBy = "Products";
    }else{
      filterBy = "Categories";
    }
    notifyListeners();
}

addPrice({int newPrice}){
    priceSum += newPrice;
    notifyListeners();
}

addQuantity({int newQuantity}){
    quantitySum += newQuantity;
    notifyListeners();
}

getTotalPrice(){
    print("THE TOTAL SUM IS : $priceSum");
    print("THE QUANTITY SUM IS : $quantitySum");

    totalPrice = priceSum * quantitySum;
    notifyListeners();
}
}