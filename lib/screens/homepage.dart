import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:maen/providers/app_provider.dart';
import 'package:maen/providers/category_provider.dart';
import 'package:maen/providers/product_provider.dart';
import 'package:maen/providers/shop_provider.dart';
import 'package:maen/providers/user_provider.dart';
import 'package:maen/screens/Cart.dart';
import 'package:maen/screens/category_screen.dart';
import 'package:maen/screens/favorite_screen.dart';
import 'package:maen/screens/login.dart';
import 'package:maen/screens/orders.dart';
import 'package:maen/utils/common.dart';
import 'package:maen/widgets/loading.dart';
import 'package:maen/widgets/new_products.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final app = Provider.of<AppProvider>(context);
    final shopProvider = Provider.of<ShopProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: Builder(builder: (context) => IconButton(
              icon: Image.asset("assets/icons/menu.png",
              height: 18,
              width: 24,
              color: Colors.red,),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              })),
          title: Text(
            "MAEN",
            style: TextStyle(color: Colors.red),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Container(
              height: 50,
              width: 50,
              color: Colors.transparent,
              child: Stack(
                children: [
                  IconButton(
                    icon: Image.asset("assets/icons/shopping-bag.png",
                      height: 22,
                      width: 22,
                    color: Colors.red,),
                    onPressed: () {
                      changeScreen(context, CartScreen());
                    },
                  ),
                  showContainerDot(context),
                ],
              ),
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
                accountName: Text(
                  user.userModel?.name ?? "username loading...",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                accountEmail: Text(
                  user.userModel?.email ?? "email loading...",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                onTap: () {
                  changeScreen(context, HomePage());
                },
                leading: Image.asset("assets/icons/home-shop.png",
                  height: 18,
                  width: 24,
                  color: Colors.red,),
                title: Text(
                  "Home",
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w400),
                ),
              ),
              ExpansionTile(
                title: Text("Categories",
                style: TextStyle(
                  color: Colors.black54, fontWeight: FontWeight.w400
                ),),
                leading: Image.asset("assets/icons/categories.png",
                  height: 18,
                  width: 24,
                  color: Colors.red,),
                children: [
                  Column(
                    children: [
                        Container(
                          height: 160,
                          child: ListView.builder(
                            itemCount: categoryProvider.categories.length,
                              itemBuilder: (_, index) {
                            return GestureDetector(
                              onTap: ()async{
                                await productProvider.loadProductsByCategory(categoryName: categoryProvider.categories[index].name);
                                changeScreen(context, CategoryScreen(categoryModel: categoryProvider.categories[index]));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0, top: 8, left: 70),
                                child: Text(
                                    categoryProvider.categories[index].name,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w400
                                    ),
                                ),
                              ),
                            );
                          }),
                        ),

                    ],
                  )
                ],
              ),
              ListTile(
                onTap: () {
                  user.getOrders();
                  changeScreen(context, OrderScreen());
                },
                leading: Icon(Icons.bookmark_border,
                color: Colors.red,),
                title: Text(
                  "My orders",
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w400),
                ),
              ),
              ListTile(
                onTap: () {
                  changeScreen(context, FavoriteScreen());
                },
                leading: Icon(Icons.favorite,
                color: Colors.red,),
                title: Text(
                  "Favorites",
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w400),
                ),
              ),
              ListTile(
                onTap: () {
                  changeScreen(context, CartScreen());
                },
                leading: Image.asset("assets/icons/shopping-bag.png",
                  height: 18,
                  width: 24,
                  color: Colors.red,),
                title: Text(
                  "Cart",
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w400),
                ),
              ),
              ListTile(
                onTap: () {
                  user.signOut();
                  changeScreenReplacement(context, LoginScreen());
                },
                leading: Image.asset("assets/icons/sign-out.png",
                  height: 18,
                  width: 24,
                  color: Colors.red,),
                title: Text(
                  "Sign out",
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: DefaultTabController(
            length: 3,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  //creating the container for promoted product
                  Container(
                    width: double.infinity,
                    height: 200.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16)),
                        color: Colors.white),
                    child: Stack(
                      children: <Widget>[
                        CarouselSlider.builder(
                            itemCount: productProvider.promotedProducts.length,
                            itemBuilder: (context, index) => Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Loading(),
                                      )),
                                  Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(16)),
                                      child: FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: productProvider.promotedProducts[index].thumbnailUrl[0], fit: BoxFit.cover,),

                                    ),
                                  )
                                ],
                              ),
                            ), options: CarouselOptions(
                          height: 200,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 2.0,
                          scrollDirection: Axis.horizontal,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          autoPlayAnimationDuration: Duration(milliseconds: 8)
                        ))
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, -15),
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.only(left: 20, top: 8),
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[350],
                                blurRadius: 20.0,
                                offset: Offset(0, 10.0))
                          ],
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.white),
                      child: TextField(
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.search,
                              color: Colors.red,),
                            border: InputBorder.none,
                            hintText: 'Search for products'),
                      ),
                    ),
                  ),
                  TabBar(
                    isScrollable: true,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Colors.red,
                    indicatorWeight: 5.0,
                    tabs: <Widget>[
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "NEW",
                              style: TextStyle(fontSize: 18, color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "FRESH",
                              style: TextStyle(fontSize: 18, color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "DEALS",
                              style: TextStyle(fontSize: 18, color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 400.0,
                      child: TabBarView(
                        children: <Widget>[
                          New(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  showContainerDot(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final app = Provider.of<AppProvider>(context);
    if (user.userModel.totalCartPrice == 0 || user.userModel.totalCartPrice == null) {
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
