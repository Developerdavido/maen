import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel{
  static const PRODUCT_ID = "productId";
  static const TITLE = "title";
  static const RATING = "rating";
  static const THUMBNAIL_URL = "thumbnailUrl";
  static const SELLER_ID = "sellerId";
  static const SHOP = "shop";
  static const LONG_DESCRIPTION = "longDescription";
  static const CATEGORY = "category";
  static const BRAND = "brand";
  static const UNIVERSITY = "university";
  static const FEATURED = "featured";
  static const PRICE = "price";
  static const RATES = "rates";
  static const PROMOS = "promos";
  static const USER_LIKES = "userLikes";
  static const PROMOTED = "promoted";
  static const SIZES = "sizes";
  static const STATUS = "status";
  static const PUBLISHED_DATE = "publishedDate";
  static const SHORT_INFO = "shortInfo";
  //static const COLORS = "colors";

  String _productId;
  String _title;
  String _shop;
  String _category;
  String _brand;
  String _university;
  String _longDescription;
  List _thumbnailUrl;
  List _sizes;
  String _rating;
  int _price;
  String _rates;
  bool _featured;
  bool _promos;
  String _shortInfo;
  Timestamp _publishedDate;
  String _status;
  String _sellerId;


  // public variable
bool liked = false;

//=================getters =======================

  String get shortInfo => _shortInfo;

  String get status => _status;

  Timestamp get publishedDate => _publishedDate;

  String get productId => _productId;

  String get title => _title;

  String get sellerId => _sellerId;

  String get shop => _shop;

  String get category => _category;

  String get brand => _brand;

  String get university => _university;

  String get longDescription => _longDescription;

  List get thumbnailUrl => _thumbnailUrl;

  List get sizes => _sizes;

  String get rating => _rating;

  int get price => _price;

  String get rates => _rates;

  bool get featured => _featured;

  bool get promos => _promos;





  ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    _productId = snapshot.data[PRODUCT_ID];
    _title = snapshot.data[TITLE];
    _thumbnailUrl = snapshot.data[THUMBNAIL_URL];
    _brand = snapshot.data[BRAND];
    _shop = snapshot.data[SHOP];
    _sellerId = snapshot.data[SELLER_ID];
    _featured = snapshot.data[FEATURED];
    _university = snapshot.data[UNIVERSITY];
    _longDescription = snapshot.data[LONG_DESCRIPTION];
    _category = snapshot.data[CATEGORY];
    _price = snapshot.data[PRICE];
    _rates = snapshot.data[RATES];
    _rating = snapshot.data[RATING];
    _sizes = snapshot.data[SIZES];
    _promos = snapshot.data[PROMOS];
    _shortInfo = snapshot.data[SHORT_INFO];
    _status = snapshot.data[STATUS];
    _publishedDate = snapshot.data[PUBLISHED_DATE];


  }




}