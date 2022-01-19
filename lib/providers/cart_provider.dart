import 'package:flutter/material.dart';
import 'package:maen/helpers/user_services.dart';
import 'package:maen/models/users.dart';
import 'package:maen/providers/user_provider.dart';

class CartProvider with ChangeNotifier{
  UserModel _userModel;
  UserServices _userServices = UserServices();

}