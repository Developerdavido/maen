import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maen/DialogBox/errorDialog.dart';
import 'package:maen/DialogBox/loadingDialog.dart';
import 'package:maen/helpers/university_services.dart';
import 'package:maen/models/university.dart';
import 'package:maen/providers/user_provider.dart';
import 'package:maen/screens/homepage.dart';
import 'package:maen/screens/navigation.dart';
import 'package:maen/screens/navigation_controller.dart';
import 'package:maen/screens/select_university_screen.dart';
import 'package:maen/theme/theme.dart';
import 'package:maen/utils/config.dart';
import 'package:maen/widgets/constants.dart';
import 'package:maen/widgets/custom_btn.dart';
import 'package:maen/widgets/custom_input.dart';
import 'package:provider/provider.dart';

class RegisterAuth extends StatefulWidget {
  @override
  _RegisterAuthState createState() => _RegisterAuthState();
}

class _RegisterAuthState extends State<RegisterAuth> {
  //loading formState
  bool _registerFormLoading = false;

  final TextEditingController _nameTextEditingController = TextEditingController();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _cPasswordTextEditingController = TextEditingController();
  final TextEditingController _phoneTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSeller = false;
  bool isVerified = false;
  String userImageUrl = "";
  File _imageFile;

  //university variables
  UniversityServices _universityServices = UniversityServices();
  List<DocumentSnapshot> universities = <DocumentSnapshot>[];
  List<UniversityModel> university = <UniversityModel>[];
  List<DropdownMenuItem<String>> universitiesDropdown = <DropdownMenuItem<String>>[];
  String _currentUniversity;

