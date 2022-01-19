
import 'package:flutter/cupertino.dart';
import 'package:maen/helpers/brand_services.dart';
import 'package:maen/models/brand.dart';

class BrandProvider with ChangeNotifier{
  BrandServices _brandServices = BrandServices();
  List<BrandModel> brands = [];

  BrandProvider.initialize(){
    loadBrands();
  }

  loadBrands() async {
    brands = await _brandServices.getBrands();
    notifyListeners();
  }
}