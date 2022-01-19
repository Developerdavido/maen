import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maen/helpers/category_services.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key key}) : super(key: key);

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {

  //Add category
  TextEditingController categoryName = TextEditingController();
  CategoryServices _categoryService = CategoryServices();
  File _categoryImage;
  GlobalKey<FormState> _categoryFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
              key: _categoryFormKey,
              child: SingleChildScrollView(
                child: isLoading ? CircularProgressIndicator() : Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 120,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: Colors.grey.withOpacity(0.5),
                                        width: 2.5
                                    ),
                                ),
                                onPressed: (){
                                  _selectCategoryImage(
                                      ImagePicker.pickImage(
                                          source: ImageSource.gallery
                                      )
                                  );
                                },
                                child: _displayCategoryChild(),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'enter a category name with 10 characters at maximum',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Material(
                        child: TextFormField(
                          controller: categoryName,
                          decoration: InputDecoration(hintText: 'Category name'),
                          validator: (value){
                            if(value.isEmpty){
                              return 'you must enter the category name';
                            }else if (value.length > 10){
                              return 'Category name cant have more than 20 characters';
                            }
                            return value;
                          },
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: red,
                      ),
                      child: Text('add category',
                      style: TextStyle(
                        color: white,
                      ),),
                      onPressed: (){
                        uploadCategory();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _selectCategoryImage(Future<File> pickImage) async {
    File tempImg = await pickImage;
    setState(() {
      return _categoryImage = tempImg;
    });
  }

  Widget _displayCategoryChild() {
    if(_categoryImage == null ){
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: Colors.grey,
        ),
      );
    }else {
      return Image.file(
        _categoryImage,
        fit: BoxFit.fill,
        width: double.infinity,
      );

    }
  }

  void uploadCategory() async {
    if(_categoryFormKey.currentState.validate()){
      setState(() {
        return isLoading = true;
      });
      if(_categoryImage != null) {
        String imageUrl1;

        final FirebaseStorage storage =  FirebaseStorage.instance;
        final String picture1 =
            "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
        StorageUploadTask task1 = storage.ref().child("categories").child(picture1).putFile(_categoryImage);

        StorageTaskSnapshot snapshot1 =
        await task1.onComplete.then((snapshot) => snapshot);

        task1.onComplete.then((snapshot3) async{
          imageUrl1 = await snapshot1.ref.getDownloadURL();
          _categoryService.createCategory({
            "name":categoryName.text,
            "image":imageUrl1,
          });
          _categoryFormKey.currentState.reset();
          setState(() {
            return isLoading = false;
          });
          clearControllers();
          Fluttertoast.showToast(msg: 'your category has successfully been uploaded');
        });
      }else {
        setState(() => isLoading = false);
      }
    }else{
      setState(() => isLoading = false);
    }
  }
  clearControllers(){
    categoryName.text = "";
  }
}
