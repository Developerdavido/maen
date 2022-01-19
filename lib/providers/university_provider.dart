import 'package:flutter/material.dart';
import 'package:maen/helpers/university_services.dart';
import 'package:maen/models/university.dart';
import 'package:maen/providers/category_provider.dart';

class UniversityProvider with ChangeNotifier {
  UniversityServices _universityServices = UniversityServices();
  List<UniversityModel> universities = [];

  UniversityProvider.initialize(){
    loadUniversities();
  }

   loadUniversities() async {
    universities = await _universityServices.getUniversities();
    notifyListeners();
   }
}