import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maen/models/product.dart';
import 'package:maen/providers/app_provider.dart';
import 'package:maen/providers/user_provider.dart';
import 'package:maen/screens/Cart.dart';
import 'package:maen/utils/common.dart';
import 'package:maen/utils/config.dart';
import 'package:maen/widgets/bottom_sheet.dart';
import 'package:maen/widgets/constants.dart';
import 'package:maen/widgets/custom_dialog.dart';
import 'package:maen/widgets/favorite_dialog.dart';
import 'package:maen/widgets/image_swipe.dart';
import 'package:maen/widgets/product_size.dart';
import 'package:provider/provider.dart';


class Details extends StatefulWidget {
  final ProductModel product;

  const Details({@required this.product});
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

  int quantity = 1;
  final _key = GlobalKey<ScaffoldState>();
  String clothing;
  String shoes;
  
   ProductModel productModel;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   if(widget.product.category.contains(clothing)) {
  //     //TODO: write code for displaying sizes for clothes
  //   }else if(widget.product.category.contains(shoes)){
  //     //TODO: write code for displaying sizes for shoes
  //   }
  //   super.initState();
  // }

  String _selectedProductSize = "0";

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final app = Provider.of<AppProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _key,
          appBar: AppBar (
          backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon:Image.asset("assets/icons/back-arrow.png",
                height: 22,
                width: 22,
                color: Colors.white,),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 16, top: 8, bottom: 8),
                child: Material(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  elevation: 0,
                  child: Container(
                    height: 35.0,
                    width: 35.0,
                    child: CircleAvatar(
                      backgroundImage: (EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl) == null) ?
                      AssetImage('images/admin.png')
                          : NetworkImage(
                        EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          body: Stack(
            children: [
              ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    ImageSwipe(
                      imageList: widget.product.thumbnailUrl,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24.0,
                        left: 24.0,
                        right: 24.0,
                        bottom: 4.0,
                      ),

                      child: Text(
                        widget.product.title,
                        style: Constants.boldHeading,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "\$${widget.product.price}",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        widget.product.longDescription,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "Select Size",
                        style: Constants.regularDarkText,
                      ),
                    ),
                    ProductSize(
                      productSizes: widget.product.sizes,
                      onSelected: (size) {
                        _selectedProductSize = size;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 24,
                      ),
                      child: Row(
                        children: [
                          buildSizedBox(
                              icon: Icons.remove,
                              press: (){
                                if(quantity > 1) {
                                  setState(() {
                                    quantity--;
                                  });
                                }
                              }
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
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: ()  async{
                              app.changeLoading();
                              print("add to favorites started");
                              bool value = await user.addToFavorite(product: widget.product);
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
                                SnackBar(content: Text("Product has noot been added to favorites...... check your internet connection and try again"),);
                              }
                            },
                            child: Container(
                                width: 65.0,
                                height: 65.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFFDCDCDC),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.save,
                                  color: Colors.red,
                                )
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: ()  async{
                                app.changeLoading();
                                print("send to cart started");
                                if( await user.isItemAlreadyAdded(widget.product)) {
                                  print("ITEM IS ALREADY IN CART AND CHECKING FOR SELLERS");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Check your cart, ${widget.product.title} is already added"))
                                  );
                                  await user.increaseQuantityIfItemIsAdded(widget.product, quantity);
                                  user.reloadUserModel();
                                  app.changeLoading();
                                  //TODO: Add changescreen to cart screen later

                                }else if(await user.isSellerIdAlreadyInCart(widget.product)) {
                                  print("CHECKING FOR SELLERS");
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text("you cant add two different sellers in your cart at a time"),
                                  ));
                                  user.reloadUserModel();
                                  app.changeLoading();
                                  showDialog(context: context,
                                      builder: (BuildContext context) => CustomDialog(
                                        title: "continue shopping",
                                        description: "press yes to keep on shopping from the same seller or advance to your shopping bag and checkout",
                                        primaryButtonText: "Yes".toUpperCase(),
                                        secondaryButtonText: "No".toUpperCase(),
                                      ));
                                }
                                else{
                                  bool value = await user.addToCard(product: widget.product, quantity:quantity, size: _selectedProductSize);
                                  if(value){
                                    print("item has been added to cart");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("item has been added to cart"),)
                                    );
                                    user.reloadUserModel();
                                    app.changeLoading();
                                    showDialog(context: context,
                                        builder: (BuildContext context) => CustomDialog(
                                          title: "continue Shopping?",
                                          description: " press yes to keep on shopping or advance to your shopping bag and checkout",
                                          primaryButtonText: "Yes".toUpperCase(),
                                          secondaryButtonText: "No".toUpperCase(),
                                        ));
                                    return;
                                  }
                                }
                              },
                              child: Container(
                                height: 65.0,
                                margin: EdgeInsets.only(
                                  left: 16.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
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
                    )
                  ]
              ),
            ],
          ),
    );
  }

   showContainerDot(BuildContext context) async{
    final user = Provider.of<UserProvider>(context);
     if ( await user.userModel.totalCartPrice == 0 || user.userModel.totalCartPrice == null) {
      return Container(
        height: 10,
        width: 10,
        alignment: Alignment.topRight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.transparent,
        ),
      );


    } else if (user.userModel.totalCartPrice != 0 || user.userModel.totalCartPrice != null) {
      return  Positioned(
        top: 10,
        right: 12,
        child: Container(
          height: 10,
          width: 10,
          alignment: Alignment.topRight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.green,
          ),
        ),
      );
    }
  }
}

  SizedBox buildSizedBox({IconData icon, Function press}) {
    return SizedBox(
      width: 40,
      height: 32,
      child: OutlineButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13)
        ),
        onPressed: press,
        child: Icon(icon),
      ),
    );
  }

class dotColor extends StatelessWidget {
  final Color color;
  final bool isSelected;
  const dotColor({
    Key key,
    this.color,
    this.isSelected = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: 20 / 4,
          right: 20 / 2
      ),
      padding: EdgeInsets.all(2.5),
      height: 24,
      width: 24,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: isSelected ? color : Colors.transparent
          )
      ),
      child: DecoratedBox(
          decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle
          )),
    );
  }
}
