import 'package:flutter/material.dart';
import 'package:maen/models/product.dart';
import 'package:maen/models/users.dart';
import 'package:maen/providers/app_provider.dart';
import 'package:maen/providers/user_provider.dart';
import 'package:maen/widgets/favorite_dialog.dart';
import 'package:maen/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class SellerProduct extends StatefulWidget {
  final ProductModel product;
  const SellerProduct({Key key, this.product}) : super(key: key);

  @override
  _SellerProductState createState() => _SellerProductState();
}

class _SellerProductState extends State<SellerProduct> {

  Color favColor = Color(0xFFDEDEDE);
  Color orange = Color(0xFFFF4C00);
  Color ash = Color(0xFFECF1F7);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final app = Provider.of<AppProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: ash,
            borderRadius: BorderRadius.circular(16),
          ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: 130,
                    width: double.infinity,
                    decoration:
                    BoxDecoration(color: ash,
                        borderRadius: BorderRadius.circular(16)),
                    child: Center(
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.all(Radius.circular(16)),
                        child: Hero(
                          tag: widget.product.productId,
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: widget.product.thumbnailUrl[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 10),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.title,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\GHC${widget.product.price}",
                              style: TextStyle(
                                  color: orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                            Center(
                              child: IconButton(
                                padding: EdgeInsets.all(0.0),
                                iconSize: 14,
                                icon: Icon(
                                  Icons.favorite,
                                  size: 18,
                                  color: favColor,
                                ),
                                onPressed: () async{
                                  app.changeLoading();
                                  print("add to favorites started");
                                  bool value = await user.addToFavorite(product: widget.product);
                                  if(value){
                                    print("product have been added to favorites");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Product has been added to favorites list"),)
                                    );
                                    user.reloadUserModel();
                                    app.changeLoading();
                                    showDialog(context: context,
                                        builder: (BuildContext context) => FavoriteDialog(
                                          title: "Continue shopping?",
                                          description: "Will you like to view your favorite list?",
                                          primaryButtonText: "YES".toUpperCase(),
                                          secondaryButtonText: "NO".toUpperCase(),
                                        ));
                                    return;
                                  }else{
                                    print("Product has not been added to favorites");
                                    SnackBar(content: Text("Product has not been added to favorites...... check your internet connection and try again"),);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),),
              ],
            )),
      ],
    );
  }
}
