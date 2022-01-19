import 'package:flutter/cupertino.dart';
import 'package:maen/helpers/seller_services.dart';
import 'package:maen/models/seller.dart';

class SellerProvider with ChangeNotifier{
  SellerServices _sellerServices = SellerServices();
  List<SellerModel> sellers = [];
  List<SellerModel> searchedSellers = [];

  SellerModel seller;

  SellerProvider.initialize(){
    loadSellers();
  }

   loadSellers() async {
    sellers = await _sellerServices.getSellers();
    notifyListeners();
   }

   loadSingleSeller({String sellerId}) async {
    seller = await _sellerServices.getSellersById(id: sellerId);
    notifyListeners();
   }

  Future searchSellers({String name})async{
    searchedSellers = await _sellerServices.searchSeller(sellerName: name);
    print("SELLERS ARE: ${searchedSellers.length}");
    notifyListeners();
  }
}