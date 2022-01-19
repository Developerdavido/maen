
import 'package:cloud_firestore/cloud_firestore.dart';

class  SellerModel {
  static const ID = "id";
  static const NAME = "name";
  static const RATING = "rating";
  static const RATES = "rates";
  static const USER_LIKES = "likes";
  static const IMAGE = "image";
  static const PHONE = "phone";
  static const UNIVERSITY_NAME = "universityName";

  String _id;
  String _name;
  String _image;
  List<String> _userLikes;
  double _rating;
  int _rates;
  String _universityName;
  String _phone;

  //getters

  String get id => _id;

  String get name => _name;

  String get phone => _phone;

  String get universityName => _universityName;

  int get rates => _rates;

  double get rating => _rating;

  List<String> get userLikes => _userLikes;

  String get image => _image;

  // public variable

  bool liked = false;

  SellerModel.fromSnapshot(DocumentSnapshot snapshot){
    _id = snapshot.data[ID];
    _name = snapshot.data[NAME];
    _image = snapshot.data[IMAGE];
    _universityName =snapshot.data[UNIVERSITY_NAME];
    _phone = snapshot.data[PHONE];
    _rating = snapshot.data[RATING];
    _rates = snapshot.data[RATES];
  }


}