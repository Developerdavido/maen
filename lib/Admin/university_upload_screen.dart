import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maen/helpers/university_services.dart';

class UploadUniversity extends StatefulWidget {
  const UploadUniversity({Key key}) : super(key: key);

  @override
  _UploadUniversityState createState() => _UploadUniversityState();
}

class _UploadUniversityState extends State<UploadUniversity> {
  //Add brand
  TextEditingController universityName = TextEditingController();
  UniversityServices _universityService = UniversityServices();
  GlobalKey<FormState> _universityFormKey = GlobalKey<FormState>();
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
              key: _universityFormKey,
              child: SingleChildScrollView(
                child: isLoading ? CircularProgressIndicator() : Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'enter a university name with 10 characters at maximum',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Material(
                        child: TextFormField(
                          controller: universityName,
                          decoration: InputDecoration(hintText: 'name of university'),
                          validator: (value){
                            if(value.isEmpty){
                              return 'you must enter the university name';
                            }else if (value.length > 40){
                              return 'University name cant have more than 40 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: red,
                        textStyle: TextStyle(
                          color: white
                        )
                      ),
                      child: Text('add university',
                      style: TextStyle(
                        color: Colors.white
                      ),),
                      onPressed: (){
                        uploadUniversity();
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
  void uploadUniversity() async {
    if(_universityFormKey.currentState.validate()){
      setState(() {
        return isLoading = true;
      });
      _universityService.createUniversity({
        "name":universityName.text,
      });
      _universityFormKey.currentState.reset();
      setState(() {
        return isLoading = false;
      });
      clearControllers();
      Fluttertoast.showToast(msg: 'university name has successfully been uploaded');
    }else {
      setState(() => isLoading = false);
    }
  }

  clearControllers(){
    universityName.text = "";
  }
}