  //Focus node for input fields
  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;
  FocusNode _cPasswordFocusNode;
  FocusNode _phoneFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _cPasswordFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _getUniversities();
    super.initState();
  }

  // get the list of universities in the dropdownlist
  List<DropdownMenuItem<String>> getUniversitiesDropdown() {
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
  void dispose() {
    // TODO: implement dispose
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _cPasswordFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  Color blue = Color(0xFF0007A7);

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width, _screenHeight = MediaQuery.of(context).size.height;
    final userProvider = Provider.of<UserProvider>(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 24.0),
                child: Container(
                  padding: EdgeInsets.only(
                    top: 24.0,
                  ),
                  child: Text(
                    "Create Account",
                    textAlign: TextAlign.left,
                    style: MaenTheme.lightTextTheme.headline1,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Center(
                child: InkWell(
                  onTap: _selectAndPickImage,

                  child: CircleAvatar(
                    radius: _screenWidth * 0.15,
                    backgroundColor: Colors.white10,
                    backgroundImage: _imageFile == null ? null : FileImage(_imageFile),
                    child: _imageFile == null ? Image.asset(
                      "images/add_image.png",
                      height: 200.0,
                      width: 200.0,
                    )
                        : null,

                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      CustomInput(
                        controller: _nameTextEditingController,
                        data: Icons.person,
                        hintText: "Name",
                        isPasswordField: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        validator: (value){
                          if(value.isEmpty){
                            return 'You must enter your name';
                          }
                          return value;
                        },
                        onSubmitted: (value) {
                          _emailFocusNode.requestFocus();
                        },
                      ),
                      CustomInput(
                        controller: _emailTextEditingController,
                        data: Icons.email,
                        hintText: "Email",
                        isPasswordField: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value){
                          if(value.isEmpty){
                            Pattern pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regex = new RegExp(pattern);
                            if(!regex.hasMatch(value))
                              return 'Please make sure your email address is valid';
                            else
                              return null;
                          }
                          return value;
                        },
                        onSubmitted: (value) {
                          _passwordFocusNode.requestFocus();
                        },
                      ),
                      CustomInput(
                        controller: _passwordTextEditingController,
                        data: Icons.lock,
                        hintText: "Password",
                        isPasswordField: true,
                        textInputAction: TextInputAction.next,
                        validator: (value){
                          if(value.isEmpty){
                            return'The password field cannot be empty';
                          }else if(value.length < 6){
                            return 'The password has to be at least 6 characters long';
                          }
                          return value;
                        },
                        onSubmitted: (value) {
                          _cPasswordFocusNode.requestFocus();
                        },
                      ),
                      CustomInput(
                        controller: _cPasswordTextEditingController,
                        data: Icons.lock,
                        hintText: "Confirm password",
                        isPasswordField: true,
                        textInputAction: TextInputAction.next,
                        validator: (value){
                          if(value.isEmpty){
                            return'The password field cannot be empty';
                          }else if(value.length < 6){
                            return 'The password has to be at least 6 characters long';
                          }else if(_passwordTextEditingController.text !=value){
                            return 'the passwords do not match';
                          }
                          return value;
                        },
                        onSubmitted: (value) {
                          _phoneFocusNode.requestFocus();
                        },
                      ),
                      CustomInput(
                        controller: _phoneTextEditingController,
                        data: Icons.phone,
                        hintText: "Phone number",
                        isPasswordField: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                        validator: (value){
                          if(value.isEmpty){
                            return 'You must enter a valid phone phone number';
                          }
                          return value;
                        },
                        onSubmitted: (value) {
                          uploadAndSaveImage();
                          userProvider.loadSellers();
                        },
                      ),
                    ],
                  )
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 24.0,
                ),
                decoration: BoxDecoration(
                    color: Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      'Choose university: ',
                      style: TextStyle(
                        color: blue,
                        fontSize: 16
                      ),
                    ),
                    DropdownButton(
                      items: universitiesDropdown,
                      onChanged: changeSelectedUniversity,
                      value: _currentUniversity,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Would you like to sell on this platform? ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),),
                    SizedBox(width: 10,),
                    Switch(value: isSeller, onChanged: (value){
                      setState(() {
                        isSeller = value;
                      });
                    }),
                  ],
                ),
              ),
              CustomBtn(
                text: "Create My Account",
                onPressed: (){
                  uploadAndSaveImage();
                },
                isLoading: _registerFormLoading,
              ),
              SizedBox(height: 30,),
              Container(
                height: 2.0,
                width: _screenWidth * 0.8,
                color: Colors.black,
              ),
              SizedBox(height: 15,),
            ],
          ),
        ),
      ),
    );
  }

  Future<void>_selectAndPickImage() async{
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    
  }

  Future<void> uploadAndSaveImage()async {
    if(_imageFile == null) {
      showDialog(context: context,
          builder: (c)
          {
            return ErrorAlertDialog(message: "Please select an image file.",);
          }
      );
    }else
    {
      _passwordTextEditingController.text == _cPasswordTextEditingController.text
          ? _emailTextEditingController.text.isNotEmpty &&
          _nameTextEditingController.text.isNotEmpty &&
          _passwordTextEditingController.text.isNotEmpty &&
          _cPasswordTextEditingController.text.isNotEmpty &&
          _phoneTextEditingController.text.isNotEmpty

          ? uploadToStorage()

          :displayDialog("Please fill and complete the forms")

          : displayDialog("Passwords do not match");
    }
  }

  displayDialog(String msg)
  {
    showDialog(
        context: context,
        builder: (c)
        {
          return ErrorAlertDialog(message:  msg,);
        }
    );
  }

  uploadToStorage() async{

    showDialog(
        context: context,
        builder: (c)
        {
          return LoadingAlertDialog(message: "We are registering you, Please wait......",);
        }
    );

    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

    StorageReference storageReference = FirebaseStorage.instance.ref().child(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).child(imageFileName);

    StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);

    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;

    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImageUrl = urlImage;
      _registerUser();
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  void _registerUser() async{
    FirebaseUser firebaseUser;

    await _auth.createUserWithEmailAndPassword(
        email: _emailTextEditingController.text.trim(),
        password: _passwordTextEditingController.text.trim()
    ).then((result){
      firebaseUser = result.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(context: context,
          builder: (c)
          {
            return ErrorAlertDialog(message: error.message.toString(),);
          });
    });

    if(firebaseUser != null){
      saveUserInfoToFIreStore(firebaseUser).then((value){
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => SelectUniversity());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveUserInfoToFIreStore(FirebaseUser firebaseUser) async {
    Firestore.instance.collection("users").document(firebaseUser.uid).setData({
      "id": firebaseUser.uid,
      "email": firebaseUser.email,
      "name": _nameTextEditingController.text.trim(),
      "imageUrl": userImageUrl,
      "phone": _phoneTextEditingController.text.trim(),
      "isSeller" : isSeller,
      "university": _currentUniversity,
      "isSellerVerified" : isVerified,
    });

    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userUID, firebaseUser.uid);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, firebaseUser.email);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, _nameTextEditingController.text.trim());
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userPhone, _phoneTextEditingController.text.trim());
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.university, _currentUniversity);
    await EcommerceApp.sharedPreferences.setBool(EcommerceApp.isSeller, isSeller);
    await EcommerceApp.sharedPreferences.setBool(EcommerceApp.isSellerVerified, isVerified);


  }

   _getUniversities() async{
    List<UniversityModel> data = await _universityServices.getUniversities();
    print(data.length);
    setState(() {
      university = data;
      universitiesDropdown = getUniversitiesDropdown();
      _currentUniversity = university[0].name;
    });
   }

   void changeSelectedUniversity(String selectedUniversity) {
    setState(() {
      _currentUniversity = selectedUniversity;
    });
   }
}
