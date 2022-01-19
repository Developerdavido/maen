import 'package:flutter/material.dart';
import 'package:maen/screens/Cart.dart';
import 'package:maen/screens/category_page.dart';
import 'package:maen/screens/favorite_screen.dart';
import 'package:maen/screens/seller_page.dart';
import 'package:maen/screens/store_home.dart';

class NavigationController extends StatefulWidget {
  @override
  _NavigationControllerState createState() => _NavigationControllerState();
}

class _NavigationControllerState extends State<NavigationController> {
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  final List<Widget> _children = [
    StoreHome(),
    SellerPage(),
    FavoriteScreen(),
    CartScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16, 5, 16, 5),
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.transparent,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            child: BottomNavigationBar(items:
            [
              BottomNavigationBarItem(icon: Icon(Icons.home),
                label:
                  "Store",
              ),

              BottomNavigationBarItem(icon: Icon(Icons.store_rounded),
                label:
                  "Category",
              ),

              BottomNavigationBarItem(icon: Icon(Icons.favorite),
                label:
                  "Favorite",
                ),

              BottomNavigationBarItem(icon: Icon(Icons.shopping_bag),
                label:
                  "Cart",
              ),


            ],
              onTap: onTapped,
              currentIndex: _page,
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              iconSize: 24,
              selectedFontSize: 12,
              unselectedFontSize: 8,
            ),
          ),
        ),

      ),
      body: _children[_page],
    );
  }

  void onTapped(int index) {
    setState(() {
      _page = index;
    });
  }
}