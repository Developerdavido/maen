import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maen/models/product.dart';
import 'package:maen/providers/app_provider.dart';
import 'package:maen/providers/comment_provider.dart';
import 'package:maen/providers/user_provider.dart';
import 'package:maen/screens/Cart.dart';
import 'package:maen/utils/common.dart';
import 'package:maen/utils/config.dart';
import 'package:maen/widgets/constants.dart';
import 'package:maen/widgets/custom_dialog.dart';
import 'package:maen/widgets/custom_input.dart';
import 'package:maen/widgets/favorite_dialog.dart';
import 'package:maen/widgets/image_swipe.dart';
import 'package:maen/widgets/product_size.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel product;

  const ProductDetails({@required this.product});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int quantity = 1;
  final _key = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
  String clothing;
  String shoes;

  ProductModel productModel;
  String _selectedProductSize = "0";

  bool closeTopContainer = false;

  Color favColor = Color(0xFFDEDEDE);
  Color orange = Color(0xFFFF4C00);
  Color ash = Color(0xFFECF1F7);
  Color blue = Color(0xFF0007A7);

  TextEditingController _comment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final app = Provider.of<AppProvider>(context);
    final comment = Provider.of<CommentProvider>(context);
    Size size = MediaQuery.of(context).size;
    final double fullHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _key,
      backgroundColor: ash,
      appBar: AppBar(
        backgroundColor: ash,
        elevation: 0,
        leading: IconButton(
          icon:Image.asset("assets/icons/back-arrow.png",
            height: 22,
            width: 22,
            color: Colors.grey,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite,
              size: 24,
              color: favColor,),
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: fullHeight * 0.4,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ImageSwipe(
                  imageList: widget.product.thumbnailUrl,
                  // either use the constructed height or 780.0 of the image and subtract the draggable scroll extent
                  height: fullHeight * 0.4
                ),
              ),
              decoration: BoxDecoration(
                color: ash
              ),
            ),
          ),
           Container(
                child: ListView(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 24.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.product.title.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),),

                                  Text(
                                      "\GHC ${widget.product.price}",
                                      style: TextStyle(
                                          color: blue,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                      )
                                  )
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 24.0,
                              ),
                              child: Text(
                                  widget.product.longDescription,
                                  textAlign: TextAlign.left,
                                  style: Constants.regularDarkText
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 24.0,
                              ),
                              child: Text(
                                "Select Size",
                                style: Constants.regularHeading,
                              ),
                            ),
                            ProductSize(
                              productSizes: widget.product.sizes,
                              onSelected: (size) {
                                _selectedProductSize = size;
                              },
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0, left: 16.0, right: 16.0),
                              child: Divider(
                                height: 1.0,
                                color: Colors.grey,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 24.0,
                              ),
                              child: Text(
                                  "reviews".toUpperCase(),
                                style: TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w700),
                              ),
                            ),

                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 8.0,
                                  left: 24.0,
                                  right: 24.0,
                                  bottom: 64.0
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          child: ListView.builder(
                                              itemCount: comment.comments.length,
                                              itemBuilder: (context, index) {
                                                return comment.comments.length == 0 ?
                                                Center(
                                                  child: Text(
                                                    "There are no reviews for this product yet",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ) :
                                                ListTile(
                                                  title: Text(comment.comments[index].comment),
                                                  subtitle: Text(comment.comments[index].userName, style: TextStyle(fontStyle: FontStyle.italic),),
                                                );
                                              }),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 16.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            //TODO: create a form to get the comment section
                                            Material(
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                              elevation: 0,
                                              child: Container(
                                                height: 45.0,
                                                width: 45.0,
                                                child: CircleAvatar(
                                                  backgroundImage: (EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl) == null) ?
                                                  AssetImage('images/admin.png')
                                                      : NetworkImage(
                                                    EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            CustomInput(
                                              controller: _comment,
                                              hintText: "how is this product?",
                                              keyboardType: TextInputType.text,
                                            ),
                                            Container(
                                              height: 35.0,
                                              width: 35.0,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12.0),
                                                color: blue
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.white,
                                                  size: 24.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white
                ),
              ),
          Positioned(
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        width: 120.0,
                        height: 48.0,
                        decoration: BoxDecoration(
                          color: ash,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            buildSizedBox(
                              icon: Icons.remove,
                              press: (){
                                if(quantity > 1) {
                                  setState(() {
                                    quantity--;
                                  });
                                }
                              },
                            ),
                            Padding(padding: const EdgeInsets.symmetric(
                                horizontal: 20 / 2
                            ),
                              child: Text(
                                "$quantity".toString(),
                                style: Constants.regularDarkText,
                              ),
                            ),
                            buildSizedBox(icon: Icons.add,
                                press: (){
                                  setState(() {
                                    quantity++;
                                  });
                                }),
                          ],
                        ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: ()  async{
                          app.changeLoading();
                          print("send to cart started");
                          if( await user.isItemAlreadyAdded(widget.product)) {
                            print("item is already in cart");
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Check your cart, ${widget.product.title} is already added"))
                            );
                            await user.increaseQuantityIfItemIsAdded(widget.product, quantity);
                            user.reloadUserModel();
                            app.changeLoading();
                            //TODO: Add changescreen to cart screen later
                            changeScreen(context, CartScreen());

                          }else if(await user.isSellerIdAlreadyInCart(widget.product)){
                            print("CHECKING FOR SELLERS");
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("you can't add two different sellers in your cart at a time"),
                            ));
                            user.reloadUserModel();
                            app.changeLoading();
                            showDialog(context: context,
                                builder: (BuildContext context) => CustomDialog(
                                  title: "continue shopping?".toUpperCase(),
                                  description: "Will you like to continue shopping from the same seller?",
                                  primaryButtonText: "Yes".toUpperCase(),
                                  secondaryButtonText: "No".toUpperCase(),
                                ));

                          }else {
                            bool value = await user.addToCard(product: widget.product, quantity:quantity, size: _selectedProductSize);
                            if(value){
                              print("item has been added to cart");
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("${widget.product.title} has been added to cart"),)
                              );
                              user.reloadUserModel();
                              app.changeLoading();
                              showDialog(context: context,
                                  builder: (BuildContext context) => CustomDialog(
                                    title: "continue Shopping?".toUpperCase(),
                                    description: " Will you like to checkout?",
                                    primaryButtonText: "Yes".toUpperCase(),
                                    secondaryButtonText: "No".toUpperCase(),
                                  ));
                              return;
                            }
                          }
