import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maen/helpers/brand_services.dart';

class UploadBrand extends StatefulWidget {
  const UploadBrand({Key key}) : super(key: key);

  @override
  _UploadBrandState createState() => _UploadBrandState();
}

class _UploadBrandState extends State<UploadBrand> {
  //Add brand
  TextEditingController brandName = TextEditingController();
  BrandServices _brandService = BrandServices();
  GlobalKey<FormState> _brandFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    brandName.dispose();
  }
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
              key: _brandFormKey,
              child: SingleChildScrollView(
                child: isLoading ? CircularProgressIndicator() : Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'enter a brand name with 20 characters at maximum',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Material(
                        child: TextFormField(
                          controller: brandName,
                          decoration: InputDecoration(hintText: 'Brand name'),
                          validator: (value){
                            if(value.isEmpty){
                              return 'you must enter the brand name';
                            }else if (value.length > 20){
                              return "Brand name can't have more than 20 characters";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: red,
                      ),
                      child: Text('add brand',
                      style: TextStyle(
                        color: Colors.white
                      ),),
                      onPressed: (){
                        uploadBrand();
                        print("upload brand process started");
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
  void uploadBrand() async {
    print("upload brand process about to start");
    if(_brandFormKey.currentState.validate()){
      print("upload brand process started successfully");
      setState(() {
        return isLoading = true;
      });
          _brandService.createBrand({
            "name":brandName.text,
          });
          _brandFormKey.currentState.reset();
          setState(() {
            return isLoading = false;
          });
          clearControllers();
          Fluttertoast.showToast(msg: 'your brand has successfully been uploaded');
      }else {
        setState(() => isLoading = false);
      }
  }
  clearControllers(){
    brandName.text = "";
  }
}
