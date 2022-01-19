import 'package:flutter/material.dart';
import 'package:maen/helpers/category_services.dart';
import 'package:maen/models/category.dart';

class CategoryProvider with ChangeNotifier{
  CategoryServices _categoryServices = CategoryServices();
  List<CategoryModel> categories = [];
  List<CategoryModel> searchedCategories = [];

  CategoryModel category;

  CategoryProvider.initialize(){
    loadCategories();
  }

  loadCategories()async {
    categories = await _categoryServices.getCategories();
    notifyListeners();
  }

  loadSingleCategoryName() async {

  }

  //load single shops
  loadSingleCategory({String categoryName}) async{
     category = await _categoryServices.getCategoriesByName(name: categoryName);
    notifyListeners();
  }
  // load search shops
  Future search({String name}) async{
    searchedCategories = await _categoryServices.searchCategories(categoryName: name);
    print("SHOPS ARE: ${searchedCategories.length}");
    notifyListeners();
  }
}