//                                             else {
//                                                print("Item has not been added to cart!");
//                                                SnackBar(content: Text("Item has not been added to cart...... please try again"),);
//                                              }
                        },
                        child: Container(
                          height: 48.0,
                          margin: EdgeInsets.only(
                            left: 16.0,
                          ),
                          decoration: BoxDecoration(
                            color: blue,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Add To Cart",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future addToFavorite()  async{
    final user = Provider.of<UserProvider>(context);
    final app = Provider.of<AppProvider>(context);
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
            title: "Your Fav".toUpperCase(),
            description: "Will you like to view your favorite list?",
            primaryButtonText: "YES".toUpperCase(),
            secondaryButtonText: "NO".toUpperCase(),
          ));
      return;
    }else{
      print("Product has not been added to favorites");
      SnackBar(content: Text("Product has not been added to favorites...... check your internet connection and try again"),);
    }
  }
}



SizedBox buildSizedBox({IconData icon, Function press}) {
  return SizedBox(
    width: 32,
    height: 32,
    child: TextButton(
      style: TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: Color(0xFF0007A7),
        padding: const EdgeInsets.all(2.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
      onPressed: press,
      child: Icon(icon),
    ),
  );
}

// class dotColor extends StatelessWidget {
//   final Color color;
//   final bool isSelected;
//   const dotColor({
//     Key key,
//     this.color,
//     this.isSelected = false
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(
//           top: 20 / 4,
//           right: 20 / 2
//       ),
//       padding: EdgeInsets.all(2.5),
//       height: 24,
//       width: 24,
//       decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           border: Border.all(
//               color: isSelected ? color : Colors.transparent
//           )
//       ),
//       child: DecoratedBox(
//           decoration: BoxDecoration(
//               color: color,
//               shape: BoxShape.circle
//           )),
//     );
//   }
// }
