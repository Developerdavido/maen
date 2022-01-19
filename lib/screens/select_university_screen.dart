import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maen/helpers/university_services.dart';
import 'package:maen/models/university.dart';
import 'package:maen/providers/product_provider.dart';
import 'package:maen/providers/user_provider.dart';
import 'package:maen/screens/homepage.dart';
import 'package:maen/screens/store_home.dart';
import 'package:maen/utils/common.dart';
import 'package:provider/provider.dart';

class SelectUniversity extends StatefulWidget {
  const SelectUniversity({Key key}) : super(key: key);

  @override
  _SelectUniversityState createState() => _SelectUniversityState();
}

class _SelectUniversityState extends State<SelectUniversity> {

  //university variables
  UniversityServices _universityServices = UniversityServices();
  List<DocumentSnapshot> universities = <DocumentSnapshot>[];
  List<UniversityModel> university = <UniversityModel>[];
  List<DropdownMenuItem<String>> universitiesDropDown = <DropdownMenuItem<String>>[];
  String _currentUniversity;


  // get list of universities in dropdown list
  List<DropdownMenuItem<String>> getUniversitiesDropdown(){
    List<DropdownMenuItem<String>> items = [];
    for(int i = 0; i<university.length; i++){
      setState(() {
        items.insert(0, DropdownMenuItem(child: Text(university[i].name),
          value: university[i].name,));
      });
    }
    return items;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUniversities();
  }

  //colours
  Color favColor = Color(0xFFDEDEDE);
  Color orange = Color(0xFFFF4C00);
  Color ash = Color(0xFFECF1F7);
  Color blue = Color(0xFF0007A7);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ash,
        ),
        child: Column(
          children: [
            SizedBox(height: height * 0.1,),
            Text(
              "Select the university you are located",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Material(
              type: MaterialType.transparency,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: DropdownButton(
                isExpanded: true,
                items: universitiesDropDown,
                onChanged: changeSelectedUniversity,
                value: _currentUniversity,
              ),
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: ()async{
            productProvider.loadProducts();
            productProvider.loadFeaturedProducts();
            userProvider.loadSellers();
            await productProvider.loadProductsByUniversity(university: _currentUniversity);
            changeScreenReplacement(context, StoreHome());
          },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
          label: Text("Get shopping"),
        backgroundColor: blue,
      ),
    );
  }
  _getUniversities() async{
    List<UniversityModel> data = await _universityServices.getUniversities();
    print(data.length);
    setState(() {
      university = data;
      universitiesDropDown = getUniversitiesDropdown();
      _currentUniversity = university[0].name;
    });
  }

  // change selected university in dropdown
  void changeSelectedUniversity(String selectedUniversity) {
    setState(() => _currentUniversity = selectedUniversity);
  }
}
