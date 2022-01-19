import 'package:flutter/material.dart';
import 'package:maen/models/product.dart';
import 'package:maen/providers/app_provider.dart';
import 'package:maen/providers/comment_provider.dart';
import 'package:maen/providers/product_provider.dart';
import 'package:maen/providers/user_provider.dart';
import 'package:maen/screens/details.dart';
import 'package:maen/screens/product_details.dart';
import 'package:maen/theme/theme.dart';
import 'package:maen/utils/common.dart';
import 'package:maen/widgets/favorite_dialog.dart';
import 'package:maen/widgets/loading.dart';
import 'package:maen/widgets/loadingWidget.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class New extends StatefulWidget {

  final ProductModel product;

  const New ({this.product});
  @override
  _NewState createState() => _NewState();
}

class _NewState extends State<New> {
  final _key   = GlobalKey<ScaffoldState>();
  ProductModel products;
  ScrollController _scrollController = new ScrollController();
  int pageCount = 1;
  bool isLoading = false;
  bool closeTopContainer = false;

  Color favColor = Color(0xFFDEDEDE);
  Color orange = Color(0xFFFF4C00);
  Color ash = Color(0xFFECF1F7);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _scrollController = ScrollController(initialScrollOffset: 5.0)..addListener(_scrollListener);

    _scrollController.addListener(() {
      setState(() {
       closeTopContainer = _scrollController.offset > 50;
      });
    });
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
    final commentProvider = Provider.of<CommentProvider>(context);
    final user = Provider.of<UserProvider>(context);
    final app = Provider.of<AppProvider>(context);
    final double categoryHeight = MediaQuery.of(context).size.height * 0.20;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: closeTopContainer ? 0: categoryHeight,
              width: MediaQuery.of(context).size.width * 0.9,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: ash
              ),
              child: ListView.builder(
                  itemCount: productProvider.promoProducts.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: (){
                      changeScreen(
                          context, ProductDetails(product: productProvider.promoProducts[index])
                      );
                    },
                    child: Container(
                      height: categoryHeight,
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: productProvider
                                .promoProducts[index].thumbnailUrl[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  )),
            ),
            Expanded(
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
                    itemCount: productProvider.productsByUniversity.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        commentProvider.loadComments(productId: productProvider.productsByUniversity[index].productId);
                        changeScreen(
                            context,
                             ProductDetails(
                              product: productProvider.productsByUniversity[index],
                            ));
                      },
                      child: !productProvider.productsByUniversity.isNotEmpty ?
                      Center(
                        child: circularProgress(),
                      )
                          : Container(
                        decoration: BoxDecoration(
                            color: ash,
                            borderRadius: BorderRadius.circular(16),),
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
                                    tag: productProvider
                                        .productsByUniversity[index].productId,
                                    child: FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: productProvider
                                          .productsByUniversity[index].thumbnailUrl[0],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                child: Container(
                                    child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              productProvider.productsByUniversity[index].title,
                                              style: TextStyle(
                                                  color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "\GHC${productProvider.productsByUniversity[index].price}",
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
                                                      bool value = await user.addToFavorite(product: productProvider.productsByUniversity[index]);
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
                        ),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void addItemIntoList(int pageCount) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    for (int i = (pageCount * 5) - 5; i < pageCount; i++){
      productProvider.productsByUniversity.add(products);
      isLoading =false;
    }
  }
}
