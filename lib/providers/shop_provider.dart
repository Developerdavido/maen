import 'package:flutter/material.dart';
import 'package:maen/helpers/shop_services.dart';
import 'package:maen/models/shops.dart';


class ShopProvider with ChangeNotifier{
  ShopServices _shopServices = ShopServices();
  List<ShopModel> shops = [];
  List<ShopModel> searchedShops = [];

  ShopModel shop;

  ShopProvider.initialize(){
    loadShops();
  }

  loadShops() async {
    shops = await _shopServices.getShops();
    notifyListeners();
  }

  //load single shops
  loadSingleShop({String shopName}) async{
    shop = await _shopServices.getShopsByName(name: shopName);
    notifyListeners();
  }
  // load search shops
Future search({String name}) async{
    searchedShops = await _shopServices.searchShop(shopName: name);
    print("SHOPS ARE: ${searchedShops.length}");
    notifyListeners();
}
}