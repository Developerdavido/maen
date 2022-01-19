
import 'package:maen/models/cartitem.dart';

class FavoriteItemModel{
  static const FAVORITE_ID = "FavoriteId";
  static const NAME = "name";
  static const IMAGE = "image";
  static const ID = "id";
  static const SIZES = "sizes";
  static const PRICE = "price";
  static const DESCRIPTION = "description";
  static const CATEGORY = "category";
  static const SHOP_ID = "shopId";
  static const SHOP = "shop";

  String _id;
  String _favoriteId;
  String _name;
  String _shopId;
  String _shop;
  String _category;
  String _description;
  String _image;
  int _price;
  List _sizes;

  //getters

  String get id => _id;

  String get favoriteId => _favoriteId;

  List get sizes => _sizes;

  int get price => _price;

  String get image => _image;

  String get description => _description;

  String get category => _category;

  String get shop => _shop;

  String get shopId => _shopId;

  String get name => _name;

//public variable

FavoriteItemModel.fromMap(Map data){
  _id = data[ID];
  _favoriteId = data[FAVORITE_ID];
  _name = data[NAME];
  _image = data[IMAGE];
  _sizes = data[SIZES];
  _shop = data[SHOP];
  _shopId = data[SHOP_ID];
  _description = data[DESCRIPTION];
  _category = data[CATEGORY];
  _price = data[PRICE];
}

Map toMap() => {
  ID: _id,
  IMAGE: _image,
  FAVORITE_ID: _favoriteId,
  NAME: _name,
  SIZES: _sizes,
  SHOP: _shop,
  SHOP_ID: _shopId,
  DESCRIPTION: _description,
  CATEGORY: _category,
  PRICE: _price
};

}
