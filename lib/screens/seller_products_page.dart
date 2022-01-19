import 'package:flutter/material.dart';
import 'package:maen/models/users.dart';
import 'package:maen/providers/product_provider.dart';
import 'package:maen/screens/product_details.dart';
import 'package:maen/utils/common.dart';
import 'package:maen/utils/config.dart';
import 'package:maen/widgets/category_product.dart';
import 'package:maen/widgets/seller_product.dart';
import 'package:provider/provider.dart';

class SellerProductPage extends StatefulWidget {
  final UserModel userModel;
  const SellerProductPage({Key key, this.userModel}) : super(key: key);

  @override
  _SellerProductPageState createState() => _SellerProductPageState();
}

class _SellerProductPageState extends State<SellerProductPage> {

  Color favColor = Color(0xFFDEDEDE);
  Color orange = Color(0xFFFF4C00);
  Color ash = Color(0xFFECF1F7);
  Color blue = Color(0xFF0007A7);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    height: 80,
                      width: 80,
                      child: CircleAvatar(
                        radius: 40.0,
                        backgroundImage: (widget.userModel.image == null) ?
                        AssetImage('images/admin.png') :
                        NetworkImage(
                          widget.userModel.image
                        ),
                      )),
                ],
              ),
            ),
            Center(
              child: Row(
                children: [
                  Text(widget.userModel.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 4
                  ),),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: showVerified(context),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Expanded(child: GridView.count(
                crossAxisCount: 2,
            childAspectRatio: 0.75,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            padding: EdgeInsets.only(left: 16, right: 16),
            children: productProvider.productsBySeller.map((item) => GestureDetector(
              onTap: (){
                changeScreen(context, ProductDetails(product: item));
              },
              child: SellerProduct(
                product: item,
              ),
            )
            ).toList()
            ))
          ],
        ),
      ),
    );
  }

  showVerified(BuildContext context) {
    if (widget.userModel.isSellerVerified == true){
      return Icon(Icons.check_circle, color: blue, size: 24,);
    } else {
      return Container();
    }
  }
}
