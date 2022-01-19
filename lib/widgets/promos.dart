import 'package:flutter/material.dart';
import 'package:maen/models/product.dart';
import 'package:maen/providers/app_provider.dart';
import 'package:maen/providers/product_provider.dart';
import 'package:maen/providers/user_provider.dart';
import 'package:maen/screens/details.dart';
import 'package:maen/utils/common.dart';
import 'package:maen/widgets/favorite_dialog.dart';
import 'package:maen/widgets/loadingWidget.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';


class Promos extends StatefulWidget {

  final ProductModel product;

  const Promos ({this.product});

  @override
  _PromosState createState() => _PromosState();
}

class _PromosState extends State<Promos> {
  final _key   = GlobalKey<ScaffoldState>();
  ProductModel products;
  ScrollController _scrollController = new ScrollController();
  int pageCount = 1;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _scrollController = ScrollController(initialScrollOffset: 5.0)..addListener(_scrollListener);
  }

  void _scrollListener(){
    if(_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        print("comes to bottom $isLoading");
        isLoading = true;

        if(isLoading){
          print("LOADING MORE CONTENT");
          pageCount = pageCount + 1;

          addItemIntoList(pageCount);
        }
      });
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final user = Provider.of<UserProvider>(context);
    final app = Provider.of<AppProvider>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Container(
          padding: EdgeInsets.all(10),
          child: GridView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.82,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: productProvider.promoProducts.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  changeScreen(
                      context,
                      Details(
                        product: productProvider.promoProducts[index],
                      ));
                },
                child: !productProvider.promoProducts.isNotEmpty ?
                Center(
                  child: circularProgress(),
                )
                    : Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(width: 4, color: Colors.white)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration:
                        BoxDecoration(color: Colors.deepOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16)),
                        child: Center(
                          child: ClipRRect(
                            borderRadius:
                            BorderRadius.all(Radius.circular(16)),
                            child: Hero(
                              tag: productProvider
                                  .promoProducts[index].productId,
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: productProvider
                                    .promoProducts[index].thumbnailUrl[0],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 10),
                          child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productProvider.promoProducts[index].title,
                                        style: TextStyle(
                                            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                      Text(
                                        "\GHC${productProvider.promoProducts[index].price}",
                                        style: TextStyle(
                                            color: Colors.deepOrange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      )
                                    ],
                                  ),
                                  Container(
                                    height: 22,
                                    width: 22,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6)
                                    ),
                                    child: Center(
                                      child: IconButton(
                                        padding: EdgeInsets.all(0.0),
                                        iconSize: 14,
                                        icon: Icon(
                                          Icons.favorite,
                                          size: 18,
                                          color: Colors.deepOrange,
                                        ),
                                        onPressed: () async{
                                          app.changeLoading();
                                          print("add to favorites started");
                                          bool value = await user.addToFavorite(product: productProvider.promoProducts[index]);
                                          if(value){
                                            print("product have been added to favorites");
                                            _key.currentState.showSnackBar(
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
                                  )
                                ],
                              ))),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
  void addItemIntoList(int pageCount) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    for (int i = (pageCount * 5) - 5; i < pageCount; i++){
      productProvider.promoProducts.add(products);
      isLoading =false;
    }
  }
}
