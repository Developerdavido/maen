import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maen/Admin/adminShiftOrder.dart';
import 'package:maen/helpers/category_services.dart';
import 'package:maen/main.dart';
import 'package:maen/models/category.dart';
import 'package:maen/utils/config.dart';
import 'package:maen/widgets/constants.dart';
import 'package:maen/widgets/custom_btn.dart';
import 'package:maen/widgets/loadingWidget.dart';


class UploadProduct extends StatefulWidget {
  @override
  _UploadProductState createState() => _UploadProductState();
}

class _UploadProductState extends State<UploadProduct> {
  CategoryServices _categoryServices = CategoryServices();
  GlobalKey<FormState> _productFormKey = GlobalKey<FormState>();
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<CategoryModel> category = <CategoryModel>[];
  File file, fileTwo, fileThree ;
  List<DropdownMenuItem<String>> categoriesDropDown = <DropdownMenuItem<String>>[];
  String _currentCategory;
  List<String> selectedSizes = <String>[];
  bool deals = false;
  bool featured = false;
  bool popular = false;
  bool promos = false;
  TextEditingController _descriptionTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _shortInfoTextEditingController = TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategories();
  }

  List<DropdownMenuItem<String>> getCategoriesDropdown(){
    List<DropdownMenuItem<String>> items = new List();
    for(int i = 0; i<category.length; i++){
      setState(() {
        items.insert(0, DropdownMenuItem(child: Text(category[i].name),
          value: category[i].name,));
      });
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return  displayAdminHomeScreen();
  }

  displayAdminHomeScreen() {
    return  Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
        ),
        title: Text("Add a new Product", style: Constants.regularWhiteHeading,),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.border_color,
            color: Colors.white,
          ),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
            Navigator.pushReplacement(context, route);
          },
        ),
        actions: [
          FlatButton(
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => SplashScreen());
                Navigator.pushReplacement(context, route);
              },
              child: Text(
                "Logout",
                style: Constants.regularWhiteText,
              ))
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.white,
                  blurRadius: 4,
                  offset: Offset(1.0, 1.0)
              )
            ]
        ),

        child: Form(
          key: _productFormKey,
          child: SingleChildScrollView(
            child: isLoading ? Loading() : Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 120,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 2.5
                                  )
                                ),
                                onPressed: (){
                                  _selectProductImage(
                                      ImagePicker.pickImage(
                                          source: ImageSource.gallery), 1);
                                },
                                child: _displayProductChild(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 120,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: Colors.grey.withOpacity(0.5),
                                        width: 2.5
                                    )
                                ),
                                onPressed: (){
                                  _selectProductImage(
                                      ImagePicker.pickImage(
                                          source: ImageSource.gallery), 2
                                  );
                                },
                                child: _displayProductChild2(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 120,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: Colors.grey.withOpacity(0.5),
                                        width: 2.5
                                    )
                                ),
                                onPressed: (){
                                  _selectProductImage(
                                      ImagePicker.pickImage(
                                          source: ImageSource.gallery), 3
                                  );
                                },
                                child: _displayProductChild3(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text('Available sizes for shirts and boxers', style: Constants.regularHeading,),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                            value: selectedSizes.contains('XS'),
                            onChanged: (value) => changeSelectedSize('XS')),
                        Text('XS'),
                        Checkbox(
                            value: selectedSizes.contains('S'),
                            onChanged: (value) => changeSelectedSize('S')),
                        Text('S'),
                        Checkbox(
                            value: selectedSizes.contains('M'),
                            onChanged: (value) => changeSelectedSize('M')),
                        Text('M'),
                        Checkbox(
                            value: selectedSizes.contains('L'),
                            onChanged: (value) => changeSelectedSize('L')),
                        Text('L'),
                        Checkbox(
                            value: selectedSizes.contains('XL'),
                            onChanged: (value) => changeSelectedSize('XL')),
                        Text('XL'),
                        Checkbox(
                            value: selectedSizes.contains('XXL'),
                            onChanged: (value) => changeSelectedSize('XXL')),
                        Text('XXL'),
                      ],
                    ),
                  ),

                  Text('Available sizes for shoes', style: Constants.regularHeading,),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Checkbox(
                            value: selectedSizes.contains('38'),
                            onChanged: (value) => changeSelectedSize('38')),
                        Text('38'),
                        Checkbox(
                            value: selectedSizes.contains('39'),
                            onChanged: (value) => changeSelectedSize('39')),
                        Text('39'),
                        Checkbox(
                            value: selectedSizes.contains('40'),
                            onChanged: (value) => changeSelectedSize('40')),
                        Text('40'),
                        Checkbox(
                            value: selectedSizes.contains('41'),
                            onChanged: (value) => changeSelectedSize('41')),
                        Text('41'),
                        Checkbox(
                            value: selectedSizes.contains('42'),
                            onChanged: (value) => changeSelectedSize('42')),
                        Text('42'),
                        Checkbox(
                            value: selectedSizes.contains('43'),
                            onChanged: (value) => changeSelectedSize('43')),
                        Text('43'),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Checkbox(
                            value: selectedSizes.contains('44'),
                            onChanged: (value) => changeSelectedSize('44')),
                        Text('44'),
                        Checkbox(
                            value: selectedSizes.contains('45'),
                            onChanged: (value) => changeSelectedSize('45')),
                        Text('45'),
                        Checkbox(
                            value: selectedSizes.contains('46'),
                            onChanged: (value) => changeSelectedSize('46')),
                        Text('46'),
                        Checkbox(
                            value: selectedSizes.contains('47'),
                            onChanged: (value) => changeSelectedSize('47')),
                        Text('47'),
                        Checkbox(
                            value: selectedSizes.contains('48'),
                            onChanged: (value) => changeSelectedSize('48')),
                        Text('48'),
                      ],
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('Deals'),
                          SizedBox(width: 10,),
                          Switch(value: deals, onChanged: (value){
                            setState(() {
                              deals = value;
                            });
                          }),
                        ],
                      ),

                      Row(
                        children: <Widget>[
                          Text('Featured'),
                          SizedBox(width: 10,),
                          Switch(value: featured, onChanged: (value){
                            setState(() {
                              featured = value;
                            });
                          }),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('Promos'),
                          SizedBox(width: 10,),
                          Switch(value: promos, onChanged: (value){
                            setState(() {
                              promos = value;
                            });
                          }),
                        ],
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'enter a product name with 20 characters at maximum',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: _titleTextEditingController,
                      decoration: InputDecoration(hintText: 'Product name'),
                      validator: (value){
                        if(value.isEmpty){
                          return 'you must enter the product name';
                        }else if (value.length > 20){
                          return 'Product name cant have more than 20 characters';
                        }
                        return value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: _shortInfoTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Short Info',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'You must enter a short info for product';
                        }
                        return value;
                      },
                    ),
                  ),
                  //select category
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Category: ',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      DropdownButton(
                        items: categoriesDropDown,
                        onChanged: changeSelectedCategory,
                        value: _currentCategory,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: _descriptionTextEditingController,
                      keyboardType: TextInputType.multiline,
                      maxLength: 150,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Description',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'You must enter the product name';
                        }
                        return value;
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: _priceTextEditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Price',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'You must enter the product price';
                        }
                        return value;
                      },
                    ),
                  ),
                  CustomBtn(
                    text: 'add product',
                    onPressed: uploadProduct,
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }


  _getCategories() async{
    List<CategoryModel> data = await _categoryServices.getCategories();
    print(data.length);
    setState(() {
      category = data;
      categoriesDropDown = getCategoriesDropdown();
      _currentCategory = category[0].name;
    });
  }

  void _selectProductImage(Future<File> pickImage, int imageNumber) async {
    File tempImg = await pickImage;
    switch(imageNumber) {
      case 1: setState(() {
        file = tempImg;
      });
      break;
      case 2: setState(() {
        fileTwo = tempImg;
      });
      break;
      case 3: setState(() {
        fileThree = tempImg;
      });
      break;
    }
  }

  Widget _displayProductChild() {
    if (file == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: Colors.grey,
        ),
      );
    } else {
      return Image.file(
        file,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }


  Widget _displayProductChild2() {

    if(fileTwo == null ){
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: Colors.grey,
        ),
      );
    }else {
      return Image.file(
        fileTwo,
        fit: BoxFit.fill,
        width: double.infinity,
      );

    }
  }

  Widget _displayProductChild3() {

    if(fileThree == null ){
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: Colors.grey,
        ),
      );
    }else {
      return Image.file(
        fileThree,
        fit: BoxFit.fill,
        width: double.infinity,
      );

    }
  }

  changeSelectedSize(String size) {
    if(selectedSizes.contains(size)){
      setState(() {
        selectedSizes.remove(size);
      });
    }else {
      setState(() {
        selectedSizes.add(size);
      });
    }
  }

  void uploadProduct() async{

    setState(() {
      isLoading = true;

    });

    String imageDownloadUrl1 = await uploadItemImageOne(file);
    String imageDownloadUrl2 = await uploadItemImageTwo(fileTwo);
    String imageDownloadUrl3 = await uploadItemImageThree(fileThree);

    List<String> itemImages = [imageDownloadUrl1, imageDownloadUrl2, imageDownloadUrl3];
    saveItemInfo(itemImages);

    setState(() {
      isLoading = false;
    });
  }

  void changeSelectedCategory(String selectedCategory) {
    setState(() => _currentCategory = selectedCategory);
  }

  Future<String> uploadItemImageOne(File file) async {
    final StorageReference storageReference = FirebaseStorage.instance.ref().child("items");
    StorageUploadTask uploadTask = storageReference.child("product_$productId.jpg").putFile(file);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadItemImageTwo(File fileTwo) async {
    final StorageReference storageReference = FirebaseStorage.instance.ref().child("items");
    StorageUploadTask uploadTask = storageReference.child("productTwo_$productId.jpg").putFile(fileTwo);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;

  }

  Future<String>uploadItemImageThree(File fileThree) async{
    final StorageReference storageReference = FirebaseStorage.instance.ref().child("items");
    StorageUploadTask uploadTask = storageReference.child("productThree_$productId.jpg").putFile(fileThree);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;

  }

  void saveItemInfo(List<String> itemImages) {
    final itemsRef = Firestore.instance.collection("products");
    itemsRef.document(productId).setData({
      "shortInfo" : _shortInfoTextEditingController.text.trim(),
      "longDescription" : _descriptionTextEditingController.text.trim(),
      "price" : int.parse(_priceTextEditingController.text),
      "publishedDate" : DateTime.now(),
      "status" : "available",
      "thumbnailUrl" : itemImages,
      "title" : _titleTextEditingController.text.trim(),
      "productId" : productId,
      "sizes" : selectedSizes,
      "deals" : deals,
      "popular": popular,
      "promos": promos,
      "featured" : featured,
      "category" : _currentCategory,
      "adminId": EcommerceApp.sharedPreferences.getString(EcommerceApp.adminUserId),
    });

    _productFormKey.currentState.reset();
    setState(() {
      isLoading = false;
      file = null;
      fileTwo = null;
      fileThree = null;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _priceTextEditingController.clear();
    });
    Fluttertoast.showToast(msg: "your product has successfully been uploaded");
  }

}